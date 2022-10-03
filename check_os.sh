get_os_name(){
    OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    echo $OS
    return 1
}


is_fedora(){
    if [[ get_os_name == "Fedora Linux" ]]; then
        echo true
    else 
        echo false
    fi
    return 1
}