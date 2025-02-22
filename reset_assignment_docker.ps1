# Stop all running containers related to assignment project
$containers = docker ps -aq --filter "name=postgres_container"
if ($containers) {
    docker stop $containers
    docker rm -f $containers
}

# Remove Docker images related to PostgreSQL
$images = docker images -q "postgres:14"
if ($images) {
    docker rmi -f $images
}

# Remove all volumes related to the assignment
$volumes = docker volume ls -q --filter "name=postgres_data"
if ($volumes) {
    docker volume rm $volumes
}

# Remove any unused networks (Optional)
docker network prune -f

# Rebuild and start the project with Docker Compose
docker-compose up -d --build

# Verify everything is running
docker ps
