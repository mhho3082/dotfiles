function virt
    sudo systemctl enable libvirtd &>/dev/null
    sudo systemctl enable firewalld &>/dev/null
    sudo virsh net-start default &>/dev/null

    if command -v virt-manager &>/dev/null
        virt-manager
    end
end
