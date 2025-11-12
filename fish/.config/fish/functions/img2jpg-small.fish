function img2jpg-small --description "Convert an image to a smaller JPG (1080px wide)"
    if test (count $argv) -ne 1
        echo "Usage: $0 <input_file>"
        return 1
    end
    set output (path change-extension '.jpg' $argv[1])
    magick $argv[1] -resize 1080x\> -quality 95 -strip $output
end
