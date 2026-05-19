--This script is an automated data ingestion pipeline that fetches daily English Premier League match data from an external API, stores it locally, and logs execution results for monitoring and debugging.

Pipeline Overview 

The script runs once per execution and performs the following steps:
1. Environment Setup
Loads environment variables from .env (API credentials and base URL)
2. Date-Based Execution
Generates today's date in YYYY-MM-DD format
Uses it to create:
A structured output file path
A dedicated log file for that run
3. Directory Preparation
Ensures required folders exist:
data/raw/ → stores fetched JSON data
logs/ → stores execution logs
4. Idempotency Check (Avoid Duplicate Fetching)

Before making any API request, the script checks:

If today's data file already exists
And its size is greater than 100 bytes

If both conditions are true:

The script skips execution
Logs a SKIPPED event
Exits safely

This ensures the pipeline is idempotent (safe to rerun without duplication).

5. API Request Construction
Builds the request URL dynamically:
(/competitions/PL/matches?dateFrom=TODAY&dateTo=TODAY)
Targets Premier League matches for the current date

6. Data Fetching
Sends an HTTP request using curl
Authenticates using API key (X-Auth-Token)
Stores raw API response in a temporary file
Captures HTTP status code for validation

7. Success Handling (HTTP 200)

If the request succeeds:

Moves temporary file to permanent storage:

data/raw/raw_footballflow_YYYY-MM-DD.json
Logs success with timestamp and file path

8. Failure Handling

If the request fails:

Reads API error response from temporary file
Logs:
Timestamp
HTTP status code
Error message
Deletes temporary file to prevent clutter
---
This pipeline is scheduled to run automatically every day at 07:00 AM using cron

What it does
Runs the data pipeline daily without manual intervention
Fetches Premier League match data
Logs execution output and errors
Ensures automated data ingestion
