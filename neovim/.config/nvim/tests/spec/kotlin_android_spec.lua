local repo_root = vim.uv.cwd()
local kotlin_module = repo_root .. "/neovim/.config/nvim/lua/user/plugins/lsp/lang/kotlin.lua"
local fixture_root = repo_root .. "/neovim/.config/nvim/tests/fixtures/android-sample"

-- kotlin.lua depends on lspconfig.util; provide a small test stub for -u NONE runs.
package.preload["lspconfig.util"] = function()
  return {
    root_pattern = function(...)
      local patterns = { ... }
      return function(fname)
        local dir = vim.fs.dirname(fname)
        local found = vim.fs.find(patterns, { path = dir, upward = true })[1]
        if found then
          return vim.fs.dirname(found)
        end
        return nil
      end
    end,
  }
end

local function contains(tbl, value)
  for _, item in ipairs(tbl or {}) do
    if item == value then
      return true
    end
  end
  return false
end

local function find_plugin(spec, repo)
  for _, plugin in ipairs(spec) do
    if plugin[1] == repo then
      return plugin
    end
  end
end

local function assert_contains_all(values, required, label)
  for _, name in ipairs(required) do
    assert(contains(values, name), ("%s is missing %q"):format(label, name))
  end
end

local function assert_any_root(actual, accepted, label)
  for _, expected in ipairs(accepted) do
    if actual == expected then
      return
    end
  end
  error(("%s mismatch. Got %q"):format(label, tostring(actual)))
end

local spec = dofile(kotlin_module)
assert(type(spec) == "table", "kotlin.lua must return a table")

local treesitter = find_plugin(spec, "nvim-treesitter/nvim-treesitter")
assert(treesitter and type(treesitter.opts) == "function", "treesitter plugin opts not found")
local ts_opts = { ensure_installed = {} }
treesitter.opts(nil, ts_opts)
assert_contains_all(ts_opts.ensure_installed, { "kotlin", "java", "groovy", "xml" }, "treesitter ensure_installed")

local lspconfig = find_plugin(spec, "neovim/nvim-lspconfig")
assert(lspconfig and type(lspconfig.opts) == "function", "lspconfig plugin opts not found")
local lsp_opts = { servers = {}, setup = {} }
lspconfig.opts(nil, lsp_opts)

assert(type(lsp_opts.servers.kotlin_language_server) == "table", "missing kotlin_language_server config")
assert(type(lsp_opts.servers.gradle_ls) == "table", "missing gradle_ls config")
assert(type(lsp_opts.servers.groovyls) == "table", "missing groovyls config")
assert(type(lsp_opts.servers.lemminx) == "table", "missing lemminx config")
assert(type(lsp_opts.setup.kotlin_language_server) == "function", "missing kotlin_language_server setup guard")
assert(type(lsp_opts.setup.gradle_ls) == "function", "missing gradle_ls setup guard")
assert(type(lsp_opts.setup.groovyls) == "function", "missing groovyls setup guard")
assert(type(lsp_opts.setup.lemminx) == "function", "missing lemminx setup guard")

local kotlin_file = fixture_root .. "/app/src/main/java/com/example/MainActivity.kt"
local xml_file = fixture_root .. "/app/src/main/AndroidManifest.xml"
local gradle_file = fixture_root .. "/app/build.gradle.kts"
local accepted_roots = {
  fixture_root,
  fixture_root .. "/app",
}

assert_any_root(lsp_opts.servers.kotlin_language_server.root_dir(kotlin_file), accepted_roots, "kotlin root_dir")
assert_any_root(lsp_opts.servers.lemminx.root_dir(xml_file), accepted_roots, "xml root_dir")
assert_any_root(lsp_opts.servers.gradle_ls.root_dir(gradle_file), accepted_roots, "gradle root_dir")

local mason = find_plugin(spec, "mason.nvim")
assert(mason and type(mason.opts) == "function", "mason plugin opts not found")
local mason_opts = { ensure_installed = {} }
mason.opts(nil, mason_opts)
assert_contains_all(mason_opts.ensure_installed, {
  "kotlin-language-server",
  "ktlint",
  "gradle-language-server",
  "groovy-language-server",
  "lemminx",
  "xmlformatter",
}, "mason ensure_installed")

print("OK: Kotlin/Android Neovim config spec checks passed")
