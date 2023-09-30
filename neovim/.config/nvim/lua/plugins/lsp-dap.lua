return {
  --Python
  { "mfussenegger/nvim-dap-python" },
  { "nvim-neotest/neotest" },
  { "nvim-neotest/neotest-python" },
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },
  -- Java
  { "mfussenegger/nvim-jdtls" },

  --Typescript
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  -- {
  --     "neovim/nvim-lspconfig",
  --     dependencies = {
  --         "jose-elias-alvarez/typescript.nvim",
  --         init = function()
  --             require("lazyvim.util").on_attach(function(_, buffer)
  --                 -- stylua: ignore
  --                 vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports",
  --                     { buffer = buffer, desc = "Organize Imports" })
  --                 vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
  --             end)
  --         end,
  --     },
  --     ---@class PluginLspOpts
  --     opts = {
  --         ---@type lspconfig.options
  --         servers = {
  --             -- tsserver will be automatically installed with mason and loaded with lspconfig
  --             tsserver = {},
  --         },
  --         -- you can do any additional lsp server setup here
  --         -- return true if you don't want this server to be setup with lspconfig
  --         ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  --         setup = {
  --             -- example to setup with typescript.nvim
  --             tsserver = function(_, opts)
  --                 require("typescript").setup({ server = opts })
  --                 return true
  --             end,
  --             -- Specify * to use this function as a fallback for any server
  --             -- ["*"] = function(server, opts) end,
  --         },
  --     },
  -- },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "jdtls",
        "tsserver",
      },
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
}
