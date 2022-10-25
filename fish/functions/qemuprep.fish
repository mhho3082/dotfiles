function qemuprep
    sudo systemctl restart libvirtd
    sudo systemctl restart firewalld
    sudo virsh net-start default
end
