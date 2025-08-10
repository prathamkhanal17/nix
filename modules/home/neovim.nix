{config, pkgs, ...}:

{
	programs.neovim =
	let
		toLua = str: "lua << EOF\n${str}\nEOF\n";
		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
	in
	{
		enable = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;
		plugins = with pkgs.vimPlugins; [
		    {  
                plugin = gruvbox-nvim;
                config = "colorschem gruvbox";
                   
            }	
			{
				plugin = comment-nvim;
				config = toLua "require(\"Comment\").setup()";
			}
		];

		extraConfig = ''
			set number
			set tabstop=4
			set shiftwidth=4
			set expandtab
            set relativenumber
			'';


	};
}
