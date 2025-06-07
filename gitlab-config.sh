#!/usr/bin/env bash

# tells Golang command line tools you are using modules. I have not tested this with projects not using Golang modules on a private GitLab.
export GO111MODULE=on
# tells Golang command line tools to not use public internet resources for the hostnames listed (like the public module proxy).
export GOPRIVATE=gitlab.com/Jean.M.Girard/teams/container-solutions

go env -w GOPRIVATE=gitlab.com/Jean.M.Girard/teams/container-solutions


git config --global url."https://JeanMGirard:glpat-MAcEX6WCWdDvdK5-dZ5Q@gitlab.com".insteadOf "https://gitlab.com"
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"


git config --global user.email "Jean.M.Girard@Outlook.com"
git config --global user.username "JeanMGirard"
git config --global user.name "Jean-Michel Girard"

# git config --global user.signingkey 0x3F3F3F3F3F3F3F3F
# git config --global commit.gpgsign true
# git config --global gpg.program gpg
# git config --global gpg.program gpg2

git config --global credential.helper store
#git config --global credential.helper 'cache --timeout=3600'


# git config --global core.autocrlf input
git config --global core.ignorecase false
git config --global core.safecrlf true
# git config --global core.filemode false
# git config --global core.precomposeunicode true


git config --global core.editor "code --wait"
git config --global diff.tool "vscode"
git config --global merge.tool "vscode"
# git config --global core.editor "vim"


git config --global difftool.vscode.cmd "code -w -d \$LOCAL \$REMOTE"
git config --global mergetool.vscode.cmd "code -w \$MERGED"




git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config --global alias.lg1 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative -1"
git config --global alias.lg2 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative -2"
git config --global alias.lg3 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative -3"
git config --global alias.lg4 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative -4"
git config --global alias.lg5 "log --graph --pretty=format"


