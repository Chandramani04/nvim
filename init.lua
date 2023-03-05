 --[[
 
  =====================================================================
  ==================== READ THIS BEFORE CONTINUING ====================
  =====================================================================
 
  Kickstart.nvim is *not* a distribution.
 
  Kickstart.nvim is a template for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, and understand
    what your configuration is doing.
 
    Once you've done that, you should start exploring, configuring and tinkering to
    explore Neovim!
 
    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example:
    - https://learnxinyminutes.com/docs/lua/
 
    And then you can explore or search through `:help lua-guide`
 
 
  Kickstart Guide:
 
  I have left several `:help X` comments throughout the init.lua
  You should run that command and read that help section for more information.
 
  In addition, I have some `NOTE:` items throughout the file.
  These are for you, the reader to help understand what is happening. Feel free to delete
  them once you know what you're doing, but they should serve as a guide for when you
  are first encountering a few different constructs in your nvim config.
 
  I hope you enjoy your Neovim journey,
  - TJ
 
  P.S. You can delete this when you're done too. It's your config now :)
  --]]
 
  --my custum c++ setup
 
 
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
 
 
  -- Install package manager
  --    https://github.com/folke/lazy.nvim
  --    `:help lazy.nvim.txt` for more info
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
 
  -- NOTE: Here is where you install your plugins.
  --  You can configure plugins using the `config` key.
  --
  --  You can also configure plugins after the setup call,
  --    as they will be available in your neovim runtime.
  require('lazy').setup({
    -- NOTE: First, some plugins that don't require any configuration
 
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'catppuccin/nvim',
    'octol/vim-cpp-enhanced-highlight',
    'maxboisvert/vim-simple-complete',
    --ultisnip
    'xiyaowong/nvim-transparent',
 
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
 
    --gruvebox colorscheme
    'folke/tokyonight.nvim',

    'gruvbox-community/gruvbox',
    'luisiacc/gruvbox-baby',
    --minisnip 
    'Jorengarenar/miniSnip',
 
 
    -- cp test runner
    'nvim-lua/plenary.nvim',
    'p00f/cphelper.nvim',
 
    'MunifTanjim/nui.nvim' ,
    {
      'xeluxee/competitest.nvim',
      requires = 'MunifTanjim/nui.nvim',
      config = function() require'competitest'.setup() end
    },
 
    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    { -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
 
        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', opts = {} },
 
        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
      },
    },
   --  --
   -- {'ycm-core/YouCompleteMe', run = function() vim.fn['python3'](vim.fn.getcwd()..'/install.py --clangd-completer', '--all') end },
    { -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    },
    {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
    },
 
    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim', opts = {} },
    { -- Adds git releated signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        -- See `:help gitsigns.txt`
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },
 
    { -- Theme inspired by Atom
      'navarasu/onedark.nvim',
      priority = 1000,
      config = function()
        vim.cmd.colorscheme 'onedark'
      end,
    },
 
    { -- Set lualine as statusline
      'nvim-lualine/lualine.nvim',
      -- See `:help lualine.txt`
      opts = {
        options = {
          icons_enabled = true,
          theme = 'onedark',
          component_separators = '|',
          section_separators = '',
        },
      },
    },
 
    { -- Add indentation guides even on blank lines
      'lukas-reineke/indent-blankline.nvim',
      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help indent_blankline.txt`
      opts = {
        char = '┊',
        show_trailing_blankline_indent = false,
      },
    },
 
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },
 
    -- Fuzzy Finder (files, lsp, etc)
    { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
 
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
 
    { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      config = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
      end,
    },
 
    -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
    --       These are some example plugins that I've included in the kickstart repository.
    --       Uncomment any of the lines below to enable them.
    -- require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',
 
    -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    --
    --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
    --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
   -- { import = 'custom.plugins' },
  }, {})
 
  -- [[ Setting options ]]
  -- See `:help vim.o`
 
  -- Set highlight on search
  vim.o.hlsearch = false
 
  -- Make line numbers default
  vim.wo.number = true
 
  -- Enable mouse mode
  vim.o.mouse = 'a'
 
  -- Sync clipboard between OS and Neovim.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.o.clipboard = 'unnamedplus'
 
  -- Enable break indent
  vim.o.breakindent = true
 
  -- Save undo history
  vim.o.undofile = true
 
  -- Case insensitive searching UNLESS /C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true
 
  -- Keep signcolumn on by default
  vim.wo.signcolumn = 'yes'
 
  -- Decrease update time
  vim.o.updatetime = 250
  vim.o.timeout = true
  vim.o.timeoutlen = 300
 
  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'
 
  -- NOTE: You should make sure your terminal supports this
  vim.o.termguicolors = true
 
  -- [[ Basic Keymaps ]]
 
 
  -- Map ff to Escape
  vim.api.nvim_set_keymap('i', 'ff', '<Esc>', { noremap = true })
 
  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
 
  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
 
  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })
 
  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }
 
  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')
 
  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })
 
  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
 
  -- [[ Configure Treesitter ]]
  -- See `:help nvim-treesitter`
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'help', 'vim' },
 
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
 
    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
 
  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
 
  -- LSP settings.
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end
 
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
 
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
 
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
 
    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
 
    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
 
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end
 
  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  local servers = {
    clangd = {},
   --  gopls = {},
     pyright = {},
     rust_analyzer = {},
     tsserver = {},
 
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }
 
  -- Setup neovim lua configuration
  require('neodev').setup()
 
  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
 
  -- Setup mason so it can manage external tooling
  require('mason').setup()
 
  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'
 
  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }
 
  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }
 
  -- nvim-cmp setup
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
 
  luasnip.config.setup {}
 
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete {},
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }
 
 
  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
 
 
  -- enable syntax highlighting
  vim.cmd('syntax on')
 
  -- set color scheme
  vim.cmd('colorscheme onedark')
 
  -- show relative line numbers
  vim.opt.relativenumber = true
 
  -- set dark background
  vim.opt.background = 'dark'
 
  -- use system clipboard
  vim.opt.clipboard = 'unnamed'
 
  -- show ruler
  vim.opt.ruler = true
 
  -- enable Omni completion
  vim.opt.omnifunc = 'syntaxcomplete#Complete'
 
  -- show status line always
  vim.opt.laststatus = 2
 
  -- -- set backspace to allow deletion over indent, eol and start
  -- vim.opt.backspace = 'indent,eol,start'
  --
  -- enable auto indentation
  vim.opt.autoindent = true
 
  -- enable smart indentation
  vim.opt.smartindent = false
 
  -- toggle paste mode with F2
  vim.opt.pastetoggle = '<F2>'
 
  -- enable graphical auto-complete menu
  vim.opt.wildmenu = true
 
  -- highlight matching brackets
  vim.opt.showmatch = true
 
  -- enable search highlighting
  vim.opt.hlsearch = true
 
  --set tab and indentation width to 2 spaces
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
 
  -- enable mouse support
  vim.opt.mouse = 'a'
 
  -- enable line wrapping
  vim.opt.wrap = true
 
  -- copy whole file to system clipboard with F3
  vim.api.nvim_set_keymap('n', '<F3>', ':silent! %y+<CR>', { noremap = true, silent = true })
 
  -- vim.opt.backspace = 2
  vim.opt.laststatus = 2
  vim.opt.shiftwidth = 2
 
  -- auto-insert template for new C++ files
  -- vim.api.nvim_exec([[
  --   augroup templates
  --     autocmd!
  --     autocmd BufNewFile *.cpp 0r ~/vimfiles/templates/skeleton.cpp
  --   augroup END
  -- ]], true)
  --
  -- compile and run C++ file with F5
  vim.api.nvim_set_keymap('n', '<F5>', ':w<CR>:!g++ % -o %<.out && ./%<.out<CR>', { noremap = true })
 
 
  require('lspconfig').clangd.setup({
    handlers = {
      ["textDocument/publishDiagnostics"] = function() end
    }
  })
  -- Key mapping to compile and run C++ code in the sidebar
  -- vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:make run<CR>:SidebarOpen term://./' .. vim.fn.expand('%:r') .. ';exit<CR>', { noremap = true })
 
 
  -- vim.api.nvim_set_keymap('n', '<leader>t', ':CompetiTestRun<CR>', {noremap = true, silent = true})
 
  vim.api.nvim_set_keymap('n', '<S-j>', ':CompetiTestRun<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<S-e>', ':CompetiTestEdit<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<S-f>', ':CompetiTestReceive testcases<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<S-k>', ':CompetiTestAdd<CR>', {noremap = true, silent = true})
   


vim.api.nvim_set_keymap('n', '<leader>s', ':wq<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>k', ':q<CR>', {noremap = true, silent = true})
 
 
 
  require('cmp').setup({
    completion = {
      keyword_length = 3,
    },
  })
 
  require('competitest').setup() -- to use default configuration
 
vim.o.shell = 'powershell.exe'

vim.cmd([[
  augroup CppTemplates
    autocmd!
    autocmd BufNewFile *.cpp 0r ~/vimfiles/templates/skeleton.cpp
  augroup END
]])

--vim.g.python3_host_prog = 'C:\Users\Chand\AppData\Local\Programs\Python\Python311' -- Or your path to python3


vim.g.ycm_global_ycm_extra_conf = '~/AppData/Local/nvim-data/lazy/YouCompleteMe/ycm_extra_conf.py'
--vim.g.ycm_global_ycm_extra_conf = 'C:\Users\Chand\AppData\Local\nvim-data\lazy\YouCompleteMe\ycm_extra_conf.py'
vim.g.ycm_confirm_extra_conf = 0
vim.g.ycm_autoclose_preview_window_after_completion = 1









