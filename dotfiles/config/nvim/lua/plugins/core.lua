return {
  -- Configure LazyVim to use tokyonight colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  
  -- Add GitHub Copilot (optional - comment out if not needed)
  -- { import = "lazyvim.plugins.extras.coding.copilot" },
}