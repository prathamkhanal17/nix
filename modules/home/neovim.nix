{
  config,
  pkgs,
  lib,
  ...
}:

let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
in
{
  home.packages = with pkgs; [
    ripgrep
    fd
    git
    stylua
    nixfmt-rfc-style
    python3
    python3Packages.debugpy
    python3Packages.pytest
    python3Packages.requests
    pyright
    ruff # provides `ruff server` LSP
    black
    isort
    trash-cli  # <— for NvimTree trash support
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      pyright
      ruff
    ];

    plugins = with pkgs.vimPlugins; [
      gruvbox-nvim
      lualine-nvim
      nvim-web-devicons
      gitsigns-nvim
      todo-comments-nvim
      trouble-nvim
      which-key-nvim
      mini-icons
      nvim-autopairs
      vim-surround
      telescope-nvim
      plenary-nvim
      (nvim-treesitter.withAllGrammars)
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      friendly-snippets
      conform-nvim
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      comment-nvim
      render-markdown-nvim
      vim-startify
      nvim-tree-lua
      vim2nix
    ];

    extraConfig = ''
      let mapleader = " "
      set number relativenumber
      set tabstop=4 shiftwidth=4 expandtab
      set clipboard=unnamedplus
      set updatetime=300
      set signcolumn=yes
      set splitbelow splitright
      set cursorline
      set termguicolors
      set background=dark
      colorscheme gruvbox

      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap <leader>Q :qa!<CR>
      nnoremap <leader>ev :e $MYVIMRC<CR>
      nnoremap <leader>sv :source $MYVIMRC<CR>
      nnoremap <silent> <leader>ss :Startify<CR>

      " nvim-tree
      nnoremap <silent> <C-n> :NvimTreeToggle<CR>
      nnoremap <silent> <leader>nf :NvimTreeFindFile<CR>

      nnoremap <leader>v2 :Vim2Nix<CR>
      inoremap jk :<Esc>x
    ''
    + toLua ''
      -- UI setup
      require("lualine").setup({ options = { theme = "gruvbox" } })
      require("gitsigns").setup()
      require("todo-comments").setup()
      require("trouble").setup()
      require("nvim-autopairs").setup({})
      require("render-markdown").setup({})
      vim.keymap.set("n", "<leader>rm", "<cmd>RenderMarkdown toggle<CR>", { desc = "Markdown: toggle render" })

      -- which-key
      local wk = require("which-key")
      wk.setup({})
      local tb = require("telescope.builtin")
      wk.add({
        { "<leader>/", function() require("Comment.api").toggle.linewise.current() end, desc = "Toggle comment" },
        { "<leader>Q", ":qa!<CR>", desc = "Quit all (force)" },
        { "<leader>q", ":q<CR>",   desc = "Quit" },
        { "<leader>w", ":w<CR>",   desc = "Save" },
        { "<leader>ff", function() tb.find_files() end,  desc = "Files" },
        { "<leader>fg", function() tb.live_grep() end,   desc = "Live grep" },
        { "<leader>fb", function() tb.buffers() end,     desc = "Buffers" },
        { "<leader>fh", function() tb.help_tags() end,   desc = "Help" },
        { "<leader>fd", function() tb.diagnostics() end, desc = "Diagnostics" },
        { "<leader>n",  group = "File Tree" },
        { "<leader>nt", "<cmd>NvimTreeToggle<CR>",   desc = "Tree: Toggle" },
        { "<leader>nf", "<cmd>NvimTreeFindFile<CR>", desc = "Tree: Reveal file" },
      })

      -- Telescope
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = function(...) actions.smart_send_to_qflist(...); actions.open_qflist(...) end,
            },
            n = { ["<C-q>"] = function(...) actions.smart_send_to_qflist(...); actions.open_qflist(...) end },
          },
        },
      })

      -- Treesitter
      local parser_dir = vim.fn.stdpath("data") .. "/treesitter"
      vim.opt.runtimepath:append(parser_dir)
      require("nvim-treesitter.configs").setup({
        parser_install_dir = parser_dir,
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = false,
        sync_install = false,
        ensure_installed = {},
      })

      -- nvim-tree (modern config with trash support)
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        view = { width = 35, preserve_window_proportions = true },
        renderer = {
          group_empty = true,
          highlight_git = true,
          indent_markers = { enable = true },
        },
        filters = { dotfiles = false, git_ignored = false },
        actions = {
          use_system_clipboard = true,
          open_file = { quit_on_open = false, resize_window = true },
        },
        trash = {
          cmd = "trash",        -- provided by trash-cli
          require_confirm = true,
        },
      })

      -- Buffer-local mappings inside the tree (CRUD + clipboard)
      local function nvim_tree_on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "Tree: " .. desc })
        end
        -- open / refresh / help
        map("<CR>",  api.node.open.edit,      "Open")
        map("o",     api.node.open.edit,      "Open")
        map("<C-r>", api.tree.reload,         "Refresh")
        map("?",     api.tree.toggle_help,    "Help")
        -- create / delete / rename / duplicate
        map("a", api.fs.create,               "Create")
        map("d", api.fs.remove,               "Delete")
        map("r", api.fs.rename,               "Rename")
        map("y", api.fs.copy.node,            "Duplicate")
        -- clipboard
        map("x", api.fs.cut,                  "Cut")
        map("c", api.fs.copy.node,            "Copy")
        map("p", api.fs.paste,                "Paste")
        -- toggle dotfiles
        map("H", api.tree.toggle_hidden_filter, "Toggle dotfiles")
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvimTree",
        callback = function(args) nvim_tree_on_attach(args.buf) end,
      })

      -- Completion
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fb)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fb() end
          end, { "i","s" }),
          ["<S-Tab>"] = cmp.mapping(function(fb)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fb() end
          end, { "i","s" }),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "path" }, { name = "buffer" } }),
      })

      -- LSP (Pyright + Ruff from Nix)
      local lspconfig = require("lspconfig")
      local caps = require("cmp_nvim_lsp").default_capabilities()
      local util = require("lspconfig.util")

      local function on_attach(_, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        nmap("gd", vim.lsp.buf.definition, "Go to definition")
        nmap("K", vim.lsp.buf.hover, "Hover docs")
      end

      local root = util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git")

      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = caps,
        cmd = { "${pkgs.pyright}/bin/pyright-langserver", "--stdio" },
        root_dir = function(fname) return root(fname) or vim.loop.cwd() end,
      })

      lspconfig.ruff.setup({
        on_attach = on_attach,
        capabilities = caps,
        cmd = { "${pkgs.ruff}/bin/ruff", "server" },
        root_dir = function(fname) return root(fname) or vim.loop.cwd() end,
      })

      -- Conform
      require("conform").setup({
        format_on_save = { lsp_fallback = true },
        formatters_by_ft = { python = { "isort","black" }, lua = { "stylua" } },
      })
      vim.keymap.set({ "n","v" }, "<leader>cf", function() require("conform").format({ async = true }) end, { desc = "Format" })

      -- DAP (Python debugpy)
      require("nvim-dap-virtual-text").setup()
      local dap,dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.adapters.python = {
        type = "executable",
        command = "${pkgs.python3Packages.debugpy}/bin/python",
        args = { "-m","debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = function() return vim.fn.expand("%:p") end,
          console = "integratedTerminal",
          pythonPath = function()
            if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV.."/bin/python" end
            return "${pkgs.python3}/bin/python3"
          end,
        },
      }
      vim.keymap.set("n","<F5>",dap.continue,{desc="Debug: Continue"})
    '';
  };
}

