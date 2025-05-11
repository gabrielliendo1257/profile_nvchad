return {
    {
        'mfussenegger/nvim-jdtls',
        ft = "java",
        dependencies = {
            "rcarriga/nvim-dap-ui"
        },
        main = 'jdtls',
        config = function(plugin)
            local jdtls_config = require 'custom.config.jdtls'

            local config = {
                cmd = jdtls_config.cmd,
                root_dir = jdtls_config.root_dir,
                settings = jdtls_config.settings,
                capabilities = jdtls_config.capabilities,
                init_options = jdtls_config.init_options,
                on_attach = jdtls_config.on_attach,
            }

            vim.api.nvim_create_augroup('jdtls_lsp', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = 'jdtls_lsp',
                pattern = 'java',
                callback = function()
                    require(plugin.main).start_or_attach(config)
                end,
            })
        end,
        keys = require 'custom.keys.jdtls_keys',
    },
    {
        "neovim/nvim-lspconfig",
        keys = require("custom.keys.lsp-keys"),
        config = function(_, _)
            require("custom.lang-servers")
        end
    },

    {
        'williamboman/mason.nvim',
        lazy = false,
        dependencies = {
            {
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                main = 'mason-tool-installer',
                opts = {
                    ensure_installed = {
                        'prettier', -- prettier formatter
                        -- 'stylua', -- lua formatter
                        -- 'isort', -- python formatter
                        'black',    -- python formatter
                        'mypy',     -- python linter
                        'eslint_d', -- js linter
                        'pyright',
                        -- 'lua-language-server',
                        'java-test',
                        'java-debug-adapter',
                        'jdtls',
                    },
                },
            },
        },
        main = 'mason',
    },

    -- Testing
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python"
        },
        opts = function()
            local adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    runner = "pytest",
                }),
            }

            return adapters
        end,
        main = "neotest",
    },

    -- DAP
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>db", "<cmd> DapToggleBreakpoint <CR>", desc = "[D]ap breakpoint.",          mode = "n", silent = true },
            { "<leader>dl", "<cmd> DapClearBreakpoints <CR>", desc = "[D]ap [C]lear breakpoints.", mode = "n", silent = true },
            { "<F5>",       "<cmd> DapContinue <CR>",         desc = "Start/Continue Debug",       mode = "n" },
            { "<F10>",      "<cmd< DapTerminate <CR>" },
            { "<F6>",       "<cmd> DapStepOver <CR>",         desc = "Step Over",                  mode = "n" },
            { "<F7>",       "<cmd> DapStepInto <CR>",         desc = "Step Into",                  mode = "n" },
            { "<F8>",       "<cmd> DapStepOut <CR>",          desc = "Step Out",                   mode = "n" },
            {
                "<leader>ds",
                function()
                    local widgets = require("dap.ui.widgets")
                    widgets.centered_float(widgets.scopes, { border = "rounded" })
                end,
                desc = "DAP Scopes",
            },
        },
        config = function(_, _)
            -- Signs
            for _, group in pairs({
                "DapBreakpoint",
                "DapBreakpointCondition",
                "DapBreakpointRejected",
                "DapLogPoint",
            }) do
                vim.fn.sign_define(group, { text = "●", texthl = group })
            end
        end
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui"
        },
        keys = {
            {
                "<leader>dpr",
                function()
                    require("dap_python").test_method()
                end,
                desc = "[D]ap test method.",
                silent = true
            }
        },
        config = function(_, _)
            local dap_python = require("dap-python")
            local debugpy_os = require("custom.os.debugpy-os")

            -- Instala debugpy con Mason o manualmente
            dap_python.setup(debugpy_os.get_path_debugpy())

            -- Opcional: configuración extra
            dap_python.test_runner = "pytest"
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function(_, _)
            local dap, dapui = require("dap"), require("dapui")

            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },

    -- Kind Icons
    {
        "onsails/lspkind.nvim"
    },

    -- CMP
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        lazy = false,
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
            },
            'saadparwaiz1/cmp_luasnip',
            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
        main = 'cmp',
        opts = function(plugin, opts)
            -- See `:help cmp`
            local cmp = require(plugin.main)
            local luasnip = require 'luasnip'
            local lspkind = require('lspkind')
            -- local new_kind_icon = require 'ui'

            opts = {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm { select = true },
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),

                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                },
                formatting = {
                    fields = { 'kind', 'abbr', 'menu' },
                    format = lspkind.cmp_format({
                        mode = "symbol", -- show only symbol annotations
                        maxwidth = {
                            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                            -- can also be a function to dynamically calculate max width such as
                            -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                            menu = 50,            -- leading text (labelDetails)
                            abbr = 50,            -- actual suggestion item
                        },
                        ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        before = function(entry, vim_item)
                            -- ...
                            return vim_item
                        end
                    })
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            }
            return opts
        end,
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'make',

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
        },
        main = "telescope",
        keys = {
            { '<leader>sh',       require 'telescope.builtin'.help_tags,   desc = '[S]earch [H]elp',                mode = "n" },
            { '<leader>sk',       require 'telescope.builtin'.keymaps,     desc = '[S]earch [K]eymaps',             mode = "n" },
            { '<leader>sf',       require 'telescope.builtin'.find_files,  desc = '[S]earch [F]iles',               mode = "n" },
            { '<leader>ss',       require 'telescope.builtin'.builtin,     desc = '[S]earch [S]elect Telescope',    mode = "n" },
            { '<leader>sw',       require 'telescope.builtin'.grep_string, desc = '[S]earch current [W]ord',        mode = "n" },
            { '<leader><leader>', require 'telescope.builtin'.buffers,     desc = '[S]earch Find existing buffers', mode = "n" },
            { '<leader>sg',       require 'telescope.builtin'.live_grep,   desc = '[S]earch by [G]rep',             mode = "n" },
        },
        opts = {
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            --
            -- defaults = {
            --   mappings = {
            --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            --   },
            -- },
            -- pickers = {}
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        },
        config = function(plugin, opts)
            pcall(require(plugin.main).load_extension, 'fzf')
            pcall(require(plugin.main).load_extension, 'ui-select')

            require(plugin.main).setup(opts)
        end
    },

    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            { 'MunifTanjim/nui.nvim', lazy = true },
            {
                'rcarriga/nvim-notify',
                lazy = true,
                event = 'VeryLazy',
                keys = {
                    {
                        '<leader>un',
                        function()
                            require('notify').dismiss { silent = true, pending = true }
                        end,
                        desc = 'Delete all Notifications',
                    },
                },
                opts = {
                    timeout = 3000,
                    max_height = function()
                        return math.floor(vim.o.lines * 0.75)
                    end,
                    max_width = function()
                        return math.floor(vim.o.columns * 0.75)
                    end,
                },
            },
        },
        opts = {
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
            lsp = {
                progress = {
                    enabled = true,
                    format = 'lsp_progress',
                    format_done = 'lsp_progress_done',
                    throttle = 1000 / 30,
                    view = 'mini',
                },
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
        },
    },

    {
        "akinsho/bufferline.nvim",
        lazy = false,
        main = "bufferline",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            {
                "<TAB>",
                "<cmd>BufferLineCycleNext<CR>",
                desc = "[B]ufferline Next",
                mode = "n",
                silent = true,
                noremap = true,
            },
            {
                "<S-TAB>",
                "<cmd>BufferLineCyclePrev<CR>",
                desc = "[B]ufferline Prev",
                mode = "n",
                silent = true,
                noremap = true,
            },
            {
                "<C-d>",
                "<cmd>BufferLineCloseOthers<CR>",
                desc = "[B]ufferline Close Others",
                mode = "n",
                silent = true,
                noremap = true,
            },
        },
        config = true,
    },

    {
        "windwp/nvim-ts-autotag",
        config = true,
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            enable_autocmd = false,
        }
    }
}
