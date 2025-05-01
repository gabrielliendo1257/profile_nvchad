return {
    { '<leader>Jo', "<Cmd> lua require('jdtls').organize_imports()<CR>",             desc = '[J]ava [O]rganize Imports', mode = 'n', silent = true },
    { '<leader>Jv', "<Cmd> lua require('jdtls').extract_variable()<CR>",             desc = '[J]ava Extract [V]ariable', mode = 'n', silent = true },
    { '<leader>Jv', "<Esc><Cmd> lua require('jdtls').extract_variable(true)<CR>",    desc = '[J]ava Extract [V]ariable', mode = 'v', silent = true },
    { '<leader>JC', "<Cmd> lua require('jdtls').extract_constant()<CR>",             desc = '[J]ava Extract [C]onstant', mode = 'n', silent = true },
    { '<leader>JC', "<Esc><Cmd> lua require('jdtls').extract_constant(true)<CR>",    desc = '[J]ava Extract [C]onstant', mode = 'v', silent = true },
    { '<leader>Jt', "<Cmd> lua require('jdtls').test_nearest_method()<CR>",          desc = '[J]ava [T]est Method',      mode = 'n', silent = true },
    { '<leader>Jt', "<Esc><Cmd> lua require('jdtls').test_nearest_method(true)<CR>", desc = '[J]ava [T]est Method',      mode = 'v', silent = true },
    { '<leader>JT', "<Cmd> lua require('jdtls').test_class()<CR>",                   desc = '[J]ava [T]est Class',       mode = 'n', silent = true },
    { '<leader>Ju', '<Cmd> JdtUpdateConfig<CR>',                                     desc = '[J]ava [U]pdate Config',    mode = 'n', silent = true },
}
