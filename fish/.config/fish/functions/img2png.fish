function img2png --description "Convert an image to a compressed lossless PNG"
    if test (count $argv) -ne 1
        echo "Usage: $0 <input_file>"
        return 1
    end
    set output (path change-extension '.png' $argv[1])
    magick "$argv[1]" -strip -define png:compression-filter=5 \
        -define png:compression-level=9 \
        -define png:compression-strategy=1 \
        -define png:exclude-chunk=all \
        "$output"
end
