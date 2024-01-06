return {
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    --    lazy = true,
    --    event = {
    --      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --      "BufReadPre " .. vim.fn.expand "~" .. "/Notes/**.md",
    --      "BufNewFile" .. vim.fn.expand "~" .. "/Notes/**.md",
    --    },
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
        template = "Journa/template/daily.md"
      },

      -- Optional, completion.
      completion = {
        nvim_cmp = true,  -- if using nvim-cmp, otherwise set to false
        -- Trigger completion at 2 chars.
        min_chars = 2,

        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

      },

      -- Optional, customize how names/IDs for new notes are created.
      note_id_func = function(title)
        local file_name= ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          file_name = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the file name.
          for _ = 1, 4 do
            file_name = file_name .. string.char(math.random(65, 90))
          end
        end
        return file_name
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

      -- Optional, customize the backlinks interface.
      backlinks = {
        -- The default height of the backlinks pane.
        height = 10,
        -- Whether or not to wrap lines.
        wrap = true,
      },
    },
  }
}

