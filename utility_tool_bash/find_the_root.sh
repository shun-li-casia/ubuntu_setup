#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : find_the_root
# @created     : 星期四 5月 09, 2024 16:45:16 CST
#
# @description :
######################################################################

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
    echo "Exported GIT_ROOT=$GIT_ROOT"
else
    echo "Failed to find and export GIT_ROOT."
fi
