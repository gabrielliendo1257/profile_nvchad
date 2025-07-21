return {
        'mfussenegger/nvim-jdtls',
        ft = "java",
        dependencies = {
            "rcarriga/nvim-dap-ui"
        },
        main = 'jdtls',
        config = function(plugin, _)
            -- local jdtls_config = require 'custom.config.jdtls'
    require("java")
    local jdtls = JdtlsConfiguration:new()
    local config = jdtls:factory_lsp_plugin()

            -- local config = {
            --     cmd = jdtls_config.cmd,
            --     root_dir = jdtls_config.root_dir,
            --     settings = jdtls_config.settings,
            --     capabilities = jdtls_config.capabilities,
            --     init_options = jdtls_config.init_options,
            --     on_attach = jdtls_config.on_attach,
            -- }

            vim.api.nvim_create_augroup('jdtls_lsp', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = 'jdtls_lsp',
                pattern = 'java',
                callback = function()
                    require(plugin.main).start_or_attach(config)
                end,
            })
        end,
        -- keys = require 'custom.keys.jdtls_keys',
    }
