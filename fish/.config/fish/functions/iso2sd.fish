function iso2sd --description "Write an ISO file to an SD card using dd"
    if test (count $argv) -ne 2
        echo "Usage: iso2sd <input_file> <output_device>"
        echo "Example: iso2sd ~/Downloads/ubuntu.iso /dev/sda"
        printf "\nAvailable SD cards:\n"
        lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
        return 1
    end
    sudo dd bs=4M status=progress oflag=sync if="$argv[1]" of="$argv[2]"
    sudo eject $argv[2]
end
