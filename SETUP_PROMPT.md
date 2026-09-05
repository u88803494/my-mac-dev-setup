# Mac Development Environment Setup - AI Configuration Prompt

**Role**: You are an AI assistant helping to complete a macOS development environment setup.

**Context**: The bootstrap script has already installed:
- ✅ Homebrew (package manager)
- ✅ Claude Code (you!)
- ✅ mise (version manager for Node.js, Python, etc.)
- ✅ Node.js LTS (via mise)
- ✅ pnpm (via mise)
- ✅ git (for cloning repositories)

**Your Mission**: Complete the remaining setup tasks to create a fully configured development environment.

**⚠️ Read these first**:
- `MIGRATION_PLAN.md` — the full migration plan, including what deliberately should NOT be carried over from the old machine
- `Brewfile` — the curated package list for the new machine. Commented-out entries are intentional; do not uncomment without asking the user.

**Key rule**: use **mise** for version management. Do **not** install nvm — the old machine had both, and they conflict.

**If you have Serena MCP active and it surfaces project memory that contradicts
this file** (for example anything mentioning nvm, or describing `dev-tools.sh` /
`apps.sh`, which no longer exist) — **this file wins**. The memory may be stale;
do not act on it without cross-checking against the actual files in this repo.

**These operations always require the user's explicit go-ahead before you run
them — do not treat them as a routine step to execute and move on:**
- `chsh` (changes the default login shell)
- `ssh-keygen` / anything that touches `~/.ssh/` (may overwrite an existing key)
- `gh auth login` (changes GitHub CLI identity)
- Writing to `~/.zshrc.local` when it already has real content (never overwrite
  silently — see Task 4)
- `bash scripts/macos-defaults.sh` (changes Dock/Finder/keyboard/screenshot
  system settings)

---

## Setup Tasks

### 1. Shell Environment (Zsh + Oh My Zsh + Powerlevel10k)

```bash
bash scripts/zsh.sh
```

This installs Oh My Zsh, the Powerlevel10k theme, and the `zsh-autosuggestions` /
`zsh-syntax-highlighting` plugins (cloned into `$ZSH_CUSTOM/plugins/` — this
matches how the old machine actually had them, **not** via Homebrew formulae).

It also handles setting zsh as the default shell if needed. **The `chsh` step
requires the user's login password typed interactively** — if this script pauses
or the shell isn't already `/bin/zsh`, hand control back to the user rather than
trying to script around it.

This script does **not** touch `~/.zshrc` content — that's Task 4's job.

---

### 2. Apply the repo's mise version-manager config

```bash
bash scripts/node.sh
```

`bootstrap.sh` already ran `mise use -g node@lts` and `mise use -g pnpm@latest`,
which creates a bare `~/.config/mise/config.toml` containing only node and
pnpm — **no `uv`**. This script overwrites that file with the repo's
`config/mise/config.toml` (the single source of truth) and re-runs
`mise install`. **Do not skip this step** — if you do, `uv` never gets
installed and there is no error message to tell you that; it just silently
never shows up.

---

### 3. Development Tools & GUI Applications (Brewfile)

Everything — CLI tools, casks, and VS Code extensions — comes from one file:

```bash
brew bundle --file=Brewfile
brew bundle check --file=Brewfile --verbose
```

**Do not** install packages individually. If something is missing, add it to
`Brewfile` and re-run, so the repo stays the single source of truth. The second
command gives you a machine-readable pass/fail signal — use it instead of
scanning the install log by eye.

---

### 4. Restore dotfiles

```bash
bash scripts/restore-dotfiles.sh
```

This copies `config/shell/.zshrc`, `.zprofile`, `.gitconfig`, `.gitignore_global`
and `config/.p10k.zsh` into `$HOME`, backing up any existing file as
`*.pre-migration` (only on the first run — a second run won't clobber that
backup).

Use `config/shell/.zshrc` (the cleaned version), **not** `.zshrc.old-machine`
— the latter is kept only as a reference for what was removed. Do not hand-edit
`~/.zshrc` afterward (no manual `sed`/theme/plugin patching) — the restored file
already has everything wired up.

Then create the secrets file — **do this once, and never regenerate it**:

```bash
if [ -s ~/.zshrc.local ]; then
    echo "~/.zshrc.local already has content — leave it alone, do not overwrite"
else
    cp config/shell/.zshrc.local.example ~/.zshrc.local
    chmod 600 ~/.zshrc.local
    echo "Created ~/.zshrc.local — ask the user to fill in real values from their password manager"
fi
```

Values come from the user's password manager — **never generate, guess, or
leave placeholder values and treat the step as done.**

---

### 5. Custom scripts (zsh-scripts)

```bash
mkdir -p ~/Developer/Personal
if [ -d ~/Developer/Personal/zsh-scripts ]; then
    echo "✅ zsh-scripts already cloned"
else
    git clone git@github.com:u88803494/zsh-scripts.git ~/Developer/Personal/zsh-scripts
fi

bash scripts/symlink-zsh.sh
```

Use the script rather than hand-rolling the `ln -sf` calls — it creates **two**
symlinks (the whole repo, plus `custom.plugin.zsh` directly under
`$ZSH_CUSTOM/`), and only the second one is what Oh My Zsh actually auto-loads.
Missing it means the `c`/`cc`/`j`/`t()`/`uuid` aliases silently never load, with
no error to indicate why.

---

### 6. iTerm2 preferences sync

```bash
bash scripts/iterm2-config.sh
```

---

### 7. Verification

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
uv --version
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

1. **Ask for confirmation** before each of the operations listed under
   "these operations always require the user's explicit go-ahead" above.
2. **Show clear progress** for each step.
3. **Handle errors deliberately, not by guessing**:
   - A red `Error:` line is not automatically a real failure — e.g. a deprecated
     `brew tap` warning is noise if the actual install line after it still
     succeeds. Check the actual exit status / whether the expected file or
     binary now exists, not just whether anything printed in red.
   - If a command genuinely fails, stop, explain what went wrong, and ask
     whether to retry, skip, or investigate — don't silently continue past a
     failed step that later steps depend on.
4. **At the end**:
   - Provide a summary of what was installed
   - Remind the user to restart the terminal
   - Create a setup report: `~/setup-report.md`

---

## Important Notes

- **Do NOT** commit sensitive information to git
- **Never re-run** the `.zshrc.local` creation step if it already has content
- **Document errors** in setup-report.md for troubleshooting

---

## After Setup

**User should:**
1. Restart terminal (or run `source ~/.zshrc`)
2. Git identity (name/email/aliases) is **already set** — Task 4
   (`restore-dotfiles.sh`) restored `config/shell/.gitconfig`, which has the
   personal identity baked in. Only run this if you want to **switch** to a
   different identity (e.g. a work email for one context):
   ```bash
   bash git/setup-git.sh
   ```
   `config/shell/.gitconfig` and `git/.gitconfig.personal` are kept in sync —
   if you change one, update the other so they don't drift apart again.
3. Confirm `~/.zshrc.local` has real API key values (not placeholders)
4. Verify all tools work correctly

**Optional:**
- Install SuperClaude Framework: `pipx install SuperClaude && SuperClaude install`
- Configure VS Code extensions (already installed via Brewfile's `vscode` entries)
- Set up project-specific mise configurations

---

## Troubleshooting

**Common issues:**

- **Plugins not loading**: check `$ZSH_CUSTOM/zsh-scripts` and
  `$ZSH_CUSTOM/custom.plugin.zsh` both exist as symlinks (see Task 5) before
  assuming it's a `.zshrc` problem
- **Command not found**: check if the tool is in PATH — a fresh Homebrew
  install only persists to PATH via `~/.zprofile`; opening a new terminal tab
  is the simplest way to confirm it actually stuck
- **Permission denied**: check file permissions with `ls -la`
- **Git clone fails**: check network connection and GitHub access

**If anything fails:**
1. Check the actual error message and exit status, don't guess from the summary line
2. Document in setup-report.md
3. Suggest manual fixes
4. Offer the fallback: `./setup.sh` runs the same steps as plain shell scripts

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
