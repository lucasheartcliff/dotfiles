local lazy_status, lazy = pcall(require, "lazy")

lazy.setup({
  spec = {
    { "LazyVim/LazyVim",                                import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "plugins" },
  },
})

local dap_status, dap = pcall(require, "dap")
if not dap.adapters["pwa-node"] then
  require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      -- 💀 Make sure to update this path to point to your installation
      args = {
        require("mason-registry").get_package("js-debug-adapter"):get_install_path()
        .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
end
for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
  if not dap.configurations[language] then
    dap.configurations[language] = {
      {
        name = "Chrome (9222)",
        type = "chrome",
        request = "attach",
        program = "${file}",
        url = "http://localhost:3000/*",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
      {
        type = "node2",
        request = "attach",
        name = "Attach Node",
        port = 9229,
        restart = true,
        sourceMaps = true,
        console = "integratedTerminal",
        stopOnEntry = false,
        protocol = "inspector",
        trace = true,

      },
    }
  end
end


-- Which Key Setup --

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end



local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  C = {
    name = "TS",
    a = { ":TSLspImportAll<CR>", "Import All" },
    o = { ":TSLspOrganizeImports<CR>", "Organize Imports" },
    v = { ":TSLspExtractVariable<CR>", "Extract Variable" },
    c = { ":TSLspExtractConst<CR>", "Extract Constant" },
    f = { ":TSLspExtractFunction<CR>", "Extract Function" },
  },
}

which_key.register(mappings, opts)
