return { -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          local notify = require("notify")
          notify.dismiss({
            silent = true,
            pending = true,
          })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 300,
      render = "default",
      stages = "slide",
      max_height = function()
        return math.floor(vim.o.lines * 0.5)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.5)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("user.util")
      if not Util.has("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  }, -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({
          plugins = { "dressing.nvim" },
        })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({
          plugins = { "dressing.nvim" },
        })
        return vim.ui.input(...)
      end
    end,
  }, -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>bt",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle pin",
      },
      {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete non-pinned buffers",
      },
      {
        "<leader>bn",
        "<Cmd>BufferLineCycleNext<CR>",
        desc = "Next buffer",
      },
      {
        "<leader>bm",
        "<Cmd>BufferLineCyclePrev<CR>",
        desc = "Prev buffer",
      },
    },
    opts = {
      options = {
                -- stylua: ignore
                close_command = function(n)
                    require("mini.bufremove").delete(n, false)
                end,
                -- stylua: ignore
                right_mouse_command = function(n)
                    require("mini.bufremove").delete(n, false)
                end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("user.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  }, -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "andweeb/presence.nvim" },
    event = "VeryLazy",
    opts = function()
      local icons = require("user.config").icons
      local Util = require("user.util")
      local wakatime = {
        value = "",
        in_flight = false,
        last_updated_ms = 0,
      }
      local wakatime_refresh_ms = 2 * 60 * 1000

      local function refresh_wakatime()
        if wakatime.in_flight or vim.fn.exists("*WakaTimeToday") == 0 then
          return
        end

        wakatime.in_flight = true
        local ok = pcall(vim.fn.WakaTimeToday, function(output)
          wakatime.value = type(output) == "string" and vim.trim(output) or ""
          wakatime.last_updated_ms = vim.uv.now()
          wakatime.in_flight = false

          vim.schedule(function()
            if package.loaded["lualine"] then
              require("lualine").refresh({
                place = { "statusline" },
              })
            end
          end)
        end)

        if not ok then
          wakatime.in_flight = false
        end
      end

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              function()
                local ok, presence = pcall(require, "presence")
                local connected = ok and presence.is_connected
                return string.format("%s %s", icons.kinds.Discord, connected and "●" or "○")
              end,
              color = function()
                local ok, presence = pcall(require, "presence")
                local connected = ok and presence.is_connected
                return connected and Util.fg("String") or Util.fg("Comment")
              end,
            },
            -- {
            --     "filetype",
            --     icon_only = true,
            --     separator = "",
            --     padding = {
            --         left = 1,
            --         right = 0
            --     }
            -- },
            -- {
            --     "filename",
            --     path = 1,
            --     symbols = {
            --         modified = "  ",
            --         readonly = "",
            --         unnamed = ""
            --     }
            -- } -- stylua: ignore
          },
          lualine_x = { -- stylua: ignore
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = Util.fg("Statement"),
            }, -- stylua: gg ignore
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = Util.fg("Constant"),
            }, -- stylua: ignore
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = Util.fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = Util.fg("Special"),
            },
            {
              function()
                if vim.uv.now() - wakatime.last_updated_ms > wakatime_refresh_ms then
                  refresh_wakatime()
                end

                if wakatime.value == "" then
                  return ""
                end

                return "󱑆 " .. wakatime.value
              end,
              cond = function()
                return vim.fn.exists("*WakaTimeToday") == 1
              end,
              color = Util.fg("Identifier"),
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = {
                left = 1,
                right = 0,
              },
            },
            {
              "location",
              padding = {
                left = 0,
                right = 1,
              },
            },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  }, -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  }, --
  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "LazyFile",
    enabled = false,
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = {
        try_as_border = true,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  }, -- Displays a popup with possible key bindings of the command you started typing
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      if require("user.util").has("noice.nvim") then
        opts.defaults["<leader>sn"] = {
          name = "+noice",
        }
      end
    end,
  }, -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              {
                find = "%d+L, %d+B",
              },
              {
                find = "; after #%d+",
              },
              {
                find = "; before #%d+",
              },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
        -- stylua: ignore
        keys = { {
            "<S-Enter>",
            function()
                require("noice").redirect(vim.fn.getcmdline())
            end,
            mode = "c",
            desc = "Redirect Cmdline"
        }, {
            "<leader>snl",
            function()
                require("noice").cmd("last")
            end,
            desc = "Noice Last Message"
        }, {
            "<leader>snh",
            function()
                require("noice").cmd("history")
            end,
            desc = "Noice History"
        }, {
            "<leader>sna",
            function()
                require("noice").cmd("all")
            end,
            desc = "Noice All"
        }, {
            "<leader>snd",
            function()
                require("noice").cmd("dismiss")
            end,
            desc = "Dismiss All"
        }, {
            "<c-f>",
            function()
                if not require("noice.lsp").scroll(4) then
                    return "<c-f>"
                end
            end,
            silent = true,
            expr = true,
            desc = "Scroll forward",
            mode = { "i", "n", "s" }
        }, {
            "<c-b>",
            function()
                if not require("noice.lsp").scroll(-4) then
                    return "<c-b>"
                end
            end,
            silent = true,
            expr = true,
            desc = "Scroll backward",
            mode = { "i", "n", "s" }
        } }
,
  }, -- Dashboard. This runs when neovim starts, and is what displays
  -- the "LAZYVIM" banner.
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = table.concat({
        "            ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗            ",
        "            ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║            ",
        "            ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║            ",
        "            ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║            ",
        "            ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║            ",
        "            ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝            ",
        "",
        "                            [@lucasheartcliff]                            ",
      }, "\n")

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<cmd> Telescope find_files <cr>"),
        dashboard.button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files", "<cmd> Telescope oldfiles <cr>"),
        dashboard.button("g", " " .. " Find text", "<cmd> Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " Config", "<cmd> e $MYVIMRC <cr>"),
        dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
        dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      local laststatus = vim.o.laststatus
      vim.o.laststatus = 0
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      vim.api.nvim_create_autocmd("BufUnload", {
        once = true,
        buffer = vim.api.nvim_get_current_buf(),
        callback = function()
          vim.opt.laststatus = laststatus
        end,
      })

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  }, -- lsp symbol navigation for lualine. This shows where
  -- in the code structure you are - within functions, classes,
  -- etc - in the statusline.
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("user.util").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("user.config").icons.kinds,
        lazy_update_context = true,
      }
    end,
  }, -- icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  }, -- ui components
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
}
