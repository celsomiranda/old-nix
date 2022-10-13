# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule
    inputs.impermanence.homeManagerModule
    # Feel free to split up your configuration and import pieces of it here.
  ];

  home = {
    username = "celso";
    homeDirectory = "/home/celso";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    desktop = "desktop";
    documents = "docs";
    download = "downloads";
    music = "music";
    pictures = "pictures";
    videos = "videos";
    publicShare = "pub";
    templates = "templates";
  };


  home.persistence."/nix/persist/home/celso" = {
    allowOther = true;
    directories = [
      "docs"
      "downloads"
      "pictures"
      "videos"
      "music"
      "pub"
      "templates"
      ".ssh"
      ".mozilla"
      ".config/nvim"
      ".config/sway"
      ".config/wofi"
    ];
    files = [
      ".bash_history"
    ];
  };



  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    rnix-lsp
    sumneko-lua-language-server
    nixpkgs-fmt
    bat
    exa
    ripgrep
    fzf
    fd
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # GIT
  programs.git = {
    enable = true;
    userName = "Celso Miranda";
    userEmail = "769237+celsomiranda@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
    };
    ignores = [ ".DS_Store" "*.pyc" ];

  };

  # GITHUB
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
      aliases = {
        co = "pr checkeout";
        pv = "pr view";
      };
    };
  };

  # SSH
  programs.ssh = {
    enable = true;
  };

  # FISH
  programs.fish = {
    enable = true;
    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "autopair-fish"; src = pkgs.fishPlugins.autopair-fish.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
    ];
    shellAliases = {
      cat = "bat";
      ls = "exa -la";
      ll = "exa -lah";

      gs = "git status";
      gp = "git pull";

      mkdir = "mkdir -p";
      homecfg = "nvim ~/GitHub/wsl-nix-home/home.nix";
      homeup = "home-manager -f ~/GitHub/wsl-nix-home/home.nix switch";
      upd = "nix-channel --update && homeup";
    };

    shellAbbrs = {
      n = "nvim";
      g = "git";
    };

    shellInit = ''
      . /home/celso/.nix-profile/etc/profile.d/nix.fish
    '';
    functions = {
      fish_greeting = {
        body = "";
      };

      gcom = {
        body = ''
          function gcom
          git add .
          git commit -m "$argv"
          end
        '';
      };

      lazyg = {
        body = ''
          function lazyg
          git add .
          git commit -m "$argv"
          git push
          end
        '';
      };
    };
  };

  # Starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
      shlvl = {
        disabled = true;
        symbol = "ﰬ";
        style = "bright-red bold";
      };
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-white) ";
        zsh_indicator = "[ZSH](bright-white) ";
      };
      username = {
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };
    };
  };

  # TMUX
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      {
        plugin = nord;
        extraConfig = "set -g @plugin 'arcticicestudio/nord-tmux'";
      }
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    shortcut = "a";
  };

  # NEOVIM
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      local opt = vim.opt
      local g = vim.g

      g.mapleader = ' '

      -- Undo files
      opt.undofile = true
      opt.undodir = os.getenv("HOME")..'/.cache/nvim'

      -- Indentation
      opt.smartindent = true
      opt.autoindent = true
      opt.tabstop = 4
      opt.shiftwidth = 4
      opt.expandtab = true

      -- System Clipboard
      opt.clipboard = "unnamedplus"

      -- Mouse Support
      opt.mouse = "a"

      -- Nice UI
      opt.termguicolors = true
      opt.cursorline = true
      opt.number = true
      opt.relativenumber = true

      -- Colorscheme
      --require('nord').set()
      --g.nord_contrast = true
      --
      vim.cmd("colorscheme nightfox")

      -- Annoying VimInfo
      opt.viminfo = ""
      opt.viminfofile = "NONE"

      -- Quality of Life
      opt.smartcase = true
      opt.ttimeoutlen = 5
      opt.compatible = false
      opt.autoread = true
      opt.incsearch = true
      opt.hidden = true
      opt.shortmess = "atI"

      luafile /home/celso/.config/nvim/lua/treesitter.lua
    '';
    plugins = with pkgs.vimPlugins; [

      # File Tree
      nvim-web-devicons
      {
        plugin = nvim-tree-lua;
        config = ''
          lua << EOF
          vim.g.loaded = 1
          vim.g.loaded_netrwPlugin = 1
          require("nvim-tree").setup{}
          require("nvim-web-devicons").setup()
          local map = vim.api.nvim_set_keymap

          map('n', '<leader>t', [[:NvimTreeToggle<CR>]], {})            -- open/close
          map('n', '<leader>f', [[:NvimTreeRefresh<CR>]], {})       -- refresh
          map('n', '<leader>n', [[:NvimTreeFindFile<CR>]], {})      -- search file
          EOF
        '';
      }

      #LSP
      {
        plugin = nvim-lspconfig;
        config = ''
          lua < < EOF
            vim.defer_fn
            (function
              ()
                require'lspconfig'.rnix.setup
                { }
                require'lspconfig'.sumneko_lua.setup
                { }

                vim.o.completeopt = "menuone,noselect"

              require'compe'.setup
              {
                enabled = true;
                autocomplete = true;
                debug = false;
                min_lenght = 1;
                preselect = 'enable';
                throttle_time = 80;
                source_timeout = 200;
                incomplete_delay = 200;
                max_abbr_width = 100;
                max_kind_width = 100;
                max_menu_width = 100;
                documentation = false;
                souce = {
                  path = true;
                  buffer = true;
                  nvim_lsp = true;
                  nvim_lua = true;
                  treesitter = true;
                };
              }

            - - Set Tab
              local
              t =
            function
            (str)
            return
            vim.api.nvim_replace_termcodes
            (str,
            true, true, true)
          end
          _G.tab_complete = function()
          if vim.fn.pumvisible() == 1 then
          return t "<C-n>"
          else
          return t "<S-Tab>"
          end
          end

          vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})



          end, 70)
          EOF

        '';
      }
      nvim-lspconfig
      nvim-compe

      # Eyecandy
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      nvim-treesitter-context
      nightfox-nvim
      {
        plugin = tokyonight-nvim;
        config = ''
          lua << EOF
          require("tokyonight").setup({
            style = "night",
          })
          vim.cmd[[colorscheme tokyonight]]
          EOF
        '';
      }
      indentLine
      {
        plugin = barbar-nvim;
        config = ''
          lua << EOF
          local map = vim.api.nvim_set_keymap
          local opts = { noremap = true, silent = true }

          -- Move to previous/next
          map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
          map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
          -- Re-order to previous/next
          map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
          map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
          -- Goto buffer in position...
          map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
          map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
          map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
          map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
          map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
          map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
          map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
          map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
          map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
          map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
          -- Pin/unpin buffer
          map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
          -- Close buffer
          map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
          -- Wipeout buffer
          --                 :BufferWipeout
          -- Close commands
          --                 :BufferCloseAllButCurrent
          --                 :BufferCloseAllButPinned
          --                 :BufferCloseAllButCurrentOrPinned
          --                 :BufferCloseBuffersLeft
          --                 :BufferCloseBuffersRight
          -- Magic buffer-picking mode
          map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
          -- Sort automatically by...
          map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
          map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
          map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
          map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
          EOF
        '';
      }
      {
        plugin = lualine-nvim;
        config = ''
          lua << EOF
          require('lualine').setup {
            options = {
              theme = 'tokyonight'
            }
          }
          EOF
        '';
      }

      # Languages
      vim-nix

      # WebDev Plugins
      nvim-colorizer-lua
      vim-closetag
      pears-nvim

      # Misc
      {
        plugin = telescope-nvim;
        config = ''
          lua << EOF
          require ("telescope").setup()
          EOF
        '';
      }
      {
        plugin = nvim-autopairs;
        config = ''
          lua << EOF
          require ("nvim-autopairs").setup {}
          EOF
        '';
      }

    ];
  };

  # Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };
  programs.waybar.enable = true;
  programs.fuse.userAllowOther = true;
  programs.light.enable = true;




  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
