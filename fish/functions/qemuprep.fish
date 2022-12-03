function qemuprep
    sudo systemctl enable libvirtd
    sudo systemctl enable firewalld
    sudo virsh net-start default
    virt-manager
end
