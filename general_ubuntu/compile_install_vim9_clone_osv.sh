#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : compile_install_vim9_clone_osv
# @created     : 星期四 5月 09, 2024 17:22:49 CST
#
# @description :
######################################################################

#!/bin/bash

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

# download the git source code
vim_source=$HOME/vim_source
log_info $(get_cur_line_number)
execute_with_check "sudo apt install -y git  libatk1.0-dev  libcairo2-dev  libgtk2.0-dev liblua5.1-0-dev  libncurses5-dev  libperl-dev  libx11-dev  libxpm-dev  libxt-dev  lua5.1  python3-dev  ruby-dev"

execute_with_check_warn "git clone --depth 1 https://github.com/vim/vim.git ${vim_source}"

cd $vim_source || { log_error "can not cd $vim_source!"; exit 1; }
log_info "prepare to compile the vim"
execute_with_check "./configure --with-features=huge  --enable-multibyte  --enable-rubyinterp=yes  --enable-python3interp=yes  --with-python3-command=$PYTHON_VER  --with-python3-config-dir=$(python3-config --configdir)  --enable-perlinterp=yes  --enable-gui=auto  --enable-cscope  --prefix=/usr/local"

execute_with_check "make -j $(( $(nproc) - 1 ))"
execute_with_check "sudo make -j $(( $(nproc) - 1 )) install"

execute_with_check "vim --version"

# download the osv
execute_with_check_warn "git clone --depth 1 https://github.com/lee-shun/old_school_vim $HOME/.vim"

# install the lsp
execute_with_check "sudo apt install -y ccls clangd clang-format"
exit 0;
