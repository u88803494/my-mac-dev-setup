#!/bin/bash

# Git Configuration Setup Script
# ================================

set -e  # Exit on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚙️  Git Configuration Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Select configuration type:"
echo "  1) Personal (Henry / u88803494@gmail.com)"
echo "  2) Work (custom email)"
echo "  3) Manual (configure manually)"
echo ""
read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "📝 Applying personal Git configuration..."
        cp "$SCRIPT_DIR/.gitconfig.personal" "$HOME/.gitconfig"
        echo "✅ Personal Git configuration applied"
        ;;
    2)
        echo ""
        read -p "Enter your work email: " work_email
        read -p "Enter your work name [Henry Lee]: " work_name
        work_name=${work_name:-Henry Lee}

        echo ""
        echo "📝 Applying work Git configuration..."
        cp "$SCRIPT_DIR/.gitconfig.work" "$HOME/.gitconfig"

        # Replace placeholder email
        sed -i.bak "s/WORK_EMAIL_HERE/$work_email/" "$HOME/.gitconfig"
        sed -i.bak "s/name = Henry Lee/name = $work_name/" "$HOME/.gitconfig"
        rm "$HOME/.gitconfig.bak"

        echo "✅ Work Git configuration applied"
        ;;
    3)
        echo ""
        echo "📝 Manual configuration mode"
        read -p "Enter your name: " git_name
        read -p "Enter your email: " git_email

        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        git config --global init.defaultBranch main
        git config --global core.editor vim

        echo "✅ Git configuration applied manually"
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "📋 Current Git configuration:"
echo "   Name:  $(git config --global user.name)"
echo "   Email: $(git config --global user.email)"
echo ""
echo "✅ Git setup complete!"
