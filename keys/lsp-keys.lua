return {

    { '<leader>cd', require('telescope.builtin').lsp_definitions,               desc = '[G]oto [D]efinition',     mode = 'n', silent = true },
    { '<leader>cg', require('telescope.builtin').diagnostics,                   desc = '[G]oto [D]iagnostics',    mode = 'n', silent = true },

    -- Find references for the word under your cursor.
    { '<leader>cR', require('telescope.builtin').lsp_references,                desc = '[G]oto [R]eferences',     mode = 'n', silent = true },

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    { '<leader>cI', require('telescope.builtin').lsp_implementations,           desc = '[G]oto [I]mplementation', mode = 'n', silent = true },

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    { '<leader>ct', require('telescope.builtin').lsp_type_definitions,          desc = 'Type [D]efinition',       mode = 'n', silent = true },

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    { '<leader>cs', require('telescope.builtin').lsp_document_symbols,          desc = '[D]ocument [S]ymbols',    mode = 'n', silent = true },

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    { '<leader>cw', require('telescope.builtin').lsp_dynamic_workspace_symbols, desc = '[W]orkspace [S]ymbols',   mode = 'n', silent = true },

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    { '<leader>cr', vim.lsp.buf.rename,                                         desc = '[R]e[n]ame',              mode = 'n', silent = true },
    { '<leader>cf', vim.diagnostic.open_float,                                  desc = '[D]iagnostic float',      mode = 'n', silent = true },

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    { '<leader>ca', vim.lsp.buf.code_action,                                    desc = '[C]ode [A]ction',         mode = 'n', silent = true },

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    { '<leader>cD', vim.lsp.buf.declaration,                                    desc = '[G]oto [D]eclaration',    mode = 'n', silent = true },
}
