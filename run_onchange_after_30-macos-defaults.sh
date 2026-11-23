#!/bin/sh
set -eu

# Keyboard
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 48

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Screenshots (folder comes from Pictures/Screenshots/dot_keep)
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location "$HOME/Pictures/Screenshots"

# Spotlight: free Cmd+Space for Asyar (hotkey 64 = Show Spotlight search; Cmd+Opt+Space for the Finder search window stays on)
# XML form so the values get real types; the old-style '{ enabled = 0; }' syntax stores strings, which macOS ignores.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
  '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

killall Dock Finder SystemUIServer 2>/dev/null || true
