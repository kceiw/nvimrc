local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local default_cmp_sources = {
  { name = "copilot" },
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = "buffer" },
  { name = "ultisnips" },
  { name = "path" },
  { name = "treesitter" },
}

local bufIsBig = function(bufnr)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > max_filesize then
    return true
  else
    return false
  end
end

return {
  {
    "hrsh7th/nvim-cmp",
    --    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig",
      "zbirenbaum/copilot.lua",

      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind.nvim",

      "SirVer/ultisnips",
      {
        "quangnguyen30192/cmp-nvim-ultisnips",
        config = function()
          require("cmp_nvim_ultisnips").setup{}
        end
      },

      "windwp/nvim-autopairs",
      "ray-x/cmp-treesitter",
      "zbirenbaum/copilot-cmp",
    },
    init = function()
      -- If a file is too large, I don't want to add to it's cmp sources treesitter, see:
      -- https://github.com/hrsh7th/nvim-cmp/issues/1522
      vim.api.nvim_create_autocmd('BufReadPre', {
        callback = function(t)
          local sources = cmp.config.source(default_cmp_sources)
          if not bufIsBig(t.buf) then
            sources[#sources+1] = {name = 'treesitter', group_index = 2}
          end
          cmp.setup.buffer {
            sources = sources
          }
        end
      })
    end,
    config = function()
      local lspkind = require("lspkind")
      local cmp = require("cmp")
      local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources(default_cmp_sources),
        enabled = function()
          -- disable completion in comments
          local context = require "cmp.config.context"

          -- keep command mode completion enabled
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment")
            and not context.in_syntax_group("Comment")
          end
        end,
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              ultisnips = "[Snip]",
              path = "[Path]",
              nvim_lsp_signature_help = "[Signature]",
              copilot = "[Copilot]",
              treesitter = "[Treesitter]",
            })
          }),
        },
        mapping = {
          ["<Tab>"] = cmp.mapping({
            c = function()
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              else
                cmp.complete()
              end
            end,
            i = function(fallback)
              if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                  cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
              else
                fallback()
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                  cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
              else
                fallback()
              end
            end
          }),
          ["<S-Tab>"] = cmp.mapping({
            c = function()
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              else
                cmp.complete()
              end
            end,
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                cmp_ultisnips_mappings.jump_backwards(fallback)
              else
                fallback()
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                cmp_ultisnips_mappings.jump_backwards(fallback)
              else
                fallback()
              end
            end
          }),
          ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
          ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
          ['<C-n>'] = cmp.mapping({
            c = function()
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
              end
            end,
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end
          }),
          ['<C-p>'] = cmp.mapping({
            c = function()
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
              end
            end,
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end
          }),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
          ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
          ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
          })
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } },
        { { name = "cmdline" } })
      })

      -- If you want insert `(` after select function or method item
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
      )
    end,
  },
}
