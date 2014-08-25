function vi3_layout_windows
    xdotool mousemove 1890 0
    i3-msg move down
    xdotool mousemove 0 0
    i3-msg move left
end

function vi3_rotate_windows
    xdotool mousemove 0 0
    i3-msg move down
    sleep 0.3
    xdotool mousemove 0 540
    i3-msg move left
    sleep 0.3
    xdotool mousemove 1890 0
    i3-msg move down
    xdotool mousemove 0 0
end


# function vi3_workspace
#     if test $vi3_currentDesktop = $argv
#         vi3_workspace $vi3_lastDesktop
#         #echo "disabled"
#     else
#         i3-msg workspace $argv
#         set -U vi3_lastDesktop $vi3_currentDesktop
#         set -U vi3_currentDesktop $argv
#     end
# end
function vi3_mode
    set nextmode $argv
    set endfunc {$vi3_currentmode}leave
    set enterfunc {$nextmode}enter
    eval $endfunc
    i3-msg mode $nextmode
    set -U vi3_currentmode $argv
    eval $enterfunc
end

function defaultleave
    notify-send "leaving default mode"
end

function defaultenter
    notify-send "entering default mode"
end

function commandenter
    notify-send "entering command mode"
end

function commandleave
    notify-send "leaving command mode"
end

function vi3_target-command
    set -U vi3_targetMode command
end

function vi3_target-default
    set -U vi3_targetMode default
end

function vi3_switch-to-target-mode
    i3-msg mode $vi3_targetMode
end

function vi3_combine-workspaces
    set -U combolist $combolist $argv[1]
    if test (count $combolist) = 2
        vi3_get-workspace $combolist[1]
        vi3_get-workspace $combolist[2]
        set -e combolist
        i3-msg mode "default"
    else
       echo "not yet"
    end
end

function vi3_rearrange-workspaces
    set -U relist $relist $argv[1]
    if test (count $relist) = 2
        set -l myworkspace (getCurrentWorkspace) 
        vi3_workspace $relist[2]
        vi3_get-workspace $relist[1]
        vi3_workspace $myworkspace 
        set -e relist
        i3-msg mode "default"
    else
       echo "not yet"
        i3-msg mode "op"
    end
end
# function fish_prompt --description 'Write out the prompt'
#      # Just calculate these once, to save a few cycles when displaying the prompt
#      if not set -q __fish_prompt_hostname
#      set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
#      end

#      if not set -q __fish_prompt_normal
#      set -g __fish_prompt_normal (set_color normal)
#      end

#      if not set -q __git_cb
#      set __git_cb ":"(set_color brown)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)""
#      end

#      switch $USER

#      case root

#      if not set -q __fish_prompt_cwd
#          if set -q fish_color_cwd_root
#              set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
#          else
#              set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#          end
#      end

#      printf '%s%s:%s%s%s%s# ' "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb

#      case '*'

#      if not set -q __fish_prompt_cwd
#          set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#      end

#      printf '%s%s:%s%s%s%s$ ' "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb

#      end
#  end
# function vi3_take-two

# # takes a letter which is added to a list and a function
# # when the list is 2 letters long the function is evaluated
# # making use of the list

#     set -U combolist $combolist $argv[1]
#     if test (count $combolist) = 2
#         eval $argv[2]
#         echo "done!"
#         set -e combolist
#         i3-msg mode "default"
#     else
#         echo "not yet"
#         i3-msg mode "op"
#     end
# end
# function vi3_take-two

# # takes a letter which is added to a list and a function
# # when the list is 2 letters long the function is evaluated
# # making use of the list

#     set -U combolist $combolist $argv[1]
#     if test (count $combolist) = 2
#         eval $argv[2]
#         echo "done!"
#         set -e combolist
#         i3-msg mode "default"
#     else
#         echo "not yet"
#         i3-msg mode "op"
#     end
# end
