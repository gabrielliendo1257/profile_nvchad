local M = {}

M.general = {
    n = {
        ["<leader>w"] = { ":w<CR>", desc = "save the current file" },
        ["<leader>bc"] = { ":bdelete<CR>", desc = "close the current buffer" },
        -- ["<leader>m"] = { ":lua require('harpoon.mark').add_file()<CR>", desc = "mark the file" },
        -- ["<leader>h"] = { ":lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "harpoon" },
        ["<leader>e"] = { ":NvimTreeToggle<CR>", desc = "Toggle tree view" },
        ["<leader>q"] = { ":q<CR>, close vim" },
        ["<leader>ind"] = { "gg=G<C-o>", desc = "indent the whole file" },
    },
    v = {
    },
    i = {},
    t = {
        ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
    },
}

return M
