alias la='ls -a'
alias vi=vim
alias vo='vim -R'
alias so=source
alias h=history
alias mav='module av'
alias ma='module load'
alias mau='module unload'
alias mlist='module list'
alias duhm='du -h --max-depth=1'
alias ll='ls -rtlh'
alias c=clear
alias pwdc='pwd | xargs echo -n | xclip'
alias lc='ll ; l -rtlh | sed "s/.* //" | tail -n 1 | xargs echo -n | xclip'
alias grep='grep --color=auto -n'

#alias cd='chdir \!* && ls'
alias cdp='cd ~/project/'
alias cdd='cd /data/jiaqi.huo/project/'
alias fdm='find . -name "\!*"'
alias sop='source `pwd | sed "s+\<esl\>.*+esl/scripts/env.bash+"`'
alias reso='source ~/.bashrc'
alias py='python3'
alias vscode='/home/jiaqi.huo/Tools/software/VSCode-linux-x64/bin/code'

export LD_LIBRARY_PATH=/home/jiaqi.huo/Tools/lib/:$LD_LIBRARY_PATH
export PATH=/snap/bin/:$PATH
export PATH=/home/jiaqi.huo/Tools/bin/:$PATH
export PATH=/home/jiaqi.huo/Tools/script/:$PATH
export PATH=/home/jiaqi.huo/Tools/software/valgrind/bin:$PATH

cl() {
        cd "$@" && ls
}

#alias cd='cl'

export SYSTEMC_HOME=/home/jiaqi.huo/Tools/bin/systemc
export SYSTEMC_INCLUDE=$SYSTEMC_HOME/include
export SYSTEMC_LIBRARY=$SYSTEMC_HOME/lib-linux64
export LD_LIBRARY_PATH=$SYSTEMC_LIBRARY:$LD_LIBRARY_PATH
export LIBRARY_PATH=$SYSTEMC_LIBRARY:$LIBRARY_PATH
export PATH=/home/jiaqi.huo/.allspark/llvm/bin/:$PATH
unset TMOUT
ulimit -c 0
