local lspconfig_package = require("lspconfig")
local lspconfig_commons = require("plugins.configs.lspconfig")
local util = require("lspconfig.util")


lspconfig_package.pyright.setup({
    on_init = function(client)
        -- Puedes modificar la configuración en tiempo de ejecución aquí si lo necesitas
        -- Por ejemplo, cambiar settings si no hay `pyrightconfig.json`
        local path = client.workspace_folders and client.workspace_folders[1].name or nil
        if path and not vim.loop.fs_stat(path .. '/pyrightconfig.json') then
            client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                python = {
                    analysis = {
                        typeCheckingMode = "basic", -- También puede ser: "off", "strict"
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace", -- o "openFilesOnly"
                    }
                }
            })
        end
    end,

    filetypes = { "python" },

    root_dir = function(fname)
        -- Busca pyproject.toml, setup.py, requirements.txt, o carpeta .git
        return util.root_pattern(
            'pyrightconfig.json',
            'pyproject.toml',
            'setup.py',
            'requirements.txt',
            '.git'
        )(fname) or util.find_git_ancestor(fname) or vim.loop.cwd()
    end,

    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,

    -- Puedes conectar tus propias funciones de `on_attach` y `capabilities`
    -- on_attach = on_attach,
    capabilities = lspconfig_commons.capabilities,

    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                diagnosticMode = "workspace",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                -- stubPath = vim.fn.stdpath("data") .. "/pyright-stubs",
                -- extraPaths = {
                --     vim.fn.expand("~/.local/lib/python3.*/site-packages"),
                -- },
            }
        }
    }
})

lspconfig_package.clangd.setup({
    capabilities = lspconfig_commons.capabilities,
})

-- vim.lsp.enable('angularls')

lspconfig_package.angularls.setup {}

-- lspconfig_package.ts_ls.setup({
--     capabilities = lspconfig_commons.capabilities,
-- })
