local js_based_languages = { "typescript", "javascript", "typescriptreact" }
lvim.builtin.treesitter.ensure_installed = {
  "javascript",
  "typescript",
  "tsx",
  "css",
}


for _, language in ipairs(js_based_languages) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      name = "Attach Browser",
      type = "pwa-chrome",
      request = "attach",
      port = 9222,
      url = "http://localhost:3000/*",
      webRoot = "${workspaceFolder}"
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach Node",
      port = 9229,
      restart = true,
      stopOnEntry = false,
      protocol = "inspector",
      trace = true,

    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Start Chrome with \"localhost\"",
      url = "http = //localhost:3000",
      webRoot = "${workspaceFolder}",
      userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
    }
  }
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
