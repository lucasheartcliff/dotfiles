source check_os.sh

if [ is_fedora == false ]; then
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
sudo apt install postgresql postgresql-contrib

sudo apt install mariadb-server
mysql_secure_installation
fi

if [ is_fedora ]; then 
    sudo dnf module enable mariadb:10.6
    sudo dnf install mariadb mariadb-server
    sudo systemctl enable mariadb --now
    mariadb --version
    sudo systemctl status mariadb
fi