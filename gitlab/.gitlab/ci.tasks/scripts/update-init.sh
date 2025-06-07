#!/usr/bin/env bash

# @file .gitlab/ci/scripts/update-init.sh
# @brief Script that executes before the start task if the UPDATE_INIT_SCRIPT is set to the URL
# of this script

set -eo pipefail

# @description Source profile if it exists
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile" &> /dev/null || true
fi

# @description Ensure .config/log is present
if [ ! -f .config/log ]; then
  mkdir -p .config
  curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/common/.config/log > .config/log
fi

# @description Ensure .config/log is executable
chmod +x .config/log || echo "Unable to change permissions of .config/log"

# @description Configure git if environment is GitLab CI
if [ -n "$GITLAB_CI" ]; then
  .config/log info 'Configuring git'
  git remote set-url origin "https://root:$GROUP_ACCESS_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH.git"
  git config user.email "$GITLAB_CI_EMAIL"
  git config user.name "$GITLAB_CI_NAME"
  .config/log info 'Fetching all and checking out master'
  git fetch --all
  git checkout master
fi

# @description Clone shared files repository
.config/log info 'Cloning common shared repository'
rm -rf common-shared
git clone --depth=1 https://gitlab.com/megabyte-labs/common/shared.git common-shared

# @description Refresh taskfiles and GitLab CI files
.config/log info 'Copying `taskfiles/`, `scripts/`, and `gitlab/ci` files from shared common repository'
mkdir -p .config
rm -rf .config/taskfiles
if [[ "$OSTYPE" == 'darwin'* ]]; then
  cp -rf common-shared/common/.config/taskfiles .config
  if [ -d common-shared/common/.config/scripts ]; then
    cp -rf common-shared/common/.config/scripts .config
  fi
else
  cp -rT common-shared/common/.config/taskfiles .config/taskfiles
  if [ -d common-shared/common/.config/scripts ]; then
    cp -rT common-shared/common/.config/scripts .config/scripts
  fi
fi
mkdir -p .gitlab
if [ -d .gitlab/ci ]; then
  rm -rf .gitlab/ci
fi

# @description Ensure basic shared files are up-to-date
.config/log info 'Copying standard files such as `hbs.cjs` and `start.sh`'
mkdir -p .config
cp common-shared/common/.config/Brewfile .config/Brewfile
cp common-shared/common/.config/hbs.cjs .config/hbs.cjs
cp common-shared/common/.editorconfig .editorconfig
cp common-shared/common/.gitignore .gitignore
cp common-shared/common/start.sh start.sh

# @description Ensure proper NPM dependencies are installed
.config/log info 'Ensuring `package.json` exists'
if [ ! -f 'package.json' ]; then
  echo "{}" > package.json
fi
.config/log info 'Ensuring `package-lock.json` does not exist in root of repository'
if [ -f 'package-lock.json' ]; then
  rm package-lock.json
fi

# @description Remove old packages
.config/log info 'Shaping `package.json`'
TMP="$(mktemp)" && sed 's/.*cz-conventional-changelog.*//' < package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && sed 's/.*config-conventional.*//' < package.json > "$TMP" && mv "$TMP" package.json
rm -f temp.json
if type jq &> /dev/null; then
  if [ -f .blueprint.json ]; then
    PKG_BLUEPRINT="$(jq -r '.blueprint' package.json)"
    if [ "$PKG_BLUEPRINT" != 'null' ]; then
      echo "$PKG_BLUEPRINT" > .blueprint2.json
      TMP="$(mktemp)"
      jq -s '.[0] * .[1]' .blueprint.json .blueprint2.json > "$TMP"
      PKG_TMP="$(mktemp)"
      jq --arg blueprint "$(jq -r '.' $TMP)" '.blueprint = ($blueprint | fromjson)' package.json > "$PKG_TMP"
      mv "$PKG_TMP" package.json
      rm .blueprint.json
      rm .blueprint2.json
    else
      PKG_TMP="$(mktemp)"
      jq --arg blueprint "$(jq -r '.' .blueprint.json)" '.blueprint = ($blueprint | fromjson)' package.json > "$PKG_TMP"
      mv "$PKG_TMP" package.json
      rm .blueprint.json
    fi
  fi
  TMP="$(mktemp)" && jq 'del(.devDependencies["@mblabs/prettier-config"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@commitlint/config-conventional"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@mblabs/eslint-config"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@mblabs/release-config"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@megabytelabs/jest-preset"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@typescript-eslint/eslint-plugin"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@washingtondc/prettier"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@washingtondc/release"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["commitlint-config-gitmoji"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["cz-conventional-changelog"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["cz-emoji-conventional"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["@washingtondc/development"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["glob"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["handlebars-helpers"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["semantic-release"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.devDependencies["sleekfast"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.optionalDependencies["chalk"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.optionalDependencies["inquirer"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.optionalDependencies["signale"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.optionalDependencies["string-break"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.dependencies["tslib"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.private = false' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.["standard-version"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.["scripts-info"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.scripts.prepublishOnly)' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.devDependencies["@commitlint/config-conventional"] = "latest"' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.devDependencies["eslint-config-strict-mode"] = "latest"' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.devDependencies["git-cz-emoji"] = "latest"' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.devDependencies["handlebars-helpers"] = "latest"' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.devDependencies["prettier-config-sexy-mode"] = "latest"' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.devDependencies["semantic-release-config"] = "latest"' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq '.prettier = "prettier-config-sexy-mode"' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.eslintConfig.rules["max-lines"])' package.json > "$TMP" && mv "$TMP" package.json
  TMP="$(mktemp)" && jq 'del(.scripts.publish)' package.json > "$TMP" && mv "$TMP" package.json
  if jq -r '.blueprint.repository.github' package.json | grep ProfessorManhattan; then
    THE_REPO="$(jq -r '.blueprint.repository.github' package.json | sed 's/.*\/\([^\/]*\)$/\1/')"
    curl -vL -u "$2:${GITHUB_TOKEN}" -H "Content-Type: application/json" -H "Accept: application/vnd.github.v3+json" -X POST https://api.github.com/repos/ProfessorManhattan/$THE_REPO/transfer -d '{"new_owner":"megabyte-labs"}'
    TMP="$(mktemp)" && jq --arg url "$(jq -r '.blueprint.repository.github' package.json | sed 's/ProfessorManhattan/megabyte-labs/')" '.blueprint.repository.github = $url' package.json > "$TMP" && mv "$TMP" package.json
  fi
  if [ "$(jq -r '.blueprint.group' package.json)" != 'ansible' ] && [ "$(jq -r '.blueprint.group' package.json)" != 'python' ]; then
    if [ -f pyproject.toml ]; then
      rm pyproject.toml
    fi
  fi

  if [ "$(jq -r '.blueprint.group' package.json)" == 'documentation' ]; then
    TMP="$(mktemp)" && jq '.eslintConfig.rules["import/no-extraneous-dependencies"] = "off"' package.json > "$TMP" && mv "$TMP" package.json
  fi

  if [ -f tsconfig.json ] && [ "$(jq -r '.compilerOptions.importHelpers' tsconfig.json)" == 'true' ]; then
    TMP="$(mktemp)" && jq '.dependencies.tslib = "latest"' package.json > "$TMP" && mv "$TMP" package.json
  fi
fi

if [ -f meta/main.yml ] && type yq &> /dev/null; then
  yq eval -i '.galaxy_info.min_ansible_version = 2.10' meta/main.yml
fi

# @description Re-generate the Taskfile.yml if it has invalid includes
.config/log info 'Ensuring that the `Taskfile.yml` is accessible'
task donothing || EXIT_CODE=$?
if [ -n "$EXIT_CODE" ]; then
  .config/log warn 'Failed to run `task donothing` - replacing `Taskfile.yml` with shared common version'
  cp common-shared/Taskfile.yml Taskfile.yml
fi

if type yq &> /dev/null; then
  .config/log info 'Merging shared common `Taskfile.yml` includes over current includes'
  TSK_TMP="$(mktemp)"
  curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/Taskfile.yml > "$TSK_TMP"
  VAL="$(yq eval-all '(select(fileIndex == 0) | .includes) * (select(fileIndex == 1) | .includes)' Taskfile.yml "$TSK_TMP")" yq e -i '.includes = env(VAL)' Taskfile.yml
  VAL="$(yq eval-all '(select(fileIndex == 0) | .vars) * (select(fileIndex == 1) | .vars)' Taskfile.yml "$TSK_TMP")" yq e -i '.vars = env(VAL)' Taskfile.yml
  VAL='sh: if type jq &> /dev/null && [ -f package.json ]; then VER="$(jq -r ''.blueprint.group'' package.json)"; if [ "$VER" == 'null' ]; then echo "$GROUP_TYPE"; else echo "$VER"; fi; else echo "$GROUP_TYPE"; fi' yq e -i '.vars.REPOSITORY_TYPE = env(VAL)' Taskfile.yml
  VAL='sh: if type jq &> /dev/null && [ -f package.json ]; then VER="$(jq -r ''.blueprint.subgroup'' package.json)"; if [ "$VER" == 'null' ]; then echo "$REPOSITORY_TYPE"; else echo "$VER"; fi; else echo "$REPOSITORY_TYPE"; fi' yq e -i '.vars.REPOSITORY_SUBTYPE= env(VAL)' Taskfile.yml
  yq e -i '.vars.includes["common:start"] = "./.config/taskfiles/common/Taskfile-start.yml"' Taskfile.yml
  yq e -i '.tasks.update.cmds = [ { "task": "common:start", "env": { "UPDATE_PROJECT": "true" } } ]' Taskfile.yml
  yq e -i '.vars.NPM_PROGRAM = "pnpm"' Taskfile.yml
  yq e -i 'del(.stages)' .gitlab-ci.yml
  yq e -i 'del(.variables)' .gitlab-ci.yml
  yq e -i 'del(.cache)' .gitlab-ci.yml
fi

# @description Clean up
.config/log info 'Removing shared common repository folder'
rm -rf common-shared

# @description Ensure files from old file structure are removed (temporary code)
.config/log info 'Removing files leftover from past architecture'
rm -f .ansible-lint
rm -f .eslintrc.cjs
rm -f .flake8
rm -f .prettierignore
rm -f .start.sh
rm -f .update.sh
rm -f .yamllint
rm -f update-init.sh
rm -f requirements.txt
rm -f .config/eslintcache
rm -f CODE_OF_CONDUCT.md
rm -f CONTRIBUTING.md
rm -rf .common
rm -rf .config/esbuild
rm -rf .config/prompts
rm -rf .pnpm-store
rm -rf .husky
rm -rf tests
rm -f poetry.toml
rm -rf molecule/archlinux-desktop
rm -rf molecule/centos-desktop
rm -rf molecule/ci-docker-archlinux
rm -rf molecule/ci-docker-centos
rm -rf molecule/ci-docker-debian-snap
rm -rf molecule/ci-docker-debian
rm -rf molecule/ci-docker-fedora
rm -rf molecule/ci-docker-ubuntu-snap
rm -rf molecule/ci-docker-ubuntu
rm -rf molecule/debian-desktop
rm -rf molecule/docker-snap
rm -rf molecule/fedora-desktop
rm -rf molecule/macos-desktop
rm -rf molecule/ubuntu-desktop
rm -rf molecule/windows-desktop
rm -f molecule/default/converge.yml
rm -f molecule/default/prepare.yml
rm -f molecule/docker/converge.yml
rm -f molecule/docker/prepare.yml
rm -f .github/workflows/macOS.yml
rm -f .config/docs/CODE_OF_CONDUCT.md
rm -f .config/docs/CONTRIBUTING.md
if test -d .config/docs; then
  cd .config/docs || exit
  rm -rf .git .config .github .gitlab .vscode .editorconfig .gitignore .gitlab-ci.yml
  rm -rf LICENSE Taskfile.yml package-lock.json package.json poetry.lock pyproject.toml
  cd ../..
fi

if [ ! -f pyproject.toml ]; then
  if [ -f poetry.lock ]; then
    rm poetry.lock
  fi
fi

# @description Ensure documentation is in appropriate location (temporary code)
.config/log info 'Ensuring proper documentation structure is used'
mkdir -p docs
if test -f "CODE_OF_CONDUCT.md"; then
  mv CODE_OF_CONDUCT.md docs
fi
if test -f "CONTRIBUTING.md"; then
  mv CONTRIBUTING.md docs
fi
if test -f "ARCHITECTURE.md"; then
  mv ARCHITECTURE.md docs
fi

# @description Commit and push the changes
if [ -n "$GITLAB_CI" ]; then
  task ci:commit
fi

curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/common/.config/taskfiles/ansible/Taskfile-test.yml > .config/taskfiles/ansible/Taskfile-test.yml
