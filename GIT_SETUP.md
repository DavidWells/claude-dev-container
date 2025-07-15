# Git Configuration in Dev Container

This dev container is now configured to automatically handle Git credentials and support multiple Git profiles.

## How It Works

### Automatic Git Configuration

1. **Host Credentials**: The container automatically mounts your host's `.gitconfig` file and uses it if available
2. **Fallback**: If no host configuration is found, you'll need to set up your Git identity manually
3. **Safe Directory**: The workspace is automatically added as a safe directory

### Multiple Git Profiles

Use the built-in `git-profile` command to manage multiple Git identities:

```bash
# Create a new profile
git-profile create work
git-profile create personal

# List all profiles  
git-profile list

# Switch between profiles
git-profile use work
git-profile use personal

# Show current profile
git-profile current

# Edit a profile
git-profile edit work

# Delete a profile
git-profile delete old-profile
```

## Quick Start

If you're getting git commit errors, here's how to fix it:

### Option 1: Use Host Configuration (Recommended)
Your host's `.gitconfig` should automatically be available in the container. If not, restart the container.

### Option 2: Create a Profile
```bash
git-profile create main
# Follow the prompts to enter your name and email
git-profile use main
```

### Option 3: Manual Configuration
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## NPM Packages for Git Profile Management

If you prefer npm-based solutions, here are popular packages:

### 1. **git-user-switch** 
```bash
npm install -g git-user-switch
```
Simple CLI for switching git users globally or per repository.

### 2. **gitconfig**
```bash
npm install -g gitconfig
```
Programmatic API for reading/writing git config.

### 3. **git-user**
```bash
npm install -g git-user
```
Lightweight tool for managing git user configurations.

### 4. **git-profile-manager**
```bash
npm install -g git-profile-manager
```
Feature-rich profile manager with templates and project-specific configs.

## GitHub CLI Integration

The container includes GitHub CLI (`gh`). After setting up git, authenticate with:

```bash
gh auth login
```

This will help with repository operations and maintain consistency between git and GitHub identities.

## Environment Variables

The container sets these environment variables:
- `GITHUB_OWNER`: Currently set to `bailejl` (you may want to change this)
- `GITHUB_REPO`: Currently set to `Product-Outcomes` (you may want to change this)

## Troubleshooting

### Problem: "Please tell me who you are" error
**Solution**: Run `git-profile create myprofile` and follow the prompts, then `git-profile use myprofile`

### Problem: Host .gitconfig not mounted
**Solution**: Ensure your host has a `.gitconfig` file in your home directory, then rebuild the container

### Problem: Permission issues with git operations
**Solution**: The container automatically adds the workspace as a safe directory. If issues persist, run:
```bash
git config --global --add safe.directory /workspace
```

## Advanced Usage

### Project-specific Git Configuration

You can also set repository-specific configuration:

```bash
# In your project directory
git config user.name "Project Specific Name"
git config user.email "project@example.com"
```

This overrides global settings for that specific repository.

### SSH Key Setup

To use SSH keys with GitHub:

1. Mount your SSH keys in the devcontainer.json:
```json
"mounts": [
  "source=${localEnv:HOME}/.ssh,target=/home/node/.ssh,type=bind,readonly"
]
```

2. Or create new SSH keys in the container:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
gh ssh-key add ~/.ssh/id_ed25519.pub
```