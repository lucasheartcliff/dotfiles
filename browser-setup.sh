source ./check_os.sh

if [ is_fedora == false ]; then 
    sudo apt install apt-transport-https

    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update

    sudo apt install brave-browser


    echo '[Desktop Entry]
    Name=Brave Browser
    Exec=/usr/bin/brave-browser-stable %U --remote-debugging-port=9222
    StartupNotify=true
    Terminal=false
    Icon=brave-browser
    Type=Application
    Categories=Network;WebBrowser;' >> ~/.local/share/applications/brave-browser.desktop
fi; 

if [ is_fedora ]; then
    sudo dnf upgrade --refresh
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
fi
