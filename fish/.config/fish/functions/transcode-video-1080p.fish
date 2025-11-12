function transcode-video-1080p --description "Transcode video to 1080p H.264"
    if test (count $argv) -ne 1
        echo "Usage: $0 <input_file>"
        return 1
    end
    set output (path change-extension '' $argv[1])-1080p.mp4
    ffmpeg -i $argv[1] -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy $output
end
