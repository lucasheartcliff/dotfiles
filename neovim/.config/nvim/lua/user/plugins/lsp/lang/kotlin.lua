local function android_root_dir(fname)
  local util = require("lspconfig.util")
  return util.root_pattern(
    "settings.gradle.kts",
    "settings.gradle",
    "build.gradle.kts",
    "build.gradle",
    "gradle.properties",
    ".git"
  )(fname)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "kotlin", "java", "groovy", "xml" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.setup = opts.setup or {}

      opts.servers.kotlin_language_server = vim.tbl_deep_extend("force", opts.servers.kotlin_language_server or {}, {
        root_dir = android_root_dir,
        single_file_support = true,
      })

      opts.servers.gradle_ls = vim.tbl_deep_extend("force", opts.servers.gradle_ls or {}, {
        root_dir = android_root_dir,
      })

      opts.servers.groovyls = vim.tbl_deep_extend("force", opts.servers.groovyls or {}, {
        root_dir = android_root_dir,
      })

      opts.servers.lemminx = vim.tbl_deep_extend("force", opts.servers.lemminx or {}, {
        root_dir = android_root_dir,
      })

      for _, server in ipairs({ "kotlin_language_server", "gradle_ls", "groovyls", "lemminx" }) do
        local existing_setup = opts.setup[server]
        opts.setup[server] = function(name, server_opts)
          local ok, lspconfig = pcall(require, "lspconfig")
          if not ok or not lspconfig[name] then
            return true
          end
          if existing_setup then
            return existing_setup(name, server_opts)
          end
        end
      end
    end,
  },
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, pkg in ipairs({
        "kotlin-language-server",
        "ktlint",
        "gradle-language-server",
        "groovy-language-server",
        "lemminx",
        "xmlformatter",
      }) do
        if not vim.tbl_contains(opts.ensure_installed, pkg) then
          table.insert(opts.ensure_installed, pkg)
        end
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("none-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.ktlint,
        nls.builtins.formatting.ktlint,
        nls.builtins.formatting.xmlformat,
      })
    end,
  },
}
