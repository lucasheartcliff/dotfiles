local required_packages = {
  "kotlin-language-server",
  "ktlint",
  "gradle-language-server",
  "groovy-language-server",
  "lemminx",
  "xmlformatter",
}

local function list_missing(registry, names)
  local missing = {}
  for _, name in ipairs(names) do
    local ok, pkg = pcall(registry.get_package, name)
    if not ok or not pkg or not pkg:is_installed() then
      table.insert(missing, name)
    end
  end
  return missing
end

local ok_lazy, lazy = pcall(require, "lazy")
assert(ok_lazy, "lazy.nvim is not available. Run Lazy sync first.")
lazy.load({ plugins = { "mason.nvim" } })

local ok_mason, mason = pcall(require, "mason")
assert(ok_mason, "mason.nvim is not available")
mason.setup()

local ok_registry, registry = pcall(require, "mason-registry")
assert(ok_registry, "mason-registry is not available")

if registry.refresh then
  local refreshed = false
  registry.refresh(function()
    refreshed = true
  end)
  assert(vim.wait(60 * 1000, function()
    return refreshed
  end, 200), "Timed out while refreshing Mason registry")
end

for _, name in ipairs(required_packages) do
  local ok_pkg, pkg = pcall(registry.get_package, name)
  assert(ok_pkg and pkg, ("Mason package %q is not available in registry"):format(name))
  if not pkg:is_installed() and not pkg:is_installing() then
    pkg:install()
  end
end

local install_ok = vim.wait(15 * 60 * 1000, function()
  return #list_missing(registry, required_packages) == 0
end, 1000)

if not install_ok then
  local missing = list_missing(registry, required_packages)
  error("Timed out while installing Mason packages: " .. table.concat(missing, ", "))
end

print("OK: Mason Kotlin/Android packages are installed")
