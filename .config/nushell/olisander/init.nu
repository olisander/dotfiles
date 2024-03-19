source 'git.nu'
source 'task.nu'
source 'alias.nu'

def commands [] {
    ['composer', 'up', 'down', 'boom', 'php', 'bin/console', 'provision-mac', 'db-import', 'es-setup', 'db', 'phpunit'] 
}

def core [
    command: string@commands
] {
    cd $env.CORE_PATH
        match $command {
            composer => {
                sk -c "docker exec core-backend-php-fpm composer list --raw" | cut -d ' ' -f1 | xargs -I{} docker exec core-backend-php-fpm composer {}
            }
            up => {
                docker compose -f docker-compose.yml -f docker-compose-dev.yml up --detach
            }
            down => {
                docker compose -f docker-compose.yml -f docker-compose-dev.yml down
            }
            boom => {
                docker compose -f docker-compose.yml -f docker-compose-dev.yml down
                docker system prune --all --volumes --force
            }
            php => {
                docker exec -it core-backend-php-fpm /bin/bash
            }
            bin/console => {
                sk -c "docker exec core-backend-php-fpm bin/console list --raw | rg '^moebel:'"| cut -d ' ' -f1 | xargs -I{} docker exec core-backend-php-fpm bin/console {}
            }
            provision-mac => {
                sh -c 'cd environment/ansible && bash provision_mac.sh'
            }
            db-import => {
                sh -c 'cd data/mysql/scripts && bash import-binary-backup-docker.sh'
            }
            es-setup => {
                docker exec core-backend-php-fpm bin/console moebel:core:elasticsearch:index-management recreate --all
                docker exec core-backend-php-fpm bin/console moebel:core:elasticsearch:export --all --partial
            }
            db => {
                sh -c 'cd data/mysql/scripts && bash import-binary-backup-docker.sh'
                docker exec core-backend-php-fpm composer db-migrate 
                docker exec core-backend-php-fpm bin/console moebel:core:elasticsearch:index-management recreate --all
                docker exec core-backend-php-fpm bin/console moebel:core:elasticsearch:export --all --partial
            }
            phpunit => {
                sk -c "docker exec core-backend-php-fpm find tests -type f -name "*Test*.php" | rg 'Unit'"| cut -d ' ' -f1 | xargs -I{} docker exec core-backend-php-fpm vendor/bin/paratest --no-coverage --cache-directory=../../var/.phpunit-cache --display-skipped --display-incomplete {}
            }
            _ => {
                let span = (metadata $command).span;
                error make {msg: "Unknown command", label: {text: "Command not Found", , span: $span } }
            }
        }
}
