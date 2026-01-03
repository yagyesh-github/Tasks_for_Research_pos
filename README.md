# Tasks_for_Research_pos
This repository has the detailed work on tasks mentioned below.


## Task 1: Real-Time Air Quality Monitoring (PurpleAir API)
This section demonstrates the ability to automate data collection and handle API requests.

### Features
- Automation: Utilizes crontab in WSL to fetch data every 5 minutes during specific observation windows.

- Multi-Sensor Support: Bash scripts utilize arrays and loops to query multiple sensor indices (e.g., 211511) in a single run.

- Data Persistence: API responses are parsed using jq and appended to a structured .csv file for long-term analysis.

- Error Logging: Implements detailed logging to track successful API calls or connection failures.

### Development Roadmap
The automated data collection system reached its stable state in Version 9. This version is optimized for long-term research observations and high data integrity.

- Version 4: Established initial API connection for a single sensor.

- Version 5: Added multi-sensor support via command-line arguments.

- Version 9 (Current): A comprehensive, automated tool featuring:

  - Dual-Output Logic: Generates a "Curated" CSV for quick analysis and a "Full" CSV for deep-dive research.

  - Dynamic Flattening: An advanced algorithm converts the entire nested JSON response into a flat CSV row.

  - Automation-Ready: Uses absolute binary paths (e.g., /usr/bin/jq) for 100% reliability in cron background tasks.

  - Fixed Data Repository: All data is centralized in a standardized directory for consistent file management.

## Task 2: Texas MAIAC AOD Contour Map
This section highlights your data science skills, specifically working with satellite data formats and geospatial mapping.

### Methodology
- Data Processing: Reads NetCDF (.nc) files using the xarray and netCDF4 libraries.

- Spatial Visualization: Uses Cartopy to project latitude/longitude coordinates over a Texas-specific geographic extent.

- Scientific Accuracy: The color scale is strictly constrained to the 0.0 – 0.5 AOD range using a viridis or YlOrRd colormap to highlight subtle variations in aerosol levels.

### Result
<img width="2754" height="2395" alt="Texas_AOD_Contour_image" src="https://github.com/user-attachments/assets/f2007e35-1244-46e7-aaff-cf361e2b065d" />


## Technical Requirements

- Operating System: Windows Subsystem for Linux (WSL2 - Ubuntu).

- Languages: Bash (Scripting), Python 3.12 (Data Analysis).

- Python Libraries: matplotlib, cartopy, xarray, numpy, netCDF4.
