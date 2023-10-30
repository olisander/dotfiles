list: # list commands
	@grep '^[^#[:space:]].*:' Makefile

link: # link all
	@make link-nvim -i
	@make link-alacritty -i
	@make link-nushell -i
	@make link-zellij -i

link-nvim: # link Neovim 
	unlink ~/.config/nvim
	ln -s $(realpath ./)/.config/nvim ~/.config/nvim 

link-alacritty: # link Neovim 
	unlink ~/.config/alacritty
	ln -s $(realpath ./)/.config/alacritty ~/.config/alacritty 

link-nushell: # link Nushell 
	rm -rf ~/Library/Application\ Support/nushell
	ln -s $(realpath ./)/.config/nushell ~/Library/Application\ Support/nushell 

link-zellij: # link Zellij
	unlink ~/.config/zellij
	ln -s $(realpath ./)/.config/zellij ~/.config/zellij

