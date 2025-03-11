# configure mason for language server

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'clangd', 'pyright', 'gopls', 'bashls' },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  }
})

local lspconfig = require('lspconfig')

lspconfig.clangd.setup({
  -- Specify file types for which clangd should be attached
  filetypes = { 'c', 'cpp', 'h', 'hh', 'cc' },

  -- Disable formatting capabilities
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentFormattingRangeProvider = false
  end,
})

-- disable errors/warnings
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

-- === COMPLITION ===

local cmp = require('cmp')

cmp.setup({
  -- Enable completion on 2 characters
  completion = {
    keyword_length = 2,
    debounce = 150,
  },

  -- Define the sources for completion
  sources = {
    { name = 'buffer', priority = 10 }, -- Buffer-based completions
    { name = 'path', priority = 7 }, -- Path completions
    { name = 'nvim_lsp', priority = 6 }, -- LSP-based completions
    { name = 'luasnip', priority = 5 }, -- Lua snip completions
  },

  -- Mapping configuration
  mapping = {
    -- Use Tab to select the top option
     -- Use Tab to select and confirm the current suggestion
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true }) -- Select and confirm the current suggestion
      else
        fallback() -- Fallback to default behavior if completion is not visible
      end
    end, { 'i', 's' }), -- Apply to insert and select modes

    -- Use Ctrl+n for next item
    ['<C-n>'] = cmp.mapping.select_next_item(),

    -- Use Ctrl+p for previous item
    ['<C-p>'] = cmp.mapping.select_prev_item(),

    -- Don't insert the top selection when pressing Enter
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false, -- Don't automatically select the first item
    }),

    -- Disable default behavior of inserting the top selection on Enter
    ['<C-y>'] = cmp.config.disable, -- Disable default confirm behavior

    -- Use Ctrl+Space to force-show completion options
    ['<C-Space>'] = cmp.mapping.complete(),
  },

  -- Additional configuration for the completion window
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- Enable command-line completions
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'cmdline' },
  }),
})

----------------------------------------------------
--- Language specific on attach of lspconfig
----------------------------------------------------

local common_on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Keybindings
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- Pyright (Python)
local pyright_on_attach = function(client, bufnr)
  common_on_attach(client, bufnr) -- Include common functionality

  -- Python-specific keybindings or behavior
  vim.keymap.set('n', '<leader>pi', '<cmd>PyrightOrganizeImports<CR>', { buffer = bufnr })
end

-- Gopls (Go)
local gopls_on_attach = function(client, bufnr)
  common_on_attach(client, bufnr) -- Include common functionality

  -- Go-specific keybindings or behavior
  vim.keymap.set('n', '<leader>gi', '<cmd>GoImport<CR>', { buffer = bufnr })
  vim.keymap.set('n', '<leader>gt', '<cmd>GoTest<CR>', { buffer = bufnr })
end

-- Bashls (Bash)
local bashls_on_attach = function(client, bufnr)
  common_on_attach(client, bufnr) -- Include common functionality

  -- Bash-specific keybindings or behavior
  vim.keymap.set('n', '<leader>bs', '<cmd>ShellCheck<CR>', { buffer = bufnr })
end


------------------------------------------
--- Language specific lspconfig settings
------------------------------------------

-- Pyright (Python)
lspconfig.pyright.setup({
  on_attach = pyright_on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
})

-- Gopls (Go)
lspconfig.gopls.setup({
  on_attach = gopls_on_attach,
  settings = {
    gopls = {
      buildFlags = { '-buildvcs=false' }, -- Prevent VCS metadata files
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})

-- Bashls (Bash)
lspconfig.bashls.setup({
  on_attach = bashls_on_attach,
  filetypes = { 'sh', 'bash' },
})


-------------------------------------------
--- Language specific editor settings     
-------------------------------------------

-- Python
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Set environment variable to prevent Python from writing bytecode
vim.env.PYTHONDONTWRITEBYTECODE = '1'

-- Go
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Bash
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

