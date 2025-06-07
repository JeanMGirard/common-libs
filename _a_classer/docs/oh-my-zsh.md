# Oh-my-zsh

## Setup

in powershell:

```powershell
cd ~/
git clone https://github.com/powerline/fonts.git
cd fonts
.\install.ps1
```

in bash:

```shell
sudo apt-get install -y fonts-powerline
```

## Profile


### Theme

```shell
sed -i "s/${ZSH_THEME}/amuse/g" ~/.zshrc
sed -i "s/${ZSH_THEME}/agnoster/g" ~/.zshrc
```

### Plugins

__Favorites__

aliases
keychain
git
gitfast
git-extras
git-auto-fetch

#### __Current__

```shell
sudo -H pip3 install thefuck --upgrade
```

```shell
plugins=(
    aliases
    aws
    keychain
    git
    gitfast
    git-extras
    git-auto-fetch
    git-flow
    git-flow-avh
    git-lfs
    thefuck
    kubectx
    kubectl
)
```

__A Checker__

ssh-agent
man
npm
nvm
pip
pipenv
terraform
repo
alias-finder
ansible
autoenv
docker
docker-compose
dnote
gcloud
geeknote
gem
genpass
gh
git-escape-magic
github
git-hubflow
gitignore
git-prompt
glassfish
globalias
gnu-utils
golang
gpg-agent
helm

__Others__

1password
adb
ag
ant
apache2-macports
arcanist
archlinux
asdf
autojump
autopep8
battery
bazel
bbedit
bedtools
bgnotify
bower
branch
brew
bundler
cabal
cake
cakephp3
capistrano
cask
catimg
celery
charm
chruby
chucknorris
cloudfoundry
codeclimate
coffee
colemak
colored-man-pages
colorize
command-not-found
common-aliases
compleat
composer
copybuffer
copyfile
copypath
cp
cpanm
dash
debian
deno
dircycle
direnv
dirhistory
dirpersist
dnf
docker-machine
doctl
dotenv
dotnet
droplr
drush
eecms
emacs
ember-cli
emoji
emoji-clock
emotty
encode64
extract
fabric
fancy-ctrl-z
fasd
fastfile
fbterm
fd
fig
firewalld
flutter
fnm
forklift
fossil
frontend-search
fzf
gas
gatsby
gb
gradle
grails
grc
grunt
gulp
hanami
heroku
history
history-substring-search
hitchhiker
hitokoto
homestead
httpie
invoke
ionic
ipfs
isodate
istioctl
iterm2
jake-node
jenv
jfrog
jhbuild
jira
jruby
jsontools
juju
jump
kate

kitchen
kn
knife
knife_ssh
kops
kube-ps1
lando
laravel
laravel4
laravel5
last-working-dir
lein
lighthouse
lol
lpass
lxd
macos
macports
magic-enter
marked2
mercurial
meteor
microk8s
minikube
mix
mix-fast
mongocli
mosh
multipass
mvn
mysql-macports
n98-magerun
nanoc
ng
nmap
node
nomad
oc
octozen
operator-sdk
otp
pass
paver
pep8
percol
per-directory-history
perl
perms
phing
pj
please
pm2
pod
poetry
postgres
pow
powder
powify
profiles
pyenv
pylint
python
rails
rake
rake-fast
rand-quote
rbenv
rbfu
rbw
react-native
rebar
redis-cli
ripgrep
ros
rsync
ruby
rust
rvm
safe-paste
salt
samtools
sbt
scala
scd
screen
scw
sdk
sfdx
sfffe
shell-proxy
shrink-path
singlechar
spring
sprunge
stack
sublime
sublime-merge
sudo
supervisor
suse
svcat
svn
svn-fast-info
swiftpm
symfony
symfony2
systemadmin
systemd
taskwarrior
terminitor
term_tab
textastic
textmate
themes
thor
tig
timer
tmux
tmux-cssh
tmuxinator
toolbox
torrent
transfer
tugboat
ubuntu
ufw
universalarchive
urltools
vagrant
vagrant-prompt
vault
vim-interaction
vi-mode
virtualenv
virtualenvwrapper
volta
vscode
vundle
wakeonlan
wd
web-search
wp-cli
xcode
yarn
yii
yii2
yum
z
zbell
zeus
zoxide
zsh-interactive-cd
zsh-navigation-tools
