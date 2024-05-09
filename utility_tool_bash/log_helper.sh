#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : log_helper
# @created     : 星期四 5月 09, 2024 15:21:02 CST
#
# @description : 
######################################################################

# 获取当前行号的函数
get_cur_line_number() {
    local LINENO
    LINENO=$(caller 0 | awk '{print $1}')
    echo -n "[$LINENO]"
}

# 重置颜色
reset_color() {
    echo -en "\e[0m"
}

# 输出DEBUG级别日志，颜色为青色，包含行号
log_debug() {
    local LINENO
    LINENO=$(caller 0 | awk '{print $1}')
    echo -n "[$LINENO]"
    echo -e "\e[36m[DEBUG] $@\e[m"
}

# 输出INFO级别日志，颜色为绿色，包含行号
log_info() {
    local LINENO
    LINENO=$(caller 0 | awk '{print $1}')
    echo -n "[$LINENO]"
    echo -e "\e[32m[INFO] $@\e[m"
}

# 输出WARNING级别日志，颜色为黄色，包含行号
log_warning() {
    local LINENO
    LINENO=$(caller 0 | awk '{print $1}')
    echo -n "[$LINENO]"
    echo -e "\e[33m[WARNING] $@\e[m"
}

# 输出ERROR级别日志，颜色为红色，包含行号
log_error() {
    local LINENO
    LINENO=$(caller 0 | awk '{print $1}')
    echo -n "[$LINENO]"
    echo -e "\e[31m[ERROR] $@\e[m"
}

# 示例使用
log_debug "This is a debug message"
log_info "This is an info message"
log_warning "This is a warning message"
log_error "This is an error message"

# 结束时重置颜色
reset_color
