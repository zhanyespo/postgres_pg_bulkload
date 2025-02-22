import pandas as pd
import os
import math

# Define paths
data_folder = "data"
output_file = "init-scripts/create_tables_new_AVOID.sql"

# Ensure output directory exists
os.makedirs(os.path.dirname(output_file), exist_ok=True)

# List all CSV files in the data folder
csv_files = [f for f in os.listdir(data_folder) if f.endswith(".csv")]

def round_to_nearest_power_of_16(value):
    if pd.isna(value) or value is None:  # Handle NaN cases
        return "VARCHAR(16)"  # Default to VARCHAR(16) for empty columns
    
    powers = [16, 32, 64, 128, 256, 512, 1024]  # Valid sizes up to 1024

    # If value exceeds 1024, use TEXT instead of VARCHAR(n)
    if value > 1024:
        return "TEXT"
    
    return f"VARCHAR({next(p for p in powers if p >= value)})"


# Function to infer PostgreSQL column types
def infer_pg_type(series):
    if pd.api.types.is_integer_dtype(series):
        return "INTEGER"
    elif pd.api.types.is_float_dtype(series):
        return "REAL"
    elif pd.api.types.is_bool_dtype(series) or series.astype(str).str.lower().isin(["true", "false", "1", "0"]).all():
        return "BOOLEAN"
    else:
        max_len = series.dropna().astype(str).apply(len).max()  # Ensure NaN values are ignored
        rounded_length = round_to_nearest_power_of_16(max_len)
        return f"{rounded_length}"

# Start writing to SQL file
with open(output_file, "w") as f:
    f.write("-- Automatically generated SQL script\n\n")

    # Add DROP TABLE statements first
    f.write("-- Dropping existing tables if they exist\n")
    for csv_file in csv_files:
        table_name = os.path.splitext(csv_file)[0]
        f.write(f"DROP TABLE IF EXISTS {table_name} CASCADE;\n")
    f.write("\n")

    # Generate CREATE TABLE statements
    for csv_file in csv_files:
        csv_path = os.path.join(data_folder, csv_file)

        # Load a sample of the CSV file to infer column types
        df = pd.read_csv(csv_path, low_memory=False, nrows=5000)

        # Define table name (same as file name, without .csv)
        table_name = os.path.splitext(csv_file)[0]

        # Generate CREATE TABLE statement
        create_table_sql = f"CREATE TABLE IF NOT EXISTS {table_name} (\n"
        for col in df.columns:
            pg_type = infer_pg_type(df[col])
            create_table_sql += f"    {col} {pg_type},\n"

        create_table_sql = create_table_sql.rstrip(",\n") + "\n);\n\n"

        # Write to SQL file
        f.write(create_table_sql)
        print(f"✅ Generated table schema for {csv_file}")

# Print output confirmation
print(f"\n📂 All table schemas saved to '{output_file}'")
