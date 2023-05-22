local opt = vim.opt

-- [[ Context ]]
opt.colorcolumn = "128"          -- str:  Show col for max line length
opt.number = true                -- bool: Show line numbers
opt.relativenumber = true        -- bool: Show relative line numbers
opt.scrolloff = 8               -- int:  Min num lines of context
opt.sidescrolloff = 8
opt.signcolumn = "yes"           -- str:  Show the sign column
-- wrap and the length of a line
opt.wrap = true
opt.linebreak = true
opt.textwidth = 126

-- [[ File ]]
opt.encoding = "utf8"            -- str:  String encoding to use
opt.fileencoding = "utf8"        -- str:  File encoding to use
opt.fileformats = "unix,dos"
opt.backup = false
opt.autoread = true  -- automatciall reread the file changed from the outside.
-- opt.directory = getenv("HOME") + "/tmp//"          -- Set the directory for the swap files. And extra / at the end uses absolute file path as the file name.

-- [[ Theme ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

-- [[ Search ]]
opt.ignorecase = true            -- bool: Ignore case in search patterns
opt.smartcase = true             -- bool: Override ignorecase if search contains capitals
opt.incsearch = true             -- bool: Use incremental search
opt.hlsearch = true              -- bool: Highlight search matches
opt.magic = true                 -- allow pattern matching with special characters

-- [[ Splits ]]
opt.splitright = true            -- bool: Place new window to right of current one
opt.splitbelow = true            -- bool: Place new window below the current one

-- opt.paste = true -- not to format the text when it's pasted

opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.backspace = "indent,eol,start"

opt.history = 50
opt.showcmd = true

opt.cursorline = true -- highlight the line where the cursor is
opt.cursorlineopt = "screenline"

opt.lazyredraw = true -- Not to always redraw, especially during macro.

opt.list = true -- show special characters
opt.listchars = "tab:<->,eol:¬"

opt.ruler = true -- show the cursor position
opt.rulerformat = "%{strftime(\"%a %m\")}"
opt.cmdheight = 2
opt.laststatus = 3
-- show file type and encoding in status line
-- %F file name
-- %m modification status
-- %r read only?
-- %y file type
-- %{&fileformat} file encoding
-- %b the ACSII on the cursor
-- %B the hex code on the cursor
-- %l cursor line
-- %c cursor colume
-- %V virtual row number
-- %p percentile
-- %% %
-- %L total line number
opt.statusline = "%t%m%r %y %l:%c(%p%%)/%L%< %{FugitiveStatusline()} %{&fileformat} %{&fileencoding}"

-- auto format
-- t: auto-wrap text using textwidth. (does not apply to comments)
-- c: auto-wrap comments using textwidth
-- q: allow formatting of comments with gq command. When using gq command in
-- comments, blank lines and lines only with comment leaders and white spaces
-- are considered as paragraph delimiters.
-- r: auto insert comment leader after hitting "Enter" in Insert mode.
-- o: auto insert comment leader after hitting "o" or "O"
-- a: auto format paragraphs when text is inserted or deleted
-- w: a trailing non white space ends a paragraph
-- n: numbered lists
opt.formatoptions = "tcrqnocw"

opt.foldmethod = "manual" -- folding set to "expr" for treesitter based folding
opt.foldexpr = "" -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
opt.foldcolumn = "1"
opt.foldlevelstart = 4
opt.foldnestmax = 5

opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0 -- so that `` is visible in markdown files

opt.hidden = true -- required to keep multiple buffers and open multiple buffers
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2 -- always show tabs

opt.title = true -- set the title of window to the value of the titlestring
opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to

local os_name = vim.loop.os_uname().sysname
if string.find(os_name, "Windows") then
  -- Set before apply toggleterm plugin
  local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    opt[option] = value
  end
end
