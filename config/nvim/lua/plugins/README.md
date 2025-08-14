# Neovim Plugins Documentation

This document provides comprehensive documentation for all plugins configured in this Neovim setup. Plugins are organized by category for easy navigation.

## Table of Contents

- [AI & Code Assistance](#ai--code-assistance)
- [User Interface & Theming](#user-interface--theming)
- [Editor Enhancements](#editor-enhancements)
- [Navigation & File Management](#navigation--file-management)
- [Development Tools](#development-tools)
- [Data & Collaboration](#data--collaboration)

---

## AI & Code Assistance

### Avante.nvim
**Repository:** `yetone/avante.nvim`  
**Purpose:** AI-powered code assistant and chat interface for Neovim

#### Features
- AI-powered code completion and suggestions
- Interactive chat interface for code discussions
- Support for multiple AI providers (OpenAI, Copilot, Ollama)
- Image pasting support for enhanced documentation
- Markdown rendering for better readability

#### Configuration
- **Default Provider:** Copilot
- **OpenAI Model:** gpt-4.1-nano (temperature: 0.75, max tokens: 20,480)
- **Ollama Model:** deepseek-coder:1.3b (local endpoint: http://localhost:11434)
- **Timeout:** 30 seconds for all providers

#### Dependencies
- `nvim-lua/plenary.nvim` - Core utility functions
- `MunifTanjim/nui.nvim` - UI components
- `zbirenbaum/copilot.lua` - Copilot integration
- `HakonHarnes/img-clip.nvim` - Image pasting support
- `MeanderingProgrammer/render-markdown.nvim` - Markdown rendering
- Multiple file selector providers (telescope, fzf, mini.pick)

#### Usage
- Lazy loaded on `VeryLazy` event
- Supports drag-and-drop for images
- Integrated with nvim-cmp for autocompletion

---

## User Interface & Theming

### Alpha-nvim
**Repository:** `goolord/alpha-nvim`  
**Purpose:** Customizable startup screen for Neovim

#### Features
- Beautiful ASCII art logo display
- Fast startup with lazy loading
- Customizable dashboard layout

#### Configuration
- **Loading:** Triggered on `VimEnter` event
- **Logo:** Custom Neovim ASCII art header
- **Status:** Enabled by default

#### Usage
- Automatically displays when starting Neovim without arguments
- Provides a welcoming interface with branding

### Colorscheme Configuration
**Repository:** `LazyVim/LazyVim`  
**Purpose:** Sets the default colorscheme for the editor

#### Configuration
- **Default Colorscheme:** `catppuccin-mocha`
- **Integration:** LazyVim configuration override

#### Features
- Consistent dark theme across the editor
- High contrast for better readability
- Modern color palette

### Neominimap
**Repository:** `Isrothy/neominimap.nvim`  
**Purpose:** Modern minimap implementation for code navigation

#### Features
- Real-time code minimap display
- Multiple control levels (global, window, tab, buffer)
- Focus management for enhanced navigation
- Auto-enable functionality

#### Configuration
- **Auto Enable:** True (automatically shows minimap)
- **Wrap:** Disabled for better layout
- **Side Scroll Offset:** 36 characters
- **Loading:** Not lazy loaded for immediate availability

#### Key Bindings (Available but commented out)
- Global controls: `<leader>nm` (toggle), `<leader>no` (enable), `<leader>nc` (disable)
- Window controls: `<leader>nwt` (toggle), `<leader>nwr` (refresh)
- Tab controls: `<leader>ntt` (toggle), `<leader>ntr` (refresh)
- Buffer controls: `<leader>nbt` (toggle), `<leader>nbr` (refresh)
- Focus controls: `<leader>nf` (focus), `<leader>nu` (unfocus), `<leader>ns` (toggle focus)

### Snacks.nvim
**Repository:** `folke/snacks.nvim`  
**Purpose:** Collection of useful utilities and UI enhancements

#### Features
- Enhanced file picker with hidden file support
- Modern UI components
- Utility functions for various operations

#### Configuration
- **Picker:** Configured to show hidden files in explorer
- **Integration:** Extends LazyVim functionality

---

## Editor Enhancements

### Vim Visual Multi
**Repository:** `mg979/vim-visual-multi`  
**Purpose:** Multiple cursor editing functionality

#### Features
- Multiple cursor selection and editing
- Visual block operations
- Advanced text manipulation

#### Configuration
- **Branch:** master (latest stable)
- **Loading:** Standard plugin loading

#### Usage
- Enables simultaneous editing of multiple text locations
- Supports complex multi-cursor operations

### Carbon Now
**Repository:** `ellisonleao/carbon-now.nvim`  
**Purpose:** Generate beautiful code screenshots using Carbon

#### Features
- Create styled code screenshots
- Direct integration with Carbon.sh service
- Visual selection support

#### Configuration
- **Loading:** Lazy loaded, activated by `:CarbonNow` command
- **Key Binding:** `<leader>cn` in visual mode

#### Usage
1. Select code in visual mode
2. Press `<leader>cn` or run `:CarbonNow`
3. Generates a beautiful code screenshot via Carbon.sh

---

## Navigation & File Management

### Pipeline.nvim
**Repository:** `topaxi/pipeline.nvim`  
**Purpose:** CI/CD pipeline integration and management

#### Features
- View and manage CI/CD pipelines directly in Neovim
- Pipeline status monitoring
- Build process integration

#### Configuration
- **Build:** Requires `make` for compilation
- **Key Binding:** `<leader>ci` to open pipeline interface

#### Usage
- Monitor build statuses
- Manage deployment pipelines
- Integrate with various CI/CD services

---

## Development Tools

### Live Share
**Repository:** `azratul/live-share.nvim`  
**Purpose:** Real-time collaborative editing

#### Features
- Real-time code collaboration
- Multiple service support (serveo.net, localhost.run)
- Automatic username detection

#### Configuration
- **Username:** Auto-detected from environment (`$USER` or `$USERNAME`)
- **Service:** serveo.net (default)
- **Max Attempts:** 40 connection attempts (250ms intervals)

#### Dependencies
- `jbyuki/instant.nvim` - Core instant collaboration functionality

#### Usage
- Share coding sessions with remote collaborators
- Real-time synchronization of edits
- Cross-platform collaboration support

---

## Data & Collaboration

### Data Viewer
**Repository:** `vidocqh/data-viewer.nvim`  
**Purpose:** View and analyze data files within Neovim

#### Features
- Support for various data formats
- In-editor data visualization
- Database connectivity

#### Dependencies
- `nvim-lua/plenary.nvim` - Core utilities
- `kkharji/sqlite.lua` - SQLite database support

#### Configuration
- **Options:** Default configuration with minimal setup
- **Loading:** Standard plugin loading

#### Usage
- View CSV, JSON, and other data formats
- Query and analyze database contents
- Integrated data manipulation tools

---

## Installation Notes

All plugins are managed through lazy.nvim and follow these general patterns:

### Loading Strategies
- **Lazy Loading:** Most plugins use event-based loading for optimal startup performance
- **Command Loading:** Some plugins load only when specific commands are executed
- **Key Binding Loading:** Certain plugins activate only when their key bindings are used

### Dependencies
- Many plugins share common dependencies like `plenary.nvim` for utility functions
- UI-related plugins often depend on `nui.nvim` for consistent interface components
- AI features require appropriate API keys and network connectivity

### Performance Considerations
- Plugins are configured for minimal startup impact
- Heavy features are lazy-loaded when needed
- Resource-intensive operations are optimized for background execution

---

## Troubleshooting

### Common Issues
1. **AI Provider Issues:** Ensure API keys are properly configured for OpenAI/Copilot
2. **Ollama Connection:** Verify Ollama is running on localhost:11434 for local AI features
3. **Build Dependencies:** Some plugins require external tools (make, etc.) for compilation
4. **Network Dependencies:** Live Share and Carbon Now require internet connectivity

### Plugin-Specific Notes
- **Avante:** Requires either Copilot or OpenAI API setup
- **Pipeline:** May need additional CI/CD service configuration
- **Live Share:** Firewall settings may affect connectivity
- **Data Viewer:** Large files may impact performance

---

## Contributing

When adding new plugins:
1. Follow the existing configuration patterns
2. Update this documentation with plugin details
3. Consider performance impact and loading strategies
4. Test compatibility with existing plugins
5. Document any new key bindings or commands

For questions or issues with specific plugins, refer to their respective GitHub repositories linked in each section.

