local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Search filenames in the worksplace' })
vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Search files by text in the workspace' })
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Search neovim buffers' })
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = 'Search git files' })
