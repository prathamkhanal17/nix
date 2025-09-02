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
				lsp.enable = true;
				utility.preview.glow.enable= true;
				languages = {
					enableTreesitter = true;
					nix.enable = true;
					python.enable = true;
					markdown = {
							enable = true;
							treesitter.enable = true;
							
					};

				};
			};

		};
	};
}
