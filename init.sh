source ./check_os.sh

if [ is_fedora ]; then
    echo "Nothing here yet"
else
sudo add-apt-repository universe

sudo apt update

sudo apt install code
snap install intellij-idea-community --classic
sudo apt install git
sudo apt install curl
sudo apt install wget
sudo apt install nodejs
sudo apt install npm
sudo apt install zsh


curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

sudo apt update

sudo apt install yarn

sudo apt install default-jdk
sudo apt install openjdk-11-jdk
sudo apt install openjdk-8-jdk

sudo apt install -y python3-pip
sudo apt install python2
python3 get-pip.py
sudo apt install -y build-essential libssl-dev libffi-dev python3-dev
sudo apt-get install make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
sudo apt install -y python3-venv

fi

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh 


git config --global user.name "Lucas Morais"
git config --global user.email "lucascdemorais@gmail.com"

for dir in **/; do
    if [ -f "./$dir"+"init.sh" ]; then
        echo "Initializing $dir"
        cd $dir
        ./init.sh
        cd ..
    fi
done
