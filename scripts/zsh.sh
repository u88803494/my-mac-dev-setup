#!/bin/bash

# Zsh + Oh My Zsh + Powerlevel10k Installation Script
# ======================================================

set -e  # Exit on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐚 Installing Zsh + Oh My Zsh + Powerlevel10k"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if Zsh is installed
if command -v zsh &> /dev/null; then
    echo "✅ Zsh already installed"
    zsh --version
else
    echo "📥 Installing Zsh..."
    brew install zsh
    echo "✅ Zsh installed successfully"
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🔧 Setting Zsh as default shell..."
    chsh -s $(which zsh)
    echo "✅ Zsh set as default shell (restart terminal to apply)"
else
    echo "✅ Zsh is already the default shell"
fi

echo ""

# Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh already installed"
else
    echo "📥 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed successfully"
fi

echo ""

# Install MesloLGS Nerd Font (Powerlevel10k recommended font)
echo "📥 Installing MesloLGS Nerd Font..."
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font 2>/dev/null || echo "✅ MesloLGS Nerd Font already installed"

echo ""

# Install Powerlevel10k
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    echo "✅ Powerlevel10k already installed"
else
    echo "📥 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    echo "✅ Powerlevel10k installed successfully"
fi

echo ""

# Install OMZ plugins
echo "📥 Installing Oh My Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-completions
if [ -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo "✅ zsh-completions already installed"
else
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
    echo "✅ zsh-completions installed"
fi

# Install zsh-pnpm-completions
if [ -d "$ZSH_CUSTOM/plugins/zsh-pnpm-completions" ]; then
    echo "✅ zsh-pnpm-completions already installed"
else
    git clone https://github.com/g-plane/zsh-pnpm-shell-completion.git "$ZSH_CUSTOM/plugins/zsh-pnpm-completions"
    echo "✅ zsh-pnpm-completions installed"
fi

echo ""

# Install Zsh plugins via Homebrew
echo "📥 Installing Zsh plugins via Homebrew..."
brew install zsh-autosuggestions zsh-syntax-highlighting 2>/dev/null || echo "✅ Homebrew Zsh plugins already installed"

echo ""

# Copy p10k configuration if exists
if [ -f "$HOME/.p10k.zsh" ]; then
    echo "✅ .p10k.zsh configuration already exists"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    if [ -f "$SCRIPT_DIR/config/.p10k.zsh" ]; then
        echo "📋 Copying p10k configuration..."
        cp "$SCRIPT_DIR/config/.p10k.zsh" "$HOME/.p10k.zsh"
        echo "✅ p10k configuration copied"
    else
        echo "⚠️  p10k configuration not found in repo. Run 'p10k configure' manually later."
    fi
fi

echo ""

# Update .zshrc to use Powerlevel10k theme
if grep -q "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" ~/.zshrc 2>/dev/null; then
    echo "✅ .zshrc already configured for Powerlevel10k"
else
    echo "🔧 Updating .zshrc theme to Powerlevel10k..."
    sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    echo "✅ .zshrc updated"
fi

echo ""

# Update plugins in .zshrc
if grep -q "plugins=(git zsh-completions zsh-pnpm-completions)" ~/.zshrc 2>/dev/null; then
    echo "✅ .zshrc plugins already configured"
else
    echo "🔧 Updating .zshrc plugins..."
    sed -i.bak 's/^plugins=.*/plugins=(git zsh-completions zsh-pnpm-completions)/' ~/.zshrc
    echo "✅ .zshrc plugins updated"
fi

echo ""

# Add Homebrew plugin sources to .zshrc (before sourcing oh-my-zsh.sh)
if grep -q "zsh-autosuggestions.zsh" ~/.zshrc 2>/dev/null; then
    echo "✅ Homebrew plugins already sourced in .zshrc"
else
    echo "🔧 Adding Homebrew plugin sources to .zshrc..."

    # Find the line number where oh-my-zsh.sh is sourced
    if grep -n "source.*oh-my-zsh.sh" ~/.zshrc &> /dev/null; then
        # Insert before oh-my-zsh.sh source line
        sed -i.bak '/source.*oh-my-zsh.sh/i\
# Homebrew-managed plugins\
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh\
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\
' ~/.zshrc
    else
        # Append to end if oh-my-zsh.sh source not found
        echo "" >> ~/.zshrc
        echo "# Homebrew-managed plugins" >> ~/.zshrc
        echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
        echo 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc
    fi

    echo "✅ Homebrew plugin sources added"
fi

echo ""
echo "✅ Zsh setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. All plugins and configurations are ready to use"
