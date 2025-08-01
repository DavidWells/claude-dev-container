#!/bin/bash

# Extract GitHub owner and repo from git remote origin
if cd /workspace && git remote get-url origin >/dev/null 2>&1; then
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    if [[ $REMOTE_URL =~ github\.com ]]; then
        # Extract owner and repo from GitHub URL
        if [[ $REMOTE_URL =~ github\.com[/:]([^/]+)/([^/]+)(\.git)?$ ]]; then
            export GITHUB_OWNER="${BASH_REMATCH[1]}"
            export GITHUB_REPO="${BASH_REMATCH[2]}"
            
            # Remove .git suffix if present
            GITHUB_REPO="${GITHUB_REPO%.git}"
            
            # Remove any existing entries from shell profiles to avoid duplicates
            sed -i '/export GITHUB_OWNER=/d' /home/node/.bashrc
            sed -i '/export GITHUB_REPO=/d' /home/node/.bashrc
            sed -i '/export GITHUB_OWNER=/d' /home/node/.zshrc
            sed -i '/export GITHUB_REPO=/d' /home/node/.zshrc
            
            # Set in environment files for persistence
            echo "export GITHUB_OWNER=\"$GITHUB_OWNER\"" >> /home/node/.bashrc
            echo "export GITHUB_REPO=\"$GITHUB_REPO\"" >> /home/node/.bashrc
            echo "export GITHUB_OWNER=\"$GITHUB_OWNER\"" >> /home/node/.zshrc
            echo "export GITHUB_REPO=\"$GITHUB_REPO\"" >> /home/node/.zshrc
            
            echo "GitHub environment variables set:"
            echo "  GITHUB_OWNER=$GITHUB_OWNER"
            echo "  GITHUB_REPO=$GITHUB_REPO"
        else
            echo "Could not parse GitHub URL: $REMOTE_URL"
            export GITHUB_OWNER="unknown"
            export GITHUB_REPO="unknown"
        fi
    else
        echo "Remote URL is not a GitHub repository: $REMOTE_URL"
        export GITHUB_OWNER="unknown"
        export GITHUB_REPO="unknown"
    fi
else
    echo "No git remote found or /workspace is not a git repository"
    export GITHUB_OWNER="unknown"
    export GITHUB_REPO="unknown"
fi