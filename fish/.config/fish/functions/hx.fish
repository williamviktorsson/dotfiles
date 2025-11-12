function hx --description "Launch helix editor, in current directory if no args"
    if test -z "$argv"
        helix .
    else
        helix $argv
    end
end
