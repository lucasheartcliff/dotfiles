return {

  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
    end,
  },

  -- yaml schema support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "vuki656/package-info.nvim",
    lazy = true,
    config = function()
      require("package-info").setup()
      -- Show dependency versions
      vim.keymap.set({ "n" }, "<LEADER>Ds", require("package-info").show, { silent = true, noremap = true })

      -- Hide dependency versions
      vim.keymap.set({ "n" }, "<LEADER>Dc", require("package-info").hide, { silent = true, noremap = true })

      -- Toggle dependency versions
      vim.keymap.set({ "n" }, "<LEADER>Dt", require("package-info").toggle, { silent = true, noremap = true })

      -- Update dependency on the line
      vim.keymap.set({ "n" }, "<LEADER>Du", require("package-info").update, { silent = true, noremap = true })

      -- Delete dependency on the line
      vim.keymap.set({ "n" }, "<LEADER>Dd", require("package-info").delete, { silent = true, noremap = true })

      -- Install a new dependency
      vim.keymap.set({ "n" }, "<LEADER>Di", require("package-info").install, { silent = true, noremap = true })

      -- Install a different dependency version
      vim.keymap.set({ "n" }, "<LEADER>Dp", require("package-info").change_version, { silent = true, noremap = true })

      require("telescope").load_extension("package_info")
    end,
  },
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
}
