
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
sudo apt install postgresql postgresql-contrib

sudo apt install mariadb-server
mysql_secure_installation