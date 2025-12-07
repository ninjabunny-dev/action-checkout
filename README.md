# Clone Repository Action

A Gitea action that clones a repository with default behavior to clone the current repository, but allows users to specify a custom repository URL.

## Features

- **Default to self-repo**: Automatically clones the current repository if no URL is provided
- **Custom repository support**: Clone any repository by providing a URL
- **Branch selection**: Clone specific branches
- **Custom target path**: Choose where to clone the repository
- **Token authentication**: Support for private repositories
- **Cross-platform**: Works on any runner

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `repository_url` | Repository URL to clone (defaults to current repository) | No | `""` |
| `target_path` | Target directory for cloning | No | Repository name |
| `branch` | Branch to checkout | No | Default branch |
| `token` | Access token for private repositories | No | `""` |

## Outputs

| Output | Description |
|--------|-------------|
| `clone_path` | Path where repository was cloned |

## Usage Examples

### Basic Usage (Clone Self Repository)

```yaml
name: Clone Self Repository
on: [push]

jobs:
  clone:
    runs-on: ubuntu-latest
    steps:
      - name: Clone repository
        uses: ./
        id: clone
        
      - name: Use cloned code
        run: |
          cd "${{ steps.clone.outputs.clone_path }}"
          # Your commands here
```

### Clone Custom Repository

```yaml
name: Clone Custom Repository
on: [push]

jobs:
  clone:
    runs-on: ubuntu-latest
    steps:
      - name: Clone custom repository
        uses: ./
        with:
          repository_url: 'https://github.com/user/repo.git'
          target_path: 'my-repo'
```

### Clone Specific Branch

```yaml
name: Clone Specific Branch
on: [push]

jobs:
  clone:
    runs-on: ubuntu-latest
    steps:
      - name: Clone specific branch
        uses: ./
        with:
          repository_url: 'https://github.com/user/repo.git'
          branch: 'develop'
          target_path: 'develop-branch'
```

### Clone Private Repository with Token

```yaml
name: Clone Private Repository
on: [push]

jobs:
  clone:
    runs-on: ubuntu-latest
    steps:
      - name: Clone private repository
        uses: ./
        with:
          repository_url: 'https://github.com/user/private-repo.git'
          token: ${{ secrets.REPO_TOKEN }}
          target_path: 'private-repo'
```

### Manual Trigger with Custom Repository

```yaml
name: Manual Clone
on:
  workflow_dispatch:
    inputs:
      repo_url:
        description: 'Repository URL to clone'
        required: true
      target_dir:
        description: 'Target directory'
        required: false

jobs:
  clone:
    runs-on: ubuntu-latest
    steps:
      - name: Clone repository
        uses: ./
        with:
          repository_url: ${{ github.event.inputs.repo_url }}
          target_path: ${{ github.event.inputs.target_dir || 'cloned-repo' }}
```

## How It Works

1. **Repository URL Resolution**: If no `repository_url` is provided, it uses `${{ gitea.server_url }}/${{ gitea.repository }}.git`
2. **Target Path**: If no `target_path` is provided, it extracts the repository name from the URL
3. **Authentication**: If a token is provided, it's automatically added to HTTPS URLs
4. **Branch Selection**: Uses `git clone --branch` if a branch is specified
5. **Output**: Returns the actual path where the repository was cloned

## Environment Variables

The action uses these Gitea environment variables:
- `gitea.server_url`: The Gitea server URL
- `gitea.repository`: The repository name (owner/repo)
- `gitea.token`: The default token (if no custom token provided)

## Error Handling

The action will fail if:
- The repository URL is invalid
- Authentication fails for private repositories
- The target directory already exists
- The specified branch doesn't exist

## License

MIT License