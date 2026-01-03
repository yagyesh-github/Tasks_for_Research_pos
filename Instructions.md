# Task1: 
- sudo apt-get install jq

- sudo sed -i 's/\r$//' <filename>
- sudo chmod +x <filename>
### For query to run once which would fetch one entry
- ./ filename.sh


## Automate the process of fetching the data
- crontab -e 
#### Editor will open to add the query to automate
- */10 * * * * <filepath+filename.sh> <sensor_ID> >> <path + cron_log.txt> 2>&1
- sudo service cron start


## Task2:

- sudo apt update

- sudo apt install python3-full -y

### Create a sandbox
- python3 -m venv .venv 

### Activate the sandbox
- source .venv/bin/activate 

- pip install xarray netCDF4 matplotlib cartopy

- sudo apt install libgeos-dev libproj-dev proj-data proj-bin libgdal-dev -y

- python3 <filename> ## Run the script after that 

### Deactivate the sandbox
- deactivate 
