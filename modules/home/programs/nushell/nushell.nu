alias cp = cp -iv
alias gaa = git add --all
alias cat = bat
alias mv = mv -iv
alias rm = rm -iv 
alias trash = rm -t

def initrs [path = "./."] {
    mkdir $path
    cd $path
    # use 'do -p' because the nix command exists with error if the template is not fully applied.
    do -p { nix flake init -t 'github:ipetkov/crane#quick-start-simple' }
    'use flake' | save ./.envrc
    direnv allow
}

$env.config = {
  show_banner: false,
}