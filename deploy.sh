#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

git status
if [ -n "$(git status -s)" ];then
	echo "请先提交修改..."
    exit 0;
fi

# Build the project.
hugo -D # if using a theme, replace with `hugo -t <YOURTHEME>`
# cp CNAME ./public/
# Go To Public folder
# git branch -D build
# 新建临时分支
git checkout -b build

git --work-tree public add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
# 提交到git pages 分支
git --work-tree public commit -m "$msg"
git push origin HEAD:gh-pages --force


# 在临时分支暂存数据
git add .
git commit -m "$msg"
# 切换主分支
git checkout main
# 删除临时分支
git branch -D build
