function open --description "Open a file with its default application in the background"
    xdg-open $argv >/dev/null 2>&1 &
end
