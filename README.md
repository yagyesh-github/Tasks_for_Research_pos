# Tasks_for_Research_pos
This repository has the detailed work on tasks mentioned below.


## Task 1: Real-Time Air Quality Monitoring (PurpleAir API)
This section demonstrates the ability to automate data collection and handle API requests.

### Features
- Automation: Utilizes crontab in WSL to fetch data every 5 minutes during specific observation windows.

- Multi-Sensor Support: Bash scripts utilize arrays and loops to query multiple sensor indices (e.g., 211511) in a single run.

- Data Persistence: API responses are parsed using jq and appended to a structured .csv file for long-term analysis.

- Error Logging: Implements detailed logging to track successful API calls or connection failures.


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
