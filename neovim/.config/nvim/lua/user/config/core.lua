local config = require("user.config")
config.setup()
config.init()

return {
  { "folke/lazy.nvim", version = "*" },
}
