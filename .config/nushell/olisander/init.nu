source 'git.nu'
source 'task.nu'
source 'alias.nu'
source 'ssh.nu'

def "nu-complete composer" [] {
  ^docker exec core-backend-php-fpm composer list --raw | parse --regex '(?P<value>\S+)\s+(?P<description>.*)'
}

def "nu-complete bin/console" [] {
  ^docker exec core-backend-php-fpm bin/console list --raw | parse --regex '(?P<value>\S+)\s+(?P<description>.*)'
}

def "nu-complete container" [] {
  cd $env.CORE_PATH
  ^docker compose -f docker-compose.yml -f docker-compose-dev.yml ps --format json | lines | each { |it| from json } | get "Name"
}

# Run a composer command in the core-backend-php-fpm container
def "core composer" [
  command: string@"nu-complete composer" # Composer command 
] {
    docker exec core-backend-php-fpm composer $command
}

# Run a symfony console command in the core-backend-php-fpm container
def "core bin/console" [
  command: string@"nu-complete bin/console" # Console command 
] {
    docker exec core-backend-php-fpm bin/console $command
}

# Start Orbstack
def "core orbstack" [] {
    ^open -a orbstack
}

# start the core containers
def "core up" [] {
    docker compose -f $'($env.CORE_PATH)/docker-compose.yml' -f $'($env.CORE_PATH)/docker-compose-dev.yml' up --detach
}

# Stop the core Containers
def "core down" [] {
    docker compose -f $'($env.CORE_PATH)/docker-compose.yml' -f $'($env.CORE_PATH)/docker-compose-dev.yml' down
}

# Destroy the core Containers
def "core boom" [] {
    core down
    docker system prune --all --volumes --force
}

# Get a shell in a container 
def "core shell" [
  container: string@"nu-complete container" # container 
] {
    docker exec -it $container /bin/bash
}

# Import the binary backup and run the migrations
def "core db" [] {
    core db-import
    docker exec core-backend-php-fpm composer db-migrate 
    core es-setup
}

# Run the provision-mac script 
def "core provision-mac" [] {
    cd $env.CORE_PATH
    sh -c 'cd environment/ansible && bash provision_mac.sh'
}

# Run the import-db script
def "core db-import" [] {
    cd $env.CORE_PATH
    sh -c "cd data/mysql/scripts && bash import-binary-backup-docker.sh copy-back partial"
}

# Setup the elasticsearch indexes
def "core es-setup" [] {
    docker exec core-backend-php-fpm bin/console moebel:core:elasticsearch:index-management index_delete_recreate_active_passive --all
    docker exec core-backend-php-fpm bin/console moebel:core:elasticsearch:export full_sequential_active --all
}
