#!/bin/bash

# Automatic Git Profile Setup
# This script runs during container startup to automatically configure git

PROFILES_DIR="/home/node/.git-profiles"
CURRENT_PROFILE_FILE="/home/node/.current-git-profile"
GIT_PROFILE_SCRIPT="/workspace/.devcontainer/scripts/git-profile"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to create a default profile from environment variables
create_profile_from_env() {
    local profile_name="${GIT_PROFILE_NAME:-default}"
    local user_name="${GIT_USER_NAME}"
    local user_email="${GIT_USER_EMAIL}"
    local github_user="${GIT_GITHUB_USER}"
    
    if [ -n "$user_name" ] && [ -n "$user_email" ]; then
        echo -e "${BLUE}Creating Git profile '$profile_name' from environment variables${NC}"
        
        mkdir -p "$PROFILES_DIR"
        local profile_file="$PROFILES_DIR/$profile_name"
        
        cat > "$profile_file" << EOF
# Git Profile: $profile_name (auto-created)
user.name=$user_name
user.email=$user_email
EOF
        
        if [ -n "$github_user" ]; then
            echo "github.user=$github_user" >> "$profile_file"
        fi
        
        echo -e "${GREEN}Profile '$profile_name' created and activated${NC}"
        
        # Apply the profile
        git config --global user.name "$user_name"
        git config --global user.email "$user_email"
        if [ -n "$github_user" ]; then
            git config --global github.user "$github_user"
        fi
        
        # Save as current profile
        echo "$profile_name" > "$CURRENT_PROFILE_FILE"
        
        return 0
    fi
    
    return 1
}

# Function to auto-apply a default profile if it exists
apply_default_profile() {
    local default_profile="${GIT_DEFAULT_PROFILE:-default}"
    local profile_file="$PROFILES_DIR/$default_profile"
    
    if [ -f "$profile_file" ]; then
        echo -e "${BLUE}Applying default Git profile: $default_profile${NC}"
        
        # Use the git-profile script to apply it
        if [ -x "$GIT_PROFILE_SCRIPT" ]; then
            "$GIT_PROFILE_SCRIPT" use "$default_profile"
        fi
        
        return 0
    fi
    
    return 1
}

# Function to check if git is already configured
git_is_configured() {
    local user_name=$(git config --global user.name 2>/dev/null)
    local user_email=$(git config --global user.email 2>/dev/null)
    
    [ -n "$user_name" ] && [ -n "$user_email" ]
}

# Main setup logic
echo -e "${BLUE}Setting up Git configuration...${NC}"

# Ensure safe directory is set
git config --global --add safe.directory /workspace

# Copy host gitconfig if available (existing behavior)
if [ -f /home/node/.gitconfig-host ]; then
    cp /home/node/.gitconfig-host /home/node/.gitconfig
    echo -e "${GREEN}Copied Git configuration from host${NC}"
elif create_profile_from_env; then
    # Created profile from environment variables
    :
elif apply_default_profile; then
    # Applied existing default profile
    :
elif git_is_configured; then
    echo -e "${GREEN}Git is already configured${NC}"
else
    echo -e "${YELLOW}No Git configuration found.${NC}"
    echo -e "${YELLOW}To set up your Git identity:${NC}"
    echo -e "${YELLOW}  1. Run: git-profile create <name>${NC}"
    echo -e "${YELLOW}  2. Or set environment variables: GIT_USER_NAME, GIT_USER_EMAIL${NC}"
fi

# Make git-profile script executable and available in PATH
if [ -f "$GIT_PROFILE_SCRIPT" ]; then
    chmod +x "$GIT_PROFILE_SCRIPT"
    
    # Add to PATH if not already there
    if ! echo "$PATH" | grep -q "/workspace/.devcontainer/scripts"; then
        echo 'export PATH="/workspace/.devcontainer/scripts:$PATH"' >> /home/node/.bashrc
        echo 'export PATH="/workspace/.devcontainer/scripts:$PATH"' >> /home/node/.zshrc 2>/dev/null || true
    fi
fi

echo -e "${GREEN}Git setup complete${NC}"