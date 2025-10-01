@echo off

REM Script to create necessary directories for Docker volumes
if not exist ".\volumes\postgres-data" mkdir ".\volumes\postgres-data"