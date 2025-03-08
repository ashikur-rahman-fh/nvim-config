require("catppuccin").setup({
    flavour = "latte", -- latte, frappe, macchiato, mocha
    show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    term_colors = false,
    no_italic = true, -- Force no italic
    no_bold = true, -- Force no bold
    no_underline = true, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = {}, -- Change the style of comments
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})


function ColorMyPencils(color)
  color = color or "catppuccin"
  vim.cmd.colorscheme(color)
end

ColorMyPencils()
