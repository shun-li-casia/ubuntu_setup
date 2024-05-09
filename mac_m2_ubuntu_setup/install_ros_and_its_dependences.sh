#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : install_ros_and_its_dependences
# @created     : 星期四 5月 09, 2024 14:59:22 CST
#
# @description : install_ros_and_its_dependences
######################################################################

#!/bin/bash

source ../utility_tool_bash/log_helper.sh


sudo apt get update

quit_if_failed $? "sudo apt get update"
