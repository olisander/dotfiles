source 'git.nu'
source 'task.nu'
#Aliases
alias config = cd ~/.config 
alias lunch = cd $env.LUNCH_PATH
alias dotfiles = cd ~/code/dotfiles 

alias vim = nvim .
alias score = zellij --layout editor attach core --create
alias slunch = zellij --layout editor attach lunch --create

#Types
def commands [] {
    ['docker'] 
}

def parameters [context: string] {
    {   
        docker: ['up', 'down', 'php' , 'merchant-center']
    } | get ($context | split row " " | select 1 | first)
}

export def-env core [
    commands?: string@commands
    parameters?: string@parameters
] {
    match $commands {
        docker => {
            cd $env.CORE_PATH
            match $parameters {
                up => {
                    make dcup 
                }
                down => {
                    make dcdown 
                }
                php => {
                    make dcphp
                }
                merchant-center => {
                    make dcmc
                }
            }
        }
        _ => {
            cd $env.CORE_PATH
        }
    }
}
