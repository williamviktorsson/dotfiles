function format-drive --description "Format a drive with a single ext4 partition"
    if test (count $argv) -ne 2
        echo "Usage: format-drive <device> <name>"
        echo "Example: format-drive /dev/sda 'My Stuff'"
        printf "\nAvailable drives:\n"
        lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
        return 1
    end

    echo "WARNING: This will completely erase all data on $argv[1] and label it '$argv[2]'."
    read -P "Are you sure you want to continue? (y/N): " confirm

    if string match -q -r '^[Yy]' -- "$confirm"
        sudo wipefs -a "$argv[1]"
        sudo dd if=/dev/zero of="$argv[1]" bs=1M count=100 status=progress
        sudo parted -s "$argv[1]" mklabel gpt
        sudo parted -s "$argv[1]" mkpart primary ext4 1MiB 100%

        set partition_name ""
        if string match -q -- '*nvme*' $argv[1]
            set partition_name "$argv[1]p1"
        else
            set partition_name "$argv[1]1"
        end

        sudo mkfs.ext4 -L "$argv[2]" "$partition_name"
        sudo chmod -R 777 "/run/media/$USER/$argv[2]"
        echo "Drive $argv[1] formatted and labeled '$argv[2]'."
    end
end
