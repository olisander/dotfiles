# Moving
alias config = cd ~/.config 

alias code = cd $env.CODE_PATH 
alias furniture-core = cd $env.CORE_PATH
alias lunch = cd $env.LUNCH_PATH

alias personal = cd $env.PERSONAL_PATH 
alias dotfiles = cd $env.DOTFILES_PATH 

# Vim
alias vim = nvim .
alias score = zellij --layout editor attach core --create
alias slunch = zellij --layout editor attach lunch --create

# Other
alias cat = bat --paging=never
