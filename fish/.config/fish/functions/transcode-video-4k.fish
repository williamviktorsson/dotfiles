function transcode-video-4k --description "Transcode video to 4K H.265"
    if test (count $argv) -ne 1
        echo "Usage: $0 <input_file>"
        return 1
    end
    set output (path change-extension '' $argv[1])-optimized.mp4
    ffmpeg -i $argv[1] -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k $output
end
