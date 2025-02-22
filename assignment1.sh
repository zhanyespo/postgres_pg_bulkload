#!/bin/bash


# Define log file path
LOG_FILE="./data/logs/execution_assignment1.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

# Capture start time
start_time=$(date +%s)
echo "Setup started at: $(date)"

DATA_DIR="./data/csv_files"
INIT_SCRIPTS_DIR="./init-scripts"
POSTGRES_CONTAINER="postgres_container"
DOCKER_COMPOSE_FILE="docker-compose.yml"
VENV_DIR="./venv"

SQL_FILES=("create_tables.sql" "create_relationships.sql" "load_data.sql" "queries.sql")

check_docker_installed() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Please install Docker and restart this script."
        exit 1
    else
        echo "Docker is installed."
    fi
}

check_csv_files() {
    CSV_FILES=("authors.csv" "submissions.csv" "comments.csv" "subreddits.csv")
    for file in "${CSV_FILES[@]}"; do
        if [ ! -f "$DATA_DIR/$file" ]; then
            echo "Missing CSV file: $file. Please place it in $DATA_DIR and restart."
            exit 1
        fi
    done
    echo "All required CSV files are present in $DATA_DIR."
}

setup_venv() {
    echo "Setting up Python virtual environment..."
    if [ ! -d "$VENV_DIR" ]; then
        echo "Creating virtual environment..."
        python -m venv "$VENV_DIR"
    fi

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        source "$VENV_DIR/Scripts/activate"
    else
        source "$VENV_DIR/bin/activate"
    fi

    echo "Installing dependencies from requirements.txt..."
    pip install --upgrade pip
    pip install -r requirements.txt
    echo "Virtual environment setup complete."
}

generate_ddl() {
    echo "Running Python script to generate DDL..."
    if [ ! -f "$INIT_SCRIPTS_DIR/pd_define_metadata.py" ]; then
        echo "Error: Python script 'pd_define_metadata.py' not found in $INIT_SCRIPTS_DIR"
        exit 1
    fi

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        SCRIPT_PATH="$(cygpath -w "$(pwd)/$INIT_SCRIPTS_DIR/pd_define_metadata.py")"
    else
        SCRIPT_PATH="$(realpath "$INIT_SCRIPTS_DIR/pd_define_metadata.py")"
    fi

    echo "SCRIPT_PATH resolved to -> $SCRIPT_PATH"

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        source "$VENV_DIR/Scripts/activate"
    else
        source "$VENV_DIR/bin/activate"
    fi

    python "$SCRIPT_PATH"
    if [ $? -ne 0 ]; then
        echo "Failed to generate DDL. Please check the Python script."
        exit 1
    fi

    echo "DDL generation completed."
}

check_sql_files() {
    for file in "${SQL_FILES[@]}"; do
        if [ ! -f "$INIT_SCRIPTS_DIR/$file" ]; then
            echo "Missing SQL file: $file. Ensure all required SQL scripts are present in $INIT_SCRIPTS_DIR."
            exit 1
        fi
    done
    echo "All required SQL files are present."
}

start_docker_compose() {
    echo "Starting Docker Compose..."
    docker-compose up -d
    if [ $? -ne 0 ]; then
        echo "Failed to start Docker Compose. Please check the Docker setup."
        exit 1
    fi
    echo "Docker Compose started successfully."
}

check_postgres_container() {
    echo "Checking PostgreSQL container status..."
    if ! docker ps | grep -q "$POSTGRES_CONTAINER"; then
        echo "PostgreSQL container is not running. Please check Docker."
        exit 1
    fi
    echo "PostgreSQL container is running."
}

execute_sql_in_postgres() {
    local sql_file=$1
    echo "Executing $sql_file in PostgreSQL..."
    docker exec -i "$POSTGRES_CONTAINER" psql -U postgres -d postgres < "$INIT_SCRIPTS_DIR/$sql_file"
    if [ $? -ne 0 ]; then
        echo "Failed to execute $sql_file in PostgreSQL."
        exit 1
    fi
    echo "Successfully executed $sql_file."
}

execute_pg_bulkload() {
    local bulkload_script=$1
    echo "Starting pg_bulkload using $bulkload_script..."
    chmod +x "$INIT_SCRIPTS_DIR/$bulkload_script"
    docker exec -i "$POSTGRES_CONTAINER" bash "$INIT_SCRIPTS_DIR/$bulkload_script"
    if [ $? -ne 0 ]; then
        echo "Failed to execute $bulkload_script using pg_bulkload."
        exit 1
    fi
    echo "Successfully executed $bulkload_script with pg_bulkload."
}

run_queries() {
    echo "Running queries..."
    docker exec -i "$POSTGRES_CONTAINER" psql -U postgres -d postgres < "$INIT_SCRIPTS_DIR/queries.sql"
    if [ $? -ne 0 ]; then
        echo "Failed to execute queries.sql."
        exit 1
    fi
    echo "Query execution completed."
}

echo "Starting setup process..."

check_docker_installed
check_csv_files
setup_venv
# generate_ddl <<< AVOID: do not run it. I was used to generate best metadata. Latest best run below in cycle.
check_sql_files
start_docker_compose
check_postgres_container

# Execute SQL scripts in order
execute_sql_in_postgres "create_tables.sql"
# execute_sql_in_postgres "load_data.sql" <<< AVOID: do not run it or enable it. was used previously for testing load with /copy that took upto 8 mins.
execute_pg_bulkload "generate_ctl_files.sh"
execute_pg_bulkload "load_data.sh"
execute_sql_in_postgres "create_relationships.sql"
execute_sql_in_postgres "queries.sql"

echo "Setup completed successfully."

# Capture end time
end_time=$(date +%s)
echo "Setup completed at: $(date)"

# Calculate duration in seconds and convert to minutes
duration=$((end_time - start_time))
duration_minutes=$((duration / 60))
duration_seconds=$((duration % 60))

echo "Total time taken: ${duration_minutes} minutes and ${duration_seconds} seconds"

echo "! Do not forget to run docker-compose down"