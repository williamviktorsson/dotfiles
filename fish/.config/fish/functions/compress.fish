function compress --description "Compress a file or directory using tar.gz"
    if test (count $argv) -ne 1
        echo "Usage: compress <file_or_directory>"
        return 1
    end
    set target (string trim -r -c / -- $argv[1])
    tar -czf "$target.tar.gz" "$target"
end
