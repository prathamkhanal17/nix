{ pkgs, lib, ...}:
{
	programs.nvf = {
		enable = true;
		settings = {
			vim = {
				theme = {
					enable = true;
					name = "gruvbox";
					style = "dark";
				};
				statusline.lualine.enable = true;
				telescope.enable = true;
				autocomplete.nvim-cmp.enable = true;
                                render-markdown-nvim.enable = true;
				languages = {
					enableLSP = true;
					enableTreesitter = true;
					nix.enable = true;
					python.enable = true;
                                        markdown = {
                                                enable = true;
                                                glow.enable = true;
                                                treesitter.enable = true;
                                                
                                        };

				};
			};

		};
	};
}
