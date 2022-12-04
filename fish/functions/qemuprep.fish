function qemuprep
    sudo systemctl enable libvirtd
    sudo systemctl enable firewalld
    sudo virsh net-start default

    if command -v virt-manager &>/dev/null
        virt-manager
    end
end
