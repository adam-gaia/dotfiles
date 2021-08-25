#!/bin/bash
# Copy the git template dir's hooks and scripts to the local git repo
# TODO: backup before copying

git_template_dir="$(git config init.templatedir)"
local_git_dir="$(git rev-parse --git-dir)"

cp -r "${git_template_dir}/scripts" "${local_git_dir}/scipts"
cp -r "${git_template_dir}/hooks" "${local_git_dir}/hooks"
