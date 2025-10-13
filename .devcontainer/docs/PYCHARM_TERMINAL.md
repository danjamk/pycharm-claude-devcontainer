# PyCharm Terminal with Zsh

This guide explains how to use Zsh with Oh My Zsh in PyCharm's dev container terminal.

## Quick Setup

### 1. Configure PyCharm Terminal

1. Open **Settings** (`Cmd + ,` on Mac)
2. Go to **Tools → Terminal**
3. Set **Shell path**: `/bin/zsh`
4. **Uncheck** "Enable shell integration"
5. Click **Apply**
6. **Close all terminal tabs**
7. Open a **new terminal**

You should see:
- ✅ Welcome banner
- ✅ Git-aware prompt: `➜  workspace git:(main) ✗`
- ✅ Syntax highlighting (commands turn green/red)
- ✅ Autosuggestions (gray text from history)

## Zsh Features

### Syntax Highlighting

Commands change color as you type:
- **Green**: Valid command
- **Red**: Invalid command/typo
- **Blue**: Directories
- **Cyan**: Aliases

### Autosuggestions

Start typing a command you've used before:
```bash
aws<gray text appears>
```

Press `→` (right arrow) or `Ctrl+F` to accept the suggestion.

### Git-Aware Prompt

The prompt shows:
```bash
➜  workspace git:(main) ✗
```

- `➜` - Ready for command
- `workspace` - Current directory
- `git:(main)` - Git branch
- `✗` - Uncommitted changes

Changes to:
- `✓` - Clean working directory
- `±` - Staged and unstaged changes

### Tab Completion

Enhanced completion for:
- Git commands and branches
- Docker commands and containers
- File paths
- Command options

Try:
```bash
git che<Tab>
# Completes to: git checkout

git checkout <Tab>
# Shows list of branches
```

## Why Disable Shell Integration?

### PyCharm Shell Integration Provides:
- Command navigation (Cmd+Up/Down between commands)
- Visual command execution indicators
- Quick command fixes for typos

### Oh My Zsh Provides:
- Syntax highlighting
- Autosuggestions from history
- Git-aware prompt
- 300+ community plugins
- Better tab completion

### The Problem

PyCharm's shell integration **forces bash** to work, overriding your shell choice. To use zsh with Oh My Zsh, you must disable shell integration.

### The Trade-off

**Disable integration** (recommended):
- ✅ Get full zsh experience
- ❌ Lose PyCharm command navigation

**Keep integration** (not recommended):
- ✅ Keep PyCharm features
- ❌ Stuck with bash (no zsh features)

**For this project, zsh features are more valuable.**

## Troubleshooting

### Terminal Still Shows Bash

**Problem**: After changing settings, terminal still uses bash

**Check:**
```bash
echo $SHELL
ps -p $$ -o comm=
```

Should show:
```
/bin/zsh
zsh
```

**Solution:**
1. **Close ALL terminal tabs** (click X on each tab)
2. Open a **brand new terminal**
3. If still bash, run: `exec zsh`

### No Git Info in Prompt

**Problem**: Prompt shows `developer@container` instead of git info

**Check:**
```bash
echo $ZSH
```

Should show: `/home/developer/.oh-my-zsh`

If empty, Oh My Zsh didn't load.

**Solution:**
```bash
source ~/.zshrc
```

### Syntax Highlighting Not Working

**Problem**: Commands don't turn green/red as you type

**Check:**
```bash
ls -la ~/.oh-my-zsh/custom/plugins/
```

Should see: `zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-completions`

**Solution:**
```bash
# Verify plugins in .zshrc
grep "^plugins=" ~/.zshrc

# Should show:
# plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

# Reload
source ~/.zshrc
```

### Autosuggestions Not Appearing

**Problem**: No gray text suggestions when typing

**Possible causes:**
1. Plugin not loaded (see above)
2. No history yet (type some commands first)
3. Command not in history

**Solution:**
```bash
# Check history
history | tail -20

# Run some commands to build history
ls
cd /workspace
git status

# Try typing those commands again
```

### Welcome Banner Appears Twice

**Problem**: Banner shows twice when opening new terminal

**This should not happen anymore**, but if it does:

**Solution:** Already fixed in `.zshenv`. If you see this, restart container.

### Settings Don't Persist

**Problem**: PyCharm reverts to bash after restart

**Solution:**
1. Verify shell path is `/bin/zsh` (not `/usr/bin/zsh`)
2. Ensure "Enable shell integration" is unchecked
3. Try restarting PyCharm entirely (not just terminal)

## Using iTerm2 Instead

Many developers prefer using an external terminal:

**Advantages:**
- ✅ Full zsh experience without configuration
- ✅ Better performance
- ✅ More customization options
- ✅ Tmux integration

**To use iTerm2:**
```bash
# In iTerm2, connect to container
docker exec -it <container-id> zsh

# Or use Docker Desktop → Containers → CLI button
```

**Works perfectly** - no PyCharm configuration needed!

## Zsh Customization

### Change Theme

Edit `~/.zshrc`:
```bash
# Change this line:
ZSH_THEME="robbyrussell"

# To another theme:
ZSH_THEME="agnoster"      # Fancy arrows
ZSH_THEME="powerlevel10k" # Most customizable
```

Popular themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

**Note:** Changes to `~/.zshrc` don't persist across container rebuilds. To make permanent, edit `.devcontainer/Dockerfile`.

### Add Custom Aliases

Edit `~/.zshrc`:
```bash
# Add at the end
alias myalias="my command"
alias gs="git status"
alias gp="git pull"
```

Then reload:
```bash
source ~/.zshrc
```

### Add More Plugins

Oh My Zsh has 300+ plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins

To add one, edit `.devcontainer/Dockerfile` and rebuild container.

## Comparison: PyCharm vs iTerm2

| Feature | PyCharm Terminal | iTerm2 |
|---------|------------------|--------|
| Zsh support | ✅ (with config) | ✅ (automatic) |
| Oh My Zsh | ✅ (with config) | ✅ (automatic) |
| Syntax highlighting | ✅ | ✅ |
| Git-aware prompt | ✅ | ✅ |
| PyCharm integration | ❌ (disabled) | ❌ (separate app) |
| Split panes | ⚠️ Limited | ✅ Full tmux support |
| Performance | ⚠️ Good | ✅ Excellent |
| Customization | ⚠️ Limited | ✅ Extensive |

**Recommendation:** Configure PyCharm for convenience, use iTerm2 for heavy terminal work.

## Related Documentation

- [Main README](../../../README.md) - Dev container overview
- [GitHub Setup](./GITHUB_SETUP.md) - GitHub SSH configuration
- [macOS Security](./MACOS_SECURITY.md) - Docker file sharing

## Summary

**To use zsh in PyCharm:**
1. Settings → Tools → Terminal → Shell path: `/bin/zsh`
2. Uncheck "Enable shell integration"
3. Close all terminals, open new one
4. Enjoy syntax highlighting, autosuggestions, and git-aware prompt!

**Trade-off:** You lose PyCharm command navigation, but gain much more powerful terminal features.