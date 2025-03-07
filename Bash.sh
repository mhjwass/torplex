#!/bin/bash

echo "Updating System "
{
apt-get update
apt-get upgrade -y 
} &> /dev/null

docker-compose -f /home/wass/ples-stuff/torplex/docker-compose.yml up -d

echo "Installing Plex "
{
docker run  -d  --name plex  --network=host  -e TZ="Europe/London"  -v ~/Documents/Docker/plex/database:/config  -v ~/Documents/Docker/plex/temp:/transcode  -v /:/Data --restart unless-stopped  plexinc/pms-docker:latest
}&> /dev/null

echo "Installing Watchtower"
{
docker run -d     --name watchtower     -v /var/run/docker.sock:/var/run/docker.sock     containrrr/watchtower
}&> /dev/null


echo "Adjusting the firewall"
{
iptables -A INPUT -p tcp -d 0/0 -s 0/0 --dport 32400 -j ACCEPT
}&> /dev/null



echo "Starting her up for you chief"
{
docker start $(docker ps -q) 
}&> /dev/null


echo "ALL DONE"
echo "ALL DONE"
echo "ALL DONE"
echo "Your new Docker services are up and running
You can access this from this PC through THE FOLLOWING ADDRESS:
___________________________________________________________________
Portainer: http://127.0.0.1:2000 - Docker Management User Interface.
Plex: http://127.0.0.1:32400/web -  Your personal media play.
Sonarr: http://127.0.0.1:8989 - Sonarr is a multi-platform app to search, download, and manage TV shows.
Radarr: http://127.0.0.1:7878 - Like Sonarr but for movies.
qBittorrent: http://127.0.0.1:8086 - qBittorrent is a cross-platform free and open-source BitTorrent client.
SABnzbd: http://127.0.0.1:8888 - SABnzbd is a binary newsgroup downloader. The program simplifies the downloading verifying and extracting of files from Usenet.
Jackett: http://127.0.0.1:9117 - Jackett is a mass torrent indexer scraper.
___________________________________________________________________
If you have installed this on a 'headless pc' or on a VPS you
will be able to access these services from the IP" 
(hostname -I | awk '{ print $1 }')

echo "We are finished here, for those that would like to config Rclone 
simply type, 
sudo rclone config
if you do not know what Rclone is do not worry about it. 
Please look at the READ ME file =-)

Happy Watching 
"
