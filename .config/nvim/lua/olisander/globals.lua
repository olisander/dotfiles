local globals = {
    -- Set <space> as the leader key
    --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
    mapleader = " ",
}

for k, v in pairs(globals) do
    vim.g[k] = v
end
