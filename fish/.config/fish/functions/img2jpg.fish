function img2jpg --description "Convert an image to a high-quality JPG"
    if test (count $argv) -ne 1
        echo "Usage: $0 <input_file>"
        return 1
    end
    set output (path change-extension '.jpg' $argv[1])
    magick $argv[1] -quality 95 -strip $output
end
