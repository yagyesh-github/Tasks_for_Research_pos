sudo apt-get install jq
sudo sed -i 's/\r$//' purpleair_realtime_pm25_version9.sh
sudo chmod +x purpleair_realtime_pm25_version9.sh
#./purpleair_realtime_pm25_version9.sh # Single entry fetch
crontab -e
sudo service cron start