vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages

local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end

local _, dap = pcall(require, "dap")
dap.set_log_level("DEBUG")

function start_debugger()
  local JAVA_PORT = 5005
  dap.configurations.java = {
    {
      type = "java",
      request = "attach",
      name = "Attach to remote Java server",
      hostName = "localhost",
      timeout = 50000,
      port = JAVA_PORT, -- The port on which the server is listening
    },
  }
  dap.continue()
end

-- Determine OS
local home = os.getenv("HOME")
if vim.fn.has("mac") == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "mac"
elseif vim.fn.has("unix") == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "linux"
else
  print("Unsupported system")
end

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
    "\n"
  )
)

local config = {
  cmd = {

    -- 💀
    "java", -- or '/path/to/java11_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version

    -- 💀
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.

    "-data",
    workspace_dir,
  },
  -- on_attach = require("lvim.lsp").on_attach,
  root_dir = root_dir,
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
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-8",
            path = "~/.sdkman/candidates/java/8.0.362-amzn",
          },
          --   {
          --   name = "JavaSE-11",
          --   path = "~/.sdkman/candidates/java/11.0.18-amzn",
          --},
          -- {
          --   name = "JavaSE-17",
          --   path = "~/.sdkman/candidates/java/17.0.6-amzn",
          -- },
        },
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
        enabled = false,
        -- settings = {
        --   profile = "asdf"
        -- }
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
    extendedClientCapabilities = extendedClientCapabilities,
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
  flags = {
    allow_incremental_sync = true,
  },
  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    -- bundles = {},
    bundles = bundles,
  },
}
config["on_attach"] = function(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = "auto" })
end

-- This starts a new client & servert,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)

vim.cmd(
  [[command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)]]
)
-- vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
-- vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
-- -- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
-- vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
-- -- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

local keymap = vim.keymap

keymap.set(
  "n",
  "<leader>cv",
  "<cmd>lua require'jdtls'.extract_variable()<cr>",
  { desc = "Extract Variable", remap = true }
)
keymap.set(
  "n",
  "<leader>cc",
  "<cmd>lua require'jdtls'.extract_constant()<cr>",
  { desc = "Extract Constant", remap = true }
)
keymap.set(
  "n",
  "<leader>ct",
  "<cmd>lua require'jdtls'.test_nearest_method()<cr>",
  { desc = "Test Method", remap = true }
)
keymap.set("n", "<leader>cT", "<cmd>lua require'jdtls'.test_class()<cr>", { desc = "Test Class", remap = true })
keymap.set(
  "n",
  "<leader>co",
  "<cmd>lua require'jdtls'.organize_imports()<cr>",
  { desc = "Organize Imports", remap = true }
)
