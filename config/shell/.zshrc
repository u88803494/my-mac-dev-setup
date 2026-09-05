# ~/.zshrc — 新機乾淨版
#
# 相對於舊機（見 .zshrc.old-machine）移除了：
#   - export PATH="/usr/local/bin:$PATH"        Intel 路徑，Apple Silicon 用不到
#   - kiro / windsurf / codeium / antigravity   已淘汰工具的 PATH
#   - pipx PATH                                 已在 .zprofile 設定，重複
#   - cd ~/Developer/Personal/my-website        每開 terminal 自動跳，改用 website alias

# 非互動式 shell 直接返回
[ -z "$PS1" ] && return

# Powerlevel10k instant prompt（需要 console input 的初始化要放在這之上）
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─────────────────────────────────────────────
# Oh My Zsh
# ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  node
  npm
  pnpm
  zsh-autosuggestions
  zsh-syntax-highlighting
)
# yarn      # 專案已全面改用 pnpm，需要時再解開

source $ZSH/oh-my-zsh.sh

# Powerlevel10k 設定
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ─────────────────────────────────────────────
# 工具初始化
# ─────────────────────────────────────────────
eval "$(mise activate zsh)"      # 版本管理（Node / Python / …）
eval "$(zoxide init zsh)"        # 智慧 cd

# ─────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────
alias j="z"
alias dev="cd ~/Developer"
alias work="cd ~/Developer/Work"
alias pers="cd ~/Developer/Personal"
alias website="cd ~/Developer/Personal/my-website"
alias lsa="eza -la"
alias cls="clear"

# ─────────────────────────────────────────────
# 自訂腳本與秘密
# ─────────────────────────────────────────────
[[ -f ~/.oh-my-zsh/custom/plugins/zsh-scripts/custom.plugin.zsh ]] \
  && source ~/.oh-my-zsh/custom/plugins/zsh-scripts/custom.plugin.zsh

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
