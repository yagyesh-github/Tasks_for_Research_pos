# Tasks_for_Research_pos
This repository has the detailed work on tasks mentioned below.


## Task 1: Real-Time Air Quality Monitoring (PurpleAir API)
This section demonstrates the ability to automate data collection and handle API requests.

### Features
- Automation: Utilizes crontab in WSL to fetch data every 5 minutes during specific observation windows.

- Multi-Sensor Support: Bash scripts utilize arrays and loops to query multiple sensor indices (e.g., 211511) in a single run.

- Data Persistence: API responses are parsed using jq and appended to a structured .csv file for long-term analysis.

- Error Logging: Implements detailed logging to track successful API calls or connection failures.
