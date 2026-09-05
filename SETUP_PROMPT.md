# Mac Development Environment Setup - AI Configuration Prompt

**Role**: You are an AI assistant helping to complete a macOS development environment setup.

**Context**: The bootstrap script has already installed:
- ✅ Homebrew (package manager)
- ✅ mise (version manager for Node.js, Python, etc.)
- ✅ Node.js LTS (via mise)
- ✅ pnpm (via mise)
- ✅ git (for cloning repositories)
- ✅ Claude Code (you!)

**Your Mission**: Complete the remaining setup tasks to create a fully configured development environment.

**⚠️ Read these first**:
- `MIGRATION_PLAN.md` — the full migration plan, including what deliberately should NOT be carried over from the old machine
- `Brewfile` — the curated package list for the new machine. Commented-out entries are intentional; do not uncomment without asking the user.

**Key rule**: use **mise** for version management. Do **not** install nvm — the old machine had both, and they conflict.

---

## Setup Tasks

### 1. Shell Environment Setup

#### Install Zsh and Oh My Zsh

**Check and install Zsh:**
```bash
# Check if Zsh is installed
if command -v zsh &> /dev/null; then
    echo "✅ Zsh already installed"
else
    brew install zsh
fi
```

**Set Zsh as default shell:**
```bash
# Only if not already the default
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "✅ Zsh set as default shell (restart terminal to apply)"
fi
```

**Install Oh My Zsh:**
```bash
# Check if Oh My Zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh already installed"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
```

#### Install Powerlevel10k Theme

**Install MesloLGS Nerd Font:**
```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

**Clone Powerlevel10k theme:**
```bash
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    echo "✅ Powerlevel10k already installed"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
```

**Copy pre-configured p10k settings:**
```bash
if [ -f "$HOME/.p10k.zsh" ]; then
    echo "✅ .p10k.zsh configuration already exists"
else
    if [ -f "config/.p10k.zsh" ]; then
        cp config/.p10k.zsh "$HOME/.p10k.zsh"
        echo "✅ p10k configuration copied"
    fi
fi
```

#### Install Zsh Plugins

**Install via Oh My Zsh custom directory:**
```bash
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-completions
if [ -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo "✅ zsh-completions already installed"
else
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

# zsh-pnpm-completions
if [ -d "$ZSH_CUSTOM/plugins/zsh-pnpm-completions" ]; then
    echo "✅ zsh-pnpm-completions already installed"
else
    git clone https://github.com/g-plane/zsh-pnpm-shell-completion.git "$ZSH_CUSTOM/plugins/zsh-pnpm-completions"
fi
```

**Install via Homebrew:**
```bash
brew install zsh-autosuggestions zsh-syntax-highlighting
```

---

### 2. Development Tools & GUI Applications (Brewfile)

Everything — CLI tools, casks, and VS Code extensions — comes from one file:

```bash
brew bundle --file=Brewfile
```

**Do not** install packages individually. If something is missing, add it to `Brewfile`
and re-run, so the repo stays the single source of truth.

Key dependencies the shell config relies on (already in `Brewfile`):
- `eza`: `ls` replacement, required by the `t()` function
- `zoxide`: smart directory jumper, required by the `j` alias
- `gh`, `git-delta`: Git toolchain
- `font-meslo-lg-nerd-font`: required by Powerlevel10k

---

### 3. Restore dotfiles

```bash
bash scripts/restore-dotfiles.sh
```

This copies `config/shell/.zshrc`, `.zprofile`, `.gitconfig`, `.gitignore_global`
and `config/.p10k.zsh` into `$HOME`, backing up any existing file as `*.pre-migration`.

Use `config/shell/.zshrc` (the cleaned version), **not** `.zshrc.old-machine`
— the latter is kept only as a reference for what was removed.

Then create the secrets file (values come from the user's password manager — never
generate or guess them):

```bash
cp config/shell/.zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
```

**Configure iTerm2 preferences sync:**
```bash
# Set custom preferences folder
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/Developer/Personal/my-mac-dev-setup/config/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```

---

### 4. Custom Scripts (zsh-scripts)

**Clone and link zsh-scripts repository:**
```bash
# Create personal directory if it doesn't exist
mkdir -p ~/Developer/Personal

# Clone zsh-scripts
if [ -d ~/Developer/Personal/zsh-scripts ]; then
    echo "✅ zsh-scripts already cloned"
else
    git clone https://github.com/u88803494/zsh-scripts.git ~/Developer/Personal/zsh-scripts
fi

# Create symlink
ln -sf ~/Developer/Personal/zsh-scripts ~/.oh-my-zsh/custom/zsh-scripts

# Oh My Zsh will automatically load *.plugin.zsh files from custom directories
```

---

### 5. Configure .zshrc

**IMPORTANT**: Backup existing .zshrc before modifying:
```bash
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi
```

**Update ~/.zshrc with these configurations:**

1. **Set Powerlevel10k theme** (replace existing ZSH_THEME line):
   ```bash
   ZSH_THEME="powerlevel10k/powerlevel10k"
   ```

2. **Set plugins** (replace existing plugins line):
   ```bash
   plugins=(git zsh-completions zsh-pnpm-completions)
   ```

3. **Add Homebrew plugins** (BEFORE `source $ZSH/oh-my-zsh.sh`):
   ```bash
   # Homebrew-managed plugins
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
   source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
   ```

4. **Add mise activation** (AFTER `source $ZSH/oh-my-zsh.sh`):
   ```bash
   # mise (version manager)
   eval "$(mise activate zsh)"
   ```

5. **Add zoxide initialization**:
   ```bash
   # zoxide (smart cd)
   eval "$(zoxide init zsh)"
   alias j="z"
   ```

6. **Source local secrets file** (at the end):
   ```bash
   # Load local environment variables and secrets
   [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
   ```

---

### 6. Create .zshrc.local for Secrets

**Create ~/.zshrc.local** (this file should NOT be committed to git):

```bash
cat > ~/.zshrc.local << 'EOF'
# ============================================================================
# Local Environment Variables and Secrets
# ============================================================================
# This file is not tracked by git (.gitignore)
# Add your API keys, tokens, and machine-specific settings here

# Example: API Keys
# export TAVILY_API_KEY="your-key-here"
# export MORPH_API_KEY="your-key-here"
# export SUPABASE_ACCESS_TOKEN="your-token"
# export SUPABASE_PROJECT_REF="your-ref"

# Example: Project-specific paths
# export WORK_DIR="$HOME/work"
# export PERSONAL_DIR="$HOME/personal"

EOF

echo "✅ Created ~/.zshrc.local for secrets"
echo "📝 Edit this file to add your API keys: nano ~/.zshrc.local"
```

---

### 7. Verification

**Run these commands to verify everything is installed correctly:**

```bash
echo "🔍 Verifying installation..."
echo ""
echo "Version managers and package managers:"
mise --version
brew --version | head -n1
echo ""
echo "Languages and tools:"
node --version
pnpm --version
echo ""
echo "Development tools:"
git --version
gh --version
eza --version
zoxide --version
echo ""
echo "Shell:"
echo $SHELL
echo ""
echo "✅ Verification complete!"
```

---

## Execution Guidelines

**When executing this setup:**

1. **Ask for confirmation** before each major step (installing packages, modifying .zshrc)
2. **Backup existing files** before modifying (especially .zshrc)
3. **Show clear progress** for each step
4. **Handle errors gracefully**:
   - If a command fails, explain what went wrong
   - Suggest possible fixes
   - Ask if user wants to continue or skip
5. **At the end**:
   - Provide a summary of what was installed
   - Remind user to restart terminal
   - Create a setup report: `~/setup-report.md`

---

## Important Notes

- **Do NOT** commit sensitive information to git
- **Always backup** before modifying existing configurations
- **Test commands** before running destructive operations
- **Document errors** in setup-report.md for troubleshooting

---

## After Setup

**User should:**
1. Restart terminal (or run `source ~/.zshrc`)
2. Configure Git identity:
   ```bash
   git/setup-git.sh
   ```
3. Add API keys to `~/.zshrc.local`
4. Verify all tools work correctly

**Optional:**
- Install SuperClaude Framework: `pipx install SuperClaude && SuperClaude install`
- Configure VS Code extensions
- Set up project-specific mise configurations

---

## Troubleshooting

**Common issues:**

- **Plugins not loading**: Restart terminal or `source ~/.zshrc`
- **Command not found**: Check if tool is in PATH
- **Permission denied**: Check file permissions with `ls -la`
- **Git clone fails**: Check network connection and GitHub access

**If anything fails:**
1. Check the error message
2. Document in setup-report.md
3. Suggest manual fixes
4. Provide fallback options (use scripts/ directory)

---

## Final Steps

### Apply macOS system preferences

```bash
bash scripts/macos-defaults.sh
```

Review the script with the user first — it changes Dock, Finder, keyboard repeat
rate and screenshot location.

### Verification

Run the acceptance checklist in `MIGRATION_PLAN.md` §5 and report the result.
Do not claim the setup is complete until every item passes; report failures with
the actual command output.
