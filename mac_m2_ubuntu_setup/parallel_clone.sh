#!/usr/bin/env sh

######################################################################
# @author      : ShunLi (2015097272@qq.com)
# @file        : parallel_clone
# @created     : 星期四 5月 09, 2024 18:06:01 CST
#
# @description : 
######################################################################

# 仓库列表
REPOS=("https://github.com/repo1.git" "https://github.com/repo2.git" "https://github.com/repo3.git" "https://github.com/repo4.git" "https://github.com/repo5.git" "https://github.com/repo6.git")

# 克隆函数
clone_repo() {
    local repo_url=$1
    local retry_count=0
    local max_retries=3

    until git clone "$repo_url"; do
        if (( retry_count < max_retries )); then
            echo "Clone of $repo_url failed, retrying ($((retry_count + 1)) of $max_retries)..."
            ((retry_count++))
        else
            echo "Failed to clone $repo_url after $max_retries retries. Aborting."
            exit 1
        fi
    done
    echo "$repo_url cloned successfully."
}

# 并行克隆
for repo in "${REPOS[@]}"; do
    clone_repo "$repo" &
done

# 等待所有后台任务完成
wait

echo "All repositories have been cloned successfully."
