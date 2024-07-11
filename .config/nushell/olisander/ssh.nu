def "nu-complete ssh" [] {
  ^cat ~/.ssh/config | rg '^Host .*(sk|sk-db)$' | awk '{print $2}' | lines
}

# Secure Shell
export extern "ssh" [
  host: string@"nu-complete ssh" # Host
]
