# Dotfiles Repository

This repository contains my personal configuration files for Vim, Neovim, Tmux, and a collection of shell scripts to simplify the installation of dependencies and setup process for a productive development environment.

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Configuration](#configuration)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Maintaining a consistent and efficient development environment across multiple machines can be a challenge. This repository is designed to streamline the setup process by providing a collection of configuration files and scripts to help you get up and running quickly with Vim, Neovim, and Tmux.

### Included Configurations and Tools

- **Vim and Neovim Configuration**: Customized settings, keybindings, and plugins to enhance your text editing experience.
- **Tmux Configuration**: A productive terminal multiplexer configuration with useful shortcuts.
- **Shell Scripts**: Handy scripts to automate the installation of essential dependencies and the setup of your development environment.

## Getting Started

Follow these steps to set up your development environment using the configuration files and scripts provided in this repository.

### Prerequisites

Before you begin, ensure you have the following prerequisites installed on your system:

- [Vim](https://www.vim.org/) or [Neovim](https://neovim.io/)
- [Tmux](https://github.com/tmux/tmux)
- [Git](https://git-scm.com/)
- [curl](https://curl.se/)

### Installation

1. Clone this repository to your home directory:

```bash
    git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
```

2. change to the repository directory:
```bash
    cd ~/.dotfiles
```

3. Run the setup script to install the configuration files and dependencies:

```bash
    ./install.sh
```
4. Follow the prompts and instructions provided by the installation script.

5. Restart your terminal or run tmux to start using your newly configured environment.

### Configuration
- Vim/Neovim Configuration: The Vim and Neovim configuration files (vimrc and nvimrc) are extensively commented to help you understand and modify the settings according to your preferences.
to start using it just run any of this commands:
```bash
    ln -s ~/dotfiles/vim/vimrc ~/.vimrc
```

```bash
    ln -s ~/dotfiles/nvim/ ~/.config/
```

Tmux Configuration: The Tmux configuration (tmux.conf) is similarly commented to make customization straightforward.

### Customization
- Feel free to customize the configuration files to suit your needs. You can add or remove plugins, change keybindings, or tweak settings according to your preferences.

### Contributing
- Contributions are welcome! If you have any improvements, bug fixes, or new features to propose, please open an issue or submit a pull request.

### License
- This repository is licensed under the MIT License. See the LICENSE file for details.
