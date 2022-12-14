source ./check_os.sh
ACTUAL_PATH = $(pwd)

if [ is_fedora ]; then
    sudo dnf install meson

    git clone https://github.com/ckissane/materia-theme-transparent.git $HOME/materia-theme-transparent

    cd $HOME/materia-theme-transparent

    meson _build
    meson install -C _build

    cd $HOME

    git clone https://github.com/yilozt/mutter-rounded
    cd ./mutter-rounded/fedora
    ./package.sh

    cd ~/rpmbuild/RPMS/x86_64/
    sudo dnf upgrade mutter
    sudo rpm --reinstall mutter-41.*

    cd $HOME
    git clone https://github.com/yilozt/mutter-rounded-setting
    cd ./mutter-rounded-setting
    ./install
fi

cd $ACTUAL_PATH
