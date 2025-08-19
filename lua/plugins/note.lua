return {
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = "~/Notes"
        },
      },

      -- Optional, if you keep daily notes in a separate directory.
      daily_notes = {
        folder = "Journal",
        date_format = "%Y/%m/%Y-%m-%d",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil
      },

      -- Optional, completion.
      completion = {
        nvim_cmp = true,  -- if using nvim-cmp, otherwise set to false
        -- Trigger completion at 2 chars.
        min_chars = 2,

      },

      -- Where to put new notes created from completion. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "current_dir",

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- Optional, set to true if you don't want Obsidian to manage frontmatter.
      disable_frontmatter = true,

      -- Optional, for templates (see below).
      templates = {
        subdir = "template",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({"open", url})  -- Mac OS
        vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = true,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,

      -- Optional, customize how wiki links are formatted. You can set this to one of:
      --  * "use_alias_only", e.g. '[[Foo Bar]]'
      --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
      --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      --  * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_alias_only(opts)
      end,

      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        local util = require "obsidian.util"
        local client = require("obsidian").get_client()
        local anchor = ""
        local header = ""

        if opts.anchor then
          anchor = opts.anchor.anchor
          header = util.format_anchor_label(opts.anchor)
        elseif opts.block then
          anchor = "#" .. opts.block.id
          header = "#" .. opts.block.id
        end

        -- This is now an absolute path to the file.
        local path = client.dir / opts.path
        -- This is an absolute path to the current buffer's parent directory.
        local buf_dir = client.buf_dir

        -- https://github.com/epwalsh/obsidian.nvim/issues/732
        local rel_path
        if buf_dir:is_parent_of(path) then
          rel_path = tostring(path:relative_to(buf_dir))
        else
          local parents = buf_dir:parents()
          for i, parent in ipairs(parents) do
            if parent:is_parent_of(path) then
              rel_path = string.rep("../", i) .. tostring(path:relative_to(parent))
              break
            end
          end
        end

        -- The default one encode the path which doesn't show Chinese.
        return string.format("[%s%s](%s%s)", opts.label, header, rel_path, anchor)
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({"open", url})  -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      follow_img_func = function(img)
        -- vim.fn.jobstart { "qlmanage", "-p", img }  -- Mac OS quick look preview
        vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "markdown",

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "fzf-lua",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,
    },
  },
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/Notes/**/*",
        org_default_notes_file = "~/Notes/index.org",
        org_todo_keywords = {"TODO(t)", "NEXT(n)", "PROGRESS(p)", "WAITING(w)", "|", "DONE(d)", "HOLD(h)", "CUT(c)", "DELEGATED(d)"}
      })
    end,
  },
}
