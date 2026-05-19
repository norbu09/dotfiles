source /usr/share/cachyos-fish-config/cachyos-config.fish

# Minimal hacker-style prompt
function fish_prompt
    set -l last_status $status
    echo -n (set_color 89b4fa)(prompt_pwd --dir-length=0)(set_color normal)
    if test $last_status -ne 0
        echo -n (set_color f38ba8) "✗ "(set_color normal)
    else
        echo -n (set_color a6e3a1) "❯ "(set_color normal)
    end
end

function fish_right_prompt
    set -l time_str (date +%H:%M:%S)
    echo (set_color 6c7086)$time_str
end

function fish_greeting
end
