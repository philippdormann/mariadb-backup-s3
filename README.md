# MySQL/MariaDB S3 docker/kubernetes backup

[![Build status](https://github.com/philippdormann/mariadb-backup-s3/workflows/Docker%20Image%20CI/badge.svg)]() [![Pulls](https://img.shields.io/docker/pulls/philippdormann/mariadb-backup-s3?style=flat&labelColor=1B3D4B&color=06A64F&logoColor=white&logo=docker&label=pulls)]()

Docker image to backup MySQL or MariaDB (or PerconaDB) database to S3 using mysqldump and compress using pigz.

## Features
- [x] Supports custom S3 endpoints (e.g. minio)
- [x] Uses piping instead of tmp file
- [x] Compression is done with pigz (parallel gzip)
- [x] Can be run in Kubernetes or Docker
- [x] Backup all databases
- [x] Backup schedule

## Configuration
```bash
- FILE_PREFIX=
- S3_BUCKET=
- S3_ACCESS=
- S3_SECRET=
- S3_SERVER=
- DB_USER=
- DB_PASSWORD=
- DB_HOST=
- DB_PORT=# (optional) defaults to 3306
- WAIT_SECONDS=86400
- INITIAL_BACKUP=yes
```

Or see `docker-compose.yml` file to run this container with Docker.

## Cron backup with kubernetes

See `kubernetes-cronjob.yml` file.
