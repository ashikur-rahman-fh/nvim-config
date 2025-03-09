# configure mason for language server

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'clangd'},
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
  },

  -- Define the sources for completion
  sources = {
    { name = 'nvim_lsp' }, -- LSP-based completions
    { name = 'buffer' },   -- Buffer-based completions
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

