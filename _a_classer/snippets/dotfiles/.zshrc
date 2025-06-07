
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Set list of themes to pick from when loading at random
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=/path/to/new-custom-folder

export ZSH=$HOME/.oh-my-zsh
export EDITOR='nano'

# NICE THEMES> random sporty jonathan candy
ZSH_THEME="agnoster"

alias refresh="clear && zsh"

plugins=(
    dotenv
    django
    git
    git-auto-fetch
    git-extras
    git-flow
    git-prompt
    git-remote-branch
    colored-man-pages
    gpg-agent
    kubectl
    helm
    last-working-dir
    pass
    zsh-syntax-highlighting
    zsh-navigation-tools
    zsh-autosuggestions
    ssh-agent
    ubuntu
    terraform
    vscode
    virtualenvwrapper
    virtualenv
)


source $ZSH/oh-my-zsh.sh
# source /tmp/git-extras/etc/git-extras-completion.zsh


if [ -f "$HOME/.profile" ]; then . "$HOME/.profile"; fi
if [ -f "$HOME/.aliases" ]; then . "$HOME/.aliases"; fi


#--------------------------------
# OVERRIDE PROMPT
#--------------------------------
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{● %G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖ %G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚ %G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[red]↓ %G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[green]↑ %G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔ %G%}"
build_prompt1() {
  RETVAL=$?
  prompt_status
  prompt_segment white black "$(whoami)"'@'"${HOST}" #HOST
  prompt_bzr
  prompt_hg
  prompt_end
}
build_prompt2() {
  RETVAL=$?
  prompt_status
  prompt_segment blue white '%~' #DIRECTORY
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_end
}
RPROMPT=''
PROMPT=\
'$(build_prompt1) $FG[015]$(git_super_status) $FG[087]$(virtualenv_prompt_info) $FG[099]$(tf_prompt_info)
$(build_prompt2)
'



#-------------------
# OTHER PLUGINS
#-------------------
#		autojump				bower				
#		bundler		 			cp					django
#		docker-compose 			zsh_reload			thefuck
#		docker-machine			ubuntu				terraform
#		docker					dotenv 				ssh-agent
#		git-extras				python				pylint
#		git-auto-fetch			git-remote			gulp
#		git-flow				virtualenv			helm
#		git-hubflow				git-remote-branch	github
#		git-prompt				pip					jsontools
#		git-remote-branch		jump				gpg-agent
#		gitfast					grunt					
