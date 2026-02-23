local Util = require("user.util")

local java_filetypes = { "java" }
local java_home_cache = {}

local function java_major_from_home(java_home)
  if not java_home or java_home == "" then
    return nil
  end
  local java_bin = vim.fs.joinpath(java_home, "bin", "java")
  if vim.fn.executable(java_bin) == 0 then
    return nil
  end
  local out = vim.fn.system({ java_bin, "-version" })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return tonumber(out:match('version%s+"(%d+)'))
end

local function find_java_home_for_major(target_major)
  if java_home_cache[target_major] ~= nil then
    return java_home_cache[target_major] or nil
  end

  local candidates = {}
  local function add_candidate(path)
    if path and path ~= "" then
      table.insert(candidates, path)
    end
  end

  add_candidate(vim.env.JAVA21_HOME)
  add_candidate(vim.env.JDK21_HOME)
  add_candidate(vim.env.JAVA_HOME)
  add_candidate("~/.sdkman/candidates/java/current")

  vim.list_extend(candidates, vim.fn.glob("~/.sdkman/candidates/java/*", false, true))
  vim.list_extend(candidates, vim.fn.glob("~/.asdf/installs/java/*", false, true))
  vim.list_extend(candidates, vim.fn.glob("/usr/lib/jvm/*", false, true))

  local seen = {}
  for _, candidate in ipairs(candidates) do
    local expanded = vim.fn.expand(candidate)
    local realpath = vim.uv.fs_realpath(expanded) or expanded
    if realpath and realpath ~= "" and not seen[realpath] then
      seen[realpath] = true
      if java_major_from_home(realpath) == target_major then
        java_home_cache[target_major] = realpath
        return realpath
      end
    end
  end

  java_home_cache[target_major] = false
  return nil
end

local function java_root_dir(fname)
  local util = require("lspconfig.util")
  local root_files = {
    { ".git", "build.gradle", "build.gradle.kts" },
    { "build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts" },
  }

  for _, patterns in ipairs(root_files) do
    local root = util.root_pattern(unpack(patterns))(fname)
    if root then
      return root
    end
  end

  return util.path.dirname(fname)
end

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end

return {
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "java" })
    end,
  },

  -- Ensure java debugger and test packages are installed.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "jdtls", "java-test", "java-debug-adapter" })
        end,
      },
    },
  },

  -- nvim-jdtls owns the full jdtls lifecycle. We intentionally avoid
  -- configuring jdtls via nvim-lspconfig to prevent duplicate clients.
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        jdtls = function()
          return true
        end,
      },
    },
  },

  -- Set up nvim-jdtls to attach to java files.
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "folke/which-key.nvim" },
    ft = java_filetypes,
    opts = function()
      local status, jdtls = pcall(require, "jdtls")
      if not status then
        return
      end
      local extendedClientCapabilities = jdtls.extendedClientCapabilities
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
      return {
        -- How to find the root dir for a given filename. The default comes from
        -- lspconfig which provides a function specifically for java projects.
        root_dir = java_root_dir,

        -- How to find the project name for a given root dir.
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        settings = {
          java = {
            -- jdt = {
            --   ls = {
            --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
            --   }
            -- },
            eclipse = {
              downloadSources = true,
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            inlayHints = {
              parameterNames = {
                enabled = "all", -- literals, all, none
              },
            },
            format = {
              enabled = true,
              settings = {
                url = vim.fn.stdpath("config") .. "/lua/user/config/formatters/google_java_formatter.xml",
                profile = "GoogleStyle",
              },
            },
          },
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
          },
          contentProvider = { preferred = "fernflower" },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
        extendedClientCapabilities = extendedClientCapabilities,
        jdtls_cmd_env = function()
          local java21_home = find_java_home_for_major(21)
          if java21_home then
            return { JAVA_HOME = java21_home }
          end
          return nil
        end,
        jdtls_java_executable = function()
          local java21_home = find_java_home_for_major(21)
          if not java21_home then
            return nil
          end
          local java_executable = vim.fs.joinpath(java21_home, "bin", "java")
          if vim.fn.executable(java_executable) == 1 then
            return java_executable
          end
          return nil
        end,
        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = { "jdtls" },
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          local java_executable = opts.jdtls_java_executable and opts.jdtls_java_executable() or nil
          if java_executable then
            vim.list_extend(cmd, { "--java-executable", java_executable })
          end
          local lombok_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
          if project_name then
            if vim.uv.fs_stat(lombok_path) then
              vim.list_extend(cmd, {
                "--jvm-arg=-javaagent:" .. lombok_path,
              })
            end
            vim.list_extend(cmd, {
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,

        -- These depend on nvim-dap, but can additionally be disabled by setting false here.
        dap = { hotcodereplace = "auto", config_overrides = {} },
        test = true,
      }
    end,
    config = function()
      local opts = Util.opts("nvim-jdtls") or {}

      -- Find the extra bundles that should be passed on the jdtls command-line
      -- if nvim-dap is enabled with java debug/test.
      local mason_registry = require("mason-registry")
      local bundles = {} ---@type string[]
      if opts.dap and Util.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
        local jar_patterns = {}
        local java_dbg_path = Util.mason_package_path("java-debug-adapter")
        if java_dbg_path then
          vim.list_extend(jar_patterns, {
            java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
          })
        end
        -- java-test also depends on java-debug-adapter.
        if opts.test and mason_registry.is_installed("java-test") then
          local java_test_path = Util.mason_package_path("java-test")
          if java_test_path then
            vim.list_extend(jar_patterns, {
              java_test_path .. "/extension/server/*.jar",
            })
          end
        end
        for _, jar_pattern in ipairs(jar_patterns) do
          for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
            table.insert(bundles, bundle)
          end
        end
      end

      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end
        -- Configuration can be augmented and overridden by opts.jdtls
        local config = extend_or_override({
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          init_options = {
            bundles = bundles,
            extendedClientCapabilities = opts.extendedClientCapabilities,
          },
          settings = opts.settings,
          capabilities = capabilities,
          cmd_env = opts.jdtls_cmd_env and opts.jdtls_cmd_env() or nil,
        }, opts.jdtls)

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(config)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })

      -- Setup keymap and dap after the lsp is fully attached.
      -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      -- https://neovim.io/doc/user/lsp.html#LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local wk = require("which-key")
            wk.register({
              ["<leader>cx"] = { name = "+extract" },
              ["<leader>cxv"] = { require("jdtls").extract_variable_all, "Extract Variable" },
              ["<leader>cxc"] = { require("jdtls").extract_constant, "Extract Constant" },
              ["gs"] = { require("jdtls").super_implementation, "Goto Super" },
              ["gS"] = { require("jdtls.tests").goto_subjects, "Goto Subjects" },
              ["<leader>co"] = { require("jdtls").organize_imports, "Organize Imports" },
            }, { mode = "n", buffer = args.buf })
            wk.register({
              ["<leader>c"] = { name = "+code" },
              ["<leader>cx"] = { name = "+extract" },
              ["<leader>cxm"] = {
                [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                "Extract Method",
              },
              ["<leader>cxv"] = {
                [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                "Extract Variable",
              },
              ["<leader>cxc"] = {
                [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                "Extract Constant",
              },
            }, { mode = "v", buffer = args.buf })

            if opts.dap and Util.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
              -- custom init for Java debugger
              --
              local debug_configs = {
                {
                  type = "java",
                  request = "attach",
                  name = "Attach to remote Java server",
                  hostName = "localhost",
                  timeout = 50000,
                  port = 5005, -- The port on which the server is listening
                },
              }

              require("jdtls").setup_dap(opts.dap)
              require("jdtls.dap").setup_dap_main_class_configs()
              local status, dap = pcall(require, "dap")
              if not status then
                return
              end
              dap.configurations.java = debug_configs

              -- Java Test require Java debugger to work
              if opts.test and mason_registry.is_installed("java-test") then
                -- custom keymaps for Java test runner (not yet compatible with neotest)
                wk.register({
                  ["<leader>t"] = { name = "+test" },
                  ["<leader>tt"] = { require("jdtls.dap").test_class, "Run All Test" },
                  ["<leader>tr"] = { require("jdtls.dap").test_nearest_method, "Run Nearest Test" },
                  ["<leader>tT"] = { require("jdtls.dap").pick_test, "Run Test" },
                }, { mode = "n", buffer = args.buf })
              end
            end

            -- User can set additional keymaps in opts.on_attach
            if opts.on_attach then
              opts.on_attach(args)
            end
          end
        end,
      })

      -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
      attach_jdtls()
    end,
  },
}
