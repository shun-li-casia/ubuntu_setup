#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : install_ros_and_its_dependences
# @created     : 星期四 5月 09, 2024 14:59:22 CST
#
# @description : install_ros_and_its_dependences
######################################################################

#!/bin/bash

# Check if the script is running with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root privileges. Please run it with 'sudo' or as the root user."
    exit 1
fi

# Main body of the script
echo "The script is running with root privileges."
# Continue with your script logic here...

find_setup_root() {
    local current_dir="$1"
    local parent_dir

    while :; do
        for target in ".git" ".root" ".vim_root"; do
            if [ -d "$current_dir/$target" ] || [ -f "$current_dir/$target" ]; then
                echo "$current_dir"
                export UBUNTU_SETUP_ROOT="$current_dir"
                return 0
            fi
        done
        # 如果已经是根目录，停止循环
        if [[ $current_dir == "/" ]]; then
            echo "No .git directory or .root file found in the parent directories." >&2
            return 1
        fi
        # 否则，继续向上查找
        parent_dir=$(dirname "$current_dir")
        if [[ $parent_dir == "$current_dir" ]]; then break; fi
        current_dir=$parent_dir
    done
}

# 获取当前脚本的绝对路径
this_script=$(readlink -f "$0")
# 获取当前脚本的目录
script_dir=$(dirname "$this_script")

find_setup_root "$script_dir"

if [[ -n $UBUNTU_SETUP_ROOT ]]; then
    echo "UBUNTU_SETUP_ROOT set to: $UBUNTU_SETUP_ROOT"
else
    echo "Failed to set UBUNTU_SETUP_ROOT."
fi
source $UBUNTU_SETUP_ROOT/utility_tool_bash/log_helper.sh


# start the install

log_info $(get_cur_line_number)
execute_with_check "sudo apt update && sudo apt upgrade -y"

log_info $(get_cur_line_number)
execute_with_check "sudo apt install -y git curl net-tools openssh*"

log_info $(get_cur_line_number)
execute_with_check "sudo apt install -y libceres-dev libyaml-cpp-dev"

log_info $(get_cur_line_number)
execute_with_check "sudo apt install -y ros-* python3-pip"

log_info $(get_cur_line_number)
execute_with_check "sudo pip3 install -U catkin_tools --break-system-packages"
