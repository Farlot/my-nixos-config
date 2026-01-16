{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # 1. Aesthetics (Tokyo Night)
    colorschemes.tokyonight = {
      enable = true;
      settings.style = "storm"; # Options: storm, night, moon, day
    };

    # 2. Basic Options (The "Vim" stuff)
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
      clipboard = "unnamedplus"; # Sync with system clipboard
    };

    # 3. Syntax Highlighting (Treesitter)
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      # Nixvim installs parsers automatically, but you can force specific ones:
      # grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      #   nix python json markdown bash
      # ];
    };

    # 4. Status Line (Lualine)
    plugins.lualine = {
      enable = true;
      settings.options.theme = "tokyonight";
    };

    # 5. Fuzzy Finding (Telescope)
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
      };
    plugins.web-devicons.enable = true;
    };

    # 6. AI Agent (Ollama Integration)
    # This setup uses 'gen.nvim', a popular Ollama plugin.
    # Because it's an external plugin, we add it to extraPlugins.
    extraPlugins = [ pkgs.vimPlugins.gen-nvim ];

    extraConfigLua = ''
      require('gen').setup({
        model = "deepseek-r1:latest", -- Matches your Ollama config
        host = "localhost",
        port = "11434",
        display_mode = "float", -- float or split
        show_prompt = true,
        show_model = true,
      })

      -- Simple keybind to open the AI menu
      vim.keymap.set({'n', 'v'}, '<leader>aa', ':Gen<CR>')
    '';

    # 7. Key Globals
    globals.mapleader = " ";
  };
}
