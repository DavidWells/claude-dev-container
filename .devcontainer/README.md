
# Dev Container

This dev container automatically sets up your development environment with Node.js, Deno, Playwright, and Git configuration.

## Git Profile Auto-Setup

The container automatically configures Git on startup using one of these methods (in priority order):

### 1. Environment Variables (Recommended)
Set these environment variables before starting the container:
```bash
export GIT_USER_NAME="Your Name"
export GIT_USER_EMAIL="your.email@example.com"
export GIT_GITHUB_USER="yourusername"  # Optional
export GIT_PROFILE_NAME="work"         # Optional, defaults to "default"
```

### 2. Host Git Config
Your host's `~/.gitconfig` file is automatically copied if available.

### 3. Default Profile
If you have a profile named "default" (or set `GIT_DEFAULT_PROFILE`), it will be applied automatically.

### 4. Manual Setup
Use the `git-profile` command to create and manage profiles:
```bash
git-profile create work
git-profile use work
```

## Available Commands

- `git-profile` - Manage Git profiles (create, list, use, delete)

## TODO

- Copy config files in like https://github.com/Vakarva/dev-builder/blob/13231243c0352b825895b8d992456b5c898da913/Containerfile#L19-L23
- Node via nvm? https://github.com/Vakarva/dev-builder/blob/13231243c0352b825895b8d992456b5c898da913/Containerfile#L52-L58
- Python via uv? https://github.com/Vakarva/dev-builder/blob/13231243c0352b825895b8d992456b5c898da913/Containerfile#L52-L58