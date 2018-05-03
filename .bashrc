# Settings
stty -ixon  # disable <c-s> flow control
shopt -s extglob


# Layout
export TERM="xterm-256color"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

if [[ $TERM == xterm* || $TERM == "screen" ]]; then
  export PS1='${debian_chroot:+($debian_chroot)}\[\e[01;31m\]\h: \[\e[01;32m\]\w\[\e[00m\] $ '
else
  export PS='${debian_chroot:+($debian_chroot)}\h: \w $ '
fi


# Command history
shopt -s cmdhist
shopt -s histappend
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
export HISTTIMEFORMAT="[%m-%d %T] "
alias hist="history | less +G"
alias ghist="history | grep"


# General
export EDITOR="vim"
export SVN_EDITOR=$EDITOR
export PATH="$HOME/bin:$PATH"
export bin="$HOME/bin"
export tmp="$HOME/tmp"
export opt="$HOME/opt"
export stow="$HOME/opt/stow"
export PATH="$opt/bin:$PATH"
export sr="$HOME/.ssh"
export src="$sr/config"


# Configs
export etc="$HOME/etc"
export cfg="$etc/configs"
export brc="$etc/configs/.bashrc"
alias brc="source $brc"
export brC="$etc/.bashrc.local"
alias brC="source $brC"

# Cheat sheets
export docs="$HOME/docs"
export cs="$docs/cheat"
export cb="$cs/bash"
export cp="$cs/python"
export cpn="$cp/numpy.txt"
export cpp="$cp/pandas.txt"
export cps="$cp/seaborn.txt"
export cpt="$cp/tensorflow.txt"
export cr="$cs/R"
export cv="$cs/vi"

# Alias
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias l.='ls ./'
alias l..='ls ../'
alias l...='ls ../../'
alias l....='ls ../../../'
alias rr='rm -rf'
alias rf='rm -rf'
alias cr='cp -r'
alias cx='chmod u+x'
alias mv='mv -i' # prompt before overwriting files
alias mk='mkdir -p'
alias c='clear'
alias bc='bc -l' # Calculator
alias du='du -h'
alias dus='du -hs'
alias df='df -h'
alias tx='tar xf'
alias tc='tar cf'
alias grep='grep --color'
alias tac='tail -r'
alias sql='sqlite3 -list'
alias le='less -I'
alias les='less -IS'
alias scp='scp -r'
alias Make='make -B'
alias wat='watch -n 1 tail -n 20'
alias wcl='wc -l'

# ls
export CLICOLOR=1
export LSCOLORS="ExFxCxDxBxegedabagacad" # Colors OSX
alias ll='ls -Alh'
alias lL='ls -Alhd'
alias la='ls -A'
alias lD='ls -d'
alias lDl='ls -ld'
alias lN='ln -s'

# Listing directory content
alias dir0="tree -L 1 -shC"
alias dir1="tree -L 2 -shC"
alias dir="tree -L 3 -shC"
alias dir9="tree -L 100 -shC"

# Job management
alias htop='htop -u $USER -d 10'
alias Jobs='jobs -l'
alias Kill='kill -9'
alias pKill="pkill -9 -n"
alias psa='ps a'
alias pss='pgrep -a'
alias psk='pkill -9'

function psx {
  local pattern=${1:-""}
  ps ax | grep "$pattern"
}






# Functions

function findf {
  local pattern="$@"
  cmd="find . -iname '*$pattern*'"
  echo $cmd
  eval $cmd
}

function abspath {
  # Return absolute path of possible non-existing file.
  file=$1
  if $(hash realpath &> /dev/null); then
    cmd="realpath"
  else
    cmd="readlink -f"
  fi
  if [[ -e $file ]]; then
    path=$($cmd $file)
  else
    if [[ ${file:0:1} == '/' ]]; then
      path=$file
    else
      path="$PWD/$file"
    fi
  fi
  if $(hash pbcopy &> /dev/null); then
    echo $path | tr -d '\n' | pbcopy
  fi
  echo $path
}
alias apath="abspath"

function grepr {
  local pattern="$1"
  local suffixes="${2:-py}"

  include=""
  for suffix in $suffixes; do
    include="$include --include '*.$suffix'"
  done
  cmd="grep $include -rI $pattern ."
  eval $cmd
}

function save {
  a=${1%/}
  if [[ $a == *.save ]]; then
    b=${a%.save}
  else
    b="$a.save"
  fi
  mv $a $b
}

function Save {
  a=${1%/}
  if [[ $a == *.save ]]; then
    b=${a%.save}
  else
    b="$a.save"
  fi
  cp -r $a $b
}

function Xargs {
  cmd=$@
  xargs -Ix $cmd x
}

function geti {
  i=$1
  shift
  values=($@)
  echo ${values[$i]}
}

function cdd {
  cmd="find . -maxdepth 1 -not -path '*/\.*' -name"
  files=$($cmd "1*$1" | sort -r)
  if [ -z "$files" ]; then
    files=$($cmd "*$1" | sort -r)
  fi
  for file in $files; do
    if [[ -d $file ]]; then
      cd $file
      break
    fi
  done
}


function countf {
  ls $@ | wc -l
}

function Countf {
  local pattern="$1"
  local dir="${2:-.}"
  cmd="find $dir -maxdepth 1 -not -path '.'"
  if [[ -n $pattern ]]; then
    cmd="$cmd -name '$pattern'"
  fi
  cmd="$cmd | wc -l"
  eval $cmd
}

function pdf2png {
  files=$@
  for file in $files; do
    cmd="convert -density 300 $file ${file%\.*}.png"
    eval $cmd
  done
}


function ddir {
  name=$(date '+%y%m%d')
  if [[ -n $1 ]]; then
    name="${name}_$1"
  fi
  mkdir $name
}

alias cdate='date +%y%m%d_%H%M%S'

function how {
  cmd=$1
  eval "$cmd --help | less"
}

# temporary directories

export tdirs="$tmp/tdirs"

function tdir {
  name=${1:-$RANDOM}
  path="$tmp/$(date +%y%m%d_%H%M%S)_tmpdir_$name"
  mkdir -p $path
  export tdir=$path
  echo $path
  echo $path >> $tdirs
}

function rtdir {
  local idx=${1:-1}

  if [[ -e $tdirs ]]; then
    export tdir=$(tail -n $idx $tdirs | head -n 1)
  fi
}
rtdir

alias tdirs="tail $tdirs"
alias ctdir="cd $tdir"

function rtdirs {
  to_del=$(ls -d $tmp/1*_tmpdir_* $tdirs 2> /dev/null)
  if [[ -n $to_del ]]; then
    echo $to_del
    rm -rI $to_del
  fi
}


# vim
export VR="$HOME/.vim"
export VRC="$HOME/.vimrc"
export VS="$VR/spell"
export VV="$VR/vundle.vim"
export VF="$VR/ftplugin"
export VFP="$VF/python.vim"
export VFR="$VF/r.vim"
export VFT="$VF/tex.vim"
export VLp="$VR/local_pre.vim"
export VLP="$VR/local_post.vim"

alias vim="vim -p"
alias vi="vim -p"
alias vih="vim -o"
alias viv="vim -O"
alias vid="vimdiff"


# tmux
export trc="$HOME/.tmux.conf"
alias trc="tmux source $trc"
export trC="$HOME/.tmux.conf.local"
export tm="$HOME/.tmux"
alias tmux="tmux -u"
alias tml="tmux ls"
alias tmk="tmux kill-session -t"

function tma {
  local name=$1
  if [[ -z $name ]]; then
    cmd="tmux attach || tmux new"
  else
    cmd="tmux attach -t $name || tmux new -s $name"
  fi
  eval $cmd
}

function tmn {
  local name=$1
  cmd="tmux new"
  if [[ -n $name ]]; then
    cmd="$cmd -s $name"
  fi
  eval $cmd
}


# Python
alias pyt='py.test -v -s'
alias wo='workon -n'
alias won='workon'
alias deact='deactivate'

## IPython
export ipy="$HOME/.ipython"
export ipyp="$ipy/profile_default/startup/00_default.py"

alias ipc='jupyter console'
alias ipn='jupyter notebook --no-browser'
alias ips='jupyter nbconvert --to slides --post serve'

function iph {
  in=$1
  out=${in%.ipynb}.html
  run=$2
  cmd="jupyter nbconvert --to html --output $out"
  if [ -n "$run" ]; then
    cmd="$cmd --ExecutePreprocessor.enabled=True"
  fi
  $cmd $in
}

alias ipha='for f in $(find . -not -path "./\.*" -name "*ipynb"); do iph $f; done'

## PIP
alias pipi='pip install -U'
alias pipr='pip uninstall'
alias pips='pip search'
alias pipl='pip list'
alias pipL='pip list -o | grep Latest'

function pipu {
  sudo=${1:-1}
  pip list -o | grep Latest | cut -f 1 -d ' ' | while read name; do
    echo "Updating $name ..."
    cmd="pip install -U $name"
    if [ $sudo -eq 1 ]; then
      cmd="sudo -H $cmd"
    fi
    eval $cmd
    if [ $? -ne 0 ]; then
      echo "$name failed!"
      echo $name >> log.err
    fi
  done
}



# Apt
alias apti="sudo apt-get install"
alias aptr="sudo apt-get remove"
alias apts="apt-cache search"
alias aptu="sudo apt-get update"
alias aptU="sudo apt-get upgrade"



# Git
export GIT_SSL_NO_VERIFY=true # avoid SSL problem
alias gits='git status -u'
alias gitc='git commit -m'
alias gitca='git add -A :/ && git commit -a -m'
alias gitcm='git commit -a -m "Minor changes"'
alias gitcd='git commit -a -m "Update documentation"'
alias gitcr='git commit -a -m "Update README"'
alias gitcc='git commit -a -m "Update configs"'
alias gitcs='git commit -a -m "Update cheat sheets"'
alias gita='git add'
alias gitme='git merge'
alias gitmv='git mv'
alias gitms='git merge sync/master'
alias gitA='git add -A :/'
alias gitd='git diff'
alias gitp='git pull'
alias gitP='git push'
alias gitx='git annex'
alias gitb='git branch -a'
alias giti='git init .'
alias gitco='git checkout'
alias gitcl='git clone'
alias gitl='git log'
alias gitbc='git rev-parse --abbrev-ref HEAD'
alias gitt='git tag'
alias gitT='git tag -l'

# checkout current branch to directory
function gitcod {
  path=$1
  if [ -n "$path" ]; then
    git checkout-index -a -f --prefix=$path/
  fi
}


# HDF
alias hls='h5ls'
alias hLs='h5ls -r'
alias hd='h5dump -d'



# R
function knit2pdf {
  rnw=${1:-index.Rnw}
  Rscript -e "library(knitr); knit2pdf('$rnw')"
}

function knit2html {
  rnw=${1:-index.Rmd}
  Rscript -e "library(knitr); knit2html('$rnw')"
}

function rmd2x {
  file=${1:-main.Rmd}
  out=${2:-html}  # html, pdf, word
  Rscript -e "library(rmarkdown); render('$file', output_format='${out}_document')"
}

function rmdRun {
  file=${1:-main.Rmd}
  shift
  args=$@
  if [ ! -z "$args" ]; then
    args=", $args"
  fi
  Rscript -e "library(methods); rmarkdown::run('$file'$args)"
}

function shinyRun {
  file=${1:-main.Rmd}
  shift
  args=${@:-launch.browser = T}
  if [ ! -z "$args" ]; then
    args=", $args"
  fi
  Rscript -e "library(methods); shiny::runApp('$file'$args)"
}


# Compression
function zipd {
  local path=$1
  path=${path%/}
  zip -r $(basename $path).zip $path
}

alias zipr="zip -r"
alias gz="gzip"
alias gZ="gunzip"

function Gz {
  infile=$1
  outfile=$2
  if [[ -z $outfile ]]; then
    outfile=$1.gz
  fi
  gzip -c $infile > $outfile
}

function GZ {
  infile=$1
  outfile=$2
  if [[ -z $outfile ]]; then
    outfile=${infile%.gz}
  fi
  gunzip -c $infile > $outfile
}


# Testing
export tests="$HOME/docs/tests"
export tesp="$tests/test.py"
export tess="$tests/test.sh"

alias tesp="python $tesp"
