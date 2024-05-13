#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : parallel_pull
# @created     : 星期四 5月 09, 2024 18:08:59 CST
#
# @description :
######################################################################

# 仓库目录列表
# 读取用户输入的目标目录路径
read -p "input the abs directory of the directories to be pull: " targetDirectory

# 使用find命令获取所有一级子目录
subDirectories=($(find "$targetDirectory" -maxdepth 1 -mindepth 1 -type d))

# 更新函数
update_repo() {
    local repo_dir=$1
    local retry_count=0
    local max_retries=3

    pushd "$repo_dir" > /dev/null || { echo "Cannot change directory to $repo_dir"; return 1; }

    until git pull; do
        if (( retry_count < max_retries )); then
            echo "Pull in $repo_dir failed, retrying ($((retry_count + 1)) of $max_retries)..."
            ((retry_count++))
        else
            echo "Failed to pull from repository in $repo_dir after $max_retries retries. Aborting."
            popd > /dev/null
            return 1
        fi
    done

    popd > /dev/null
    echo "$repo_dir updated successfully."
    return 0
}

# 并行更新
for repo_dir in "${subDirectories[@]}"; do
    echo "$repo_dir"
    update_repo "$repo_dir" &
done

# 等待所有后台任务完成
wait

echo "All repositories have been updated successfully."
