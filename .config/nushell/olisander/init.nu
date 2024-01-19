source 'git.nu'
source 'task.nu'
source 'alias.nu'

def commands [] {
    ['composer', 'up', 'php', 'bin/console'] 
}

def core [
    commands: string@commands
] {
    cd $env.CORE_PATH
        match $commands {
            composer => {
                sk -c "docker exec core-backend-php-fpm composer list --raw"| cut -d ' ' -f1 | xargs -I{} docker exec core-backend-php-fpm composer {}
            }
            up => {
                docker compose -f docker-compose.yml -f docker-compose-dev.yml up --detach
            }
            php => {
                docker exec -it core-backend-php-fpm /bin/bash
            }
            bin/console => {
                sk -c "docker exec core-backend-php-fpm bin/console list --raw | rg '^moebel:'"| cut -d ' ' -f1 | xargs -I{} docker exec core-backend-php-fpm bin/console {}
            }
        }
}
