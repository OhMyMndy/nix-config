return {
    colorscheme = "catppuccin",
    plugins = {
      {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context"
        },
         opts = {
            ensure_installed = {
              "bash",
              "dockerfile",
              "go",
              "gomod",
              "gosum",
              "hcl",
              "json",
              "lua",
              "make",
              "markdown",
              "markdown_inline",
              "python",
              "regex",
              "terraform",
              "toml",
              "vim",
              "yaml"
            },
          }, 
      },
      {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup {
                color_overrides = {
                    all = {
                        red = "#eb34c0",
                    }
                }
            }
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        -- see: https://github.com/williamboman/mason-lspconfig.nvim
        opts = {
          ensure_installed = { 
            "bashls",
            "dockerls",
            "docker_compose_language_service",
            "gopls",
            "jsonls",
            "lua_ls",
            "rnix",
            "intelephense",
            "pyright",
            "tflint",
            "terraformls" }, -- automatically install lsp
        },
      },
      {
        "nvim-treesitter/nvim-treesitter-context"
      }
    },
  }