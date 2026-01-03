sudo apt update
sudo apt install python3-full -y
#sudo apt install python3-full libgeos-dev libproj-dev proj-data proj-bin libgdal-dev -y
python3 -m venv .venv ## Create a sandbox
source .venv/bin/activate ## Activate the sandbox
pip install xarray netCDF4 matplotlib cartopy
sudo apt install libgeos-dev libproj-dev proj-data proj-bin libgdal-dev -y
python3 task2_version1.py ## Run the script after that 
deactivate ## Deactivate the sandbox

DEFAULT_PATH="/mnt/c/Users/yagye/OneDrive/Downloads"

# Ask user for input, but use the default if they just press Enter
read -p "Enter destination path [Default: $DEFAULT_PATH]: " USER_PATH

# Use the user's input, or fallback to default if USER_PATH is empty
FINAL_PATH=${USER_PATH:-$DEFAULT_PATH}

echo "Processing complete. Moving image to: $FINAL_PATH"
cp Texas_AOD_Contour_image.png "$FINAL_PATH"