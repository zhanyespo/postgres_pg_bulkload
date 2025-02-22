# Base image with PostgreSQL 14
FROM postgres:14

# Set environment variables
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=postgres

# Install required dependencies with PostgreSQL 14 dev headers
RUN apt-get update && \
    apt-get install -y wget gcc make libpq-dev unzip postgresql-server-dev-14 \
                       libreadline-dev zlib1g-dev libselinux1-dev libzstd-dev \
                       liblz4-dev libpam0g-dev libkrb5-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download, build, and install pg_bulkload
RUN wget https://github.com/ossc-db/pg_bulkload/archive/refs/heads/master.zip && \
    unzip master.zip && \
    cd pg_bulkload-master && \
    make && \
    make install && \
    cd .. && rm -rf pg_bulkload-master master.zip

# Expose PostgreSQL port
EXPOSE 5432

# Start PostgreSQL server
CMD ["postgres"]
