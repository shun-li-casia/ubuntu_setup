#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : install_ros_and_its_dependences
# @created     : 星期四 5月 09, 2024 14:59:22 CST
#
# @description : install_ros_and_its_dependences
######################################################################

#!/bin/bash

find_git_parent() {
    local current_dir="$1"
    local parent_dir="$current_dir"

    while [ "$parent_dir" != "/" ]; do
        if [ -d "$parent_dir/.git" ]; then
            echo "$parent_dir"
            return
        fi
        parent_dir=$(dirname "$parent_dir")
    done

    echo "No .git directory found in parent directories." >&2
    return 1
}

ubuntu_setup_root=$(find_git_parent "$PWD")
if [ $? -eq 0 ]; then
    export UBUNTU_SETUP_ROOT="$ubuntu_setup_root"
    echo "Exported GIT_ROOT=$UBUNTU_SETUP_ROOT"
else
    echo "Failed to find and export UBUNTU_SETUP_ROOT."
fi

source $UBUNTU_SETUP_ROOT/utility_tool_bash/log_helper.sh

log_info $(get_cur_line_number)
execute_with_check "sudo apt update && sudo apt upgrade -y"

log_info $(get_cur_line_number)
execute_with_check "sudo apt install git vim curl net-tools openssh*"

log_info $(get_cur_line_number)
execute_with_check "sudo apt install libceres-dev libyaml-cpp-dev"

log_info $(get_cur_line_number)
execute_with_check "sudo apt install -y ros-* python3-pip"

log_info $(get_cur_line_number)
execute_with_check "sudo pip3 install -U catkin_tools --break-system-packages"
