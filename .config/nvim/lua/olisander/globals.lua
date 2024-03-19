local globals = {
	-- Set <space> as the leader key
	-- See `:help mapleader`
	--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
	mapleader = " ",
	maplocalleader = " ",
}

for k, v in pairs(globals) do
	vim.g[k] = v
end
