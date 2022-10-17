# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
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
      ".config/sway"
      ".config/waybar"
      ".config/syncthing"
      ".config/rofi"
    ];
    files = [
    ];
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    keepassxc
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

  services.syncthing.enable = true;


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
    shellInit = ''
      if test -z $DISPLAY; and test (tty) = "/dev/tty1"
      sway
      end
    '';
    shellAliases = {
      cat = "bat";
      ls = "exa -la";
      ll = "exa -lah";

      gs = "git status";
      gp = "git pull";

      mkdir = "mkdir -p";
      syscfg = "nvim ~/downloads/nix-config/nixos/configuration.nix";
      sysup = "sudo nixos-rebuild switch --flake ~/downloads/nix-config/.#iscte";
      homecfg = "nvim ~/downloads/nix-config/home-manager/home.nix";
      homeup = "home-manager switch --flake ~/downloads/nix-config/.#celso@iscte";
      upd = "nix-channel --update && homeup";
    };

    shellAbbrs = {
      n = "nvim";
      g = "git";
    };

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
      vim.g.mapleader = ' '

      -- Undo files
      vim.opt.undofile = true
      vim.opt.undodir = os.getenv("HOME")..'/.cache/nvim'

      -- Indentation
      vim.opt.smartindent = true
      vim.opt.autoindent = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true

      -- System Clipboard
      vim.opt.clipboard = "unnamedplus"

      -- Mouse Support
      vim.opt.mouse = "a"

      -- Nice UI
      vim.opt.termguicolors = true
      vim.opt.cursorline = true
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- Colorscheme
      vim.cmd("colorscheme nightfox")

      -- Annoying VimInfo
      vim.opt.viminfo = ""
      vim.opt.viminfofile = "NONE"

      -- Quality of Life
      vim.opt.smartcase = true
      vim.opt.ttimeoutlen = 5
      vim.opt.compatible = false
      vim.opt.autoread = true
      vim.opt.incsearch = true
      vim.opt.hidden = true
      vim.opt.shortmess = "atI"

      luafile /home/celso/.config/nvim/lua/treesitter.lua
    '';
    plugins = with pkgs.vimPlugins; [

      # File Tree
      nvim-web-devicons
      {
        plugin = nvim-tree-lua;
        config = ''
          vim.g.loaded = 1
          vim.g.loaded_netrwPlugin = 1
          require("nvim-tree").setup{}
          require("nvim-web-devicons").setup()
          local map = vim.api.nvim_set_keymap

          map('n', '<leader>t', [[:NvimTreeToggle<CR>]], {})            -- open/close
          map('n', '<leader>f', [[:NvimTreeRefresh<CR>]], {})       -- refresh
          map('n', '<leader>n', [[:NvimTreeFindFile<CR>]], {})      -- search file
        '';
      }

      #LSP
      {
        plugin = nvim-lspconfig;
        config = ''
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
          require("tokyonight").setup({
            style = "night",
          })
          vim.cmd[[colorscheme tokyonight]]
        '';
      }
      indentLine
      {
        plugin = barbar-nvim;
        config = ''
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
        '';
      }
      {
        plugin = lualine-nvim;
        config = ''
                    require('lualine').setup {
            options = {
              theme = 'tokyonight'
            }
          }
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
          require ("telescope").setup()
        '';
      }
      {
        plugin = nvim-autopairs;
        config = ''
          require ("nvim-autopairs").setup {}
        '';
      }

    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
