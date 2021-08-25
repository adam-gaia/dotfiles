# Global git settings


## Git template directory
Files contained in `${GIT_TEMPLATE_DIR}` will be copied into a repo's `.git` dir upon `git init` and `git clone`

See https://pre-commit.com/#pre-commit-init-templatedir for more info


### Set git template dir
```bash
DOT_GIT_DIR="${DOTFILEDIR}/git"
GIT_TEMPLATE_DIR="${DOT_GIT_DIR}/git-template-dir"
PRE_COMMIT_CONFIG="${DOT_GIT_DIR}/pre-commit-config.yaml"
git config --global init.templateDir "${GIT_TEMPLATE_DIR}"
```


### Pre-commit hooks
Pre-commit hooks are initialized via the `pre-commit` manager tool
```bash
pre-commit init-templatedir --config "${PRE_COMMIT_CONFIG}" "${GIT_TEMPLATE_DIR}"
```

See https://git-scm.com/docs/git-init#_template_directory for more info

### Pull hooks into an existing git repo
```bash
# Update the template directory's hooks
pre-commit init-templatedir --config "${PRE_COMMIT_CONFIG}" "${GIT_TEMPLATE_DIR}"

# Navigate to the repo's .git dir
cd .git
mkdir -p ./scripts
cd scripts
cp "${GIT_TEMPLATE_DIR}/scripts/update-git-hooks.sh" ./
./update-git-hooks.sh
```

### Update hooks
```bash
# Update the template directory's hooks
pre-commit init-templatedir --config "${PRE_COMMIT_CONFIG}" "${GIT_TEMPLATE_DIR}"

# Navigate to the repo's .git dir
cd .git/scripts
./update-git-hooks.sh
```
