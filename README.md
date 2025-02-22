# Assignment-1-zyesposs

# **README: PostgreSQL Data Setup and Execution Guide**

## ✅ **0. Local Statistics of execution**

 ```
Setup started at: Sat Feb 22 08:42:20 +05 2025
Starting setup process...
Docker is installed.
... 
Setup completed at: Sat Feb 22 08:45:45 +05 2025
Total time taken: 3 minutes and 25 seconds
! Do not forget to run docker-compose down
 ```
more details refer to logs /data/logs/execution_assignment1.log

## ✅ **1. Project Structure**

```
ASSIGNMENT-1/
│
├── data/
│   ├── csv_files/                # CSV files for loading into PostgreSQL
│   │   ├── authors.csv
│   │   ├── comments.csv
│   │   ├── submissions.csv
│   │   └── subreddits.csv
│   │
│   └── logs/                     # Log files for the process
│       ├── authors_bulkload.log
│       ├── comments_bulkload.log
│       ├── execution_assignment1.log
│       ├── submissions_bulkload.log
│       └── subreddits_bulkload.log
│
├── init-scripts/                 # SQL and shell scripts for DB setup
│   ├── ctls/                     # Control files for pg_bulkload
│   │   ├── authors.ctl
│   │   ├── comments.ctl
│   │   ├── submissions.ctl
│   │   └── subreddits.ctl
│   │
│   ├── create_relationships.sql  # SQL script for creating FK relationships
│   ├── create_tables.sql         # SQL script for creating tables
│   ├── create_tables copy.sql    # (Backup copy of create_tables.sql)
│   ├── load_data.sql             # Optional: COPY-based data load (not used)
│   ├── queries.sql               # SQL script for queries
│   ├── pd_define_metadata.py     # Python script for metadata
│   ├── generate_ctl_files.sh     # Script to generate .ctl files for bulkload
│   └── load_data.sh              # Bulkload execution script
│
├── venv/                         # Python virtual environment
│   └── (venv structure)
│
├── .gitignore                    # Git ignored files and folders
├── assignment1.sh                # Main execution script (RUN THIS FILE)
├── docker-compose.yml            # Docker Compose file for PostgreSQL
├── Dockerfile                    # Dockerfile for custom PostgreSQL setup
├── README.md                     # This README file
├── requirements.txt              # Python dependencies (not all libs required. Important one is pandas)(optional)
└── reset assignment docker.ps1    # PowerShell script for Docker reset (optional)
```

---

## ✅ **2. Prerequisites**

Make sure the following tools are installed:

- **Docker & Docker Compose**  
  ```bash
  docker --version
  docker-compose --version
  ```

- **Python 3.x and pip**  
  ```bash
  python3 --version
  pip --version
  ```

---

## ✅ **3. How to Run the Script**

### **Step 1: Make the Script Executable**

```bash
chmod +x assignment1.sh
```

### **Step 2: Run the Script**

```bash
./assignment1.sh
```

This will:

- Check for Docker installation.
- Verify CSV files.
- Set up a Python virtual environment.
- Start Docker Compose for PostgreSQL.
- Create tables and relationships.
- Load data using `pg_bulkload`.
- Execute queries.
- Log all activities to `data/logs/execution_assignment1.log`.

### **Step 3: Stop Docker Compose After Execution**

```bash
docker-compose down
```

---

## ✅ **4. Important Scripts**

| **Script**                    | **Purpose**                               |
|-------------------------------|-------------------------------------------|
| `assignment1.sh`              | **Main execution script** (Run this one) |
| `generate_ctl_files.sh`       | Generates `.ctl` files for bulk loading  |
| `load_data.sh`                | Executes `pg_bulkload` for data loading  |
| `pd_define_metadata.py`       | Python script to define metadata (optional) |
| `reset assignment docker.ps1` | PowerShell script to reset Docker        |

---

## ✅ **5. Log Files**

All outputs and errors are logged to:

```
data/logs/execution_assignment1.log
```

Additional bulkload logs per table:

- `authors_bulkload.log`
- `comments_bulkload.log`
- `submissions_bulkload.log`
- `subreddits_bulkload.log`

---

## ✅ **6. .gitignore Setup**

The following files/folders are ignored by Git:

```
# Virtual environment
venv/

# Log files
data/logs/

# Docker files
*.ps1
```

---

## ✅ **7. Common Issues & Fixes**

1. **CSV Files Not Found:**  
   Ensure `authors.csv`, `comments.csv`, `submissions.csv`, and `subreddits.csv` are in `data/csv_files/`.

2. **Docker Not Running:**  
   ```bash
   sudo systemctl start docker
   ```

3. **Virtual Environment Activation Issue:**  
   ```bash
   source venv/bin/activate
   ```

4. **Permission Denied:**  
   ```bash
   chmod +x assignment1.sh
   chmod +x init-scripts/*.sh
   ```

---

## ✅ **8. Notes**

- **Data Loading:**  
  `pg_bulkload` is used for faster data loading. The `load_data.sql` (COPY-based) is skipped as it is slower(8 mins).

- **Execution Time:**  
  The script tracks the start and end time, showing the total execution time in minutes and seconds.

- **Log Monitoring:**  
  Use this command to monitor logs in real-time:

  ```bash
  tail -f data/logs/execution_assignment1.log
  ```

---

## ✅ **9. Final Thoughts**

While this setup might have some complex components, they were intentionally included to improve performance and maintain best practices. The use of Docker, virtual environments, and bulk data loading tools like `pg_bulkload` ensures that the setup is both efficient and scalable. Every part of this project was handled with precision and seriousness to deliver a robust solution.

**End of README**

