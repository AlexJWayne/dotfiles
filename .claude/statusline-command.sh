#!/bin/bash

# Read JSON input
input=$(cat)

# Extract values
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')

# Calculate tokens used from percentage (includes cache reads)
tokens_limit=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
tokens_used=$((tokens_limit * used_percentage / 100))

# Format token counts (convert to K)
format_tokens() {
    local tokens=$1
    if [ "$tokens" -ge 1000 ]; then
        echo "$((tokens / 1000))K"
    else
        echo "$tokens"
    fi
}

tokens_used_fmt=$(format_tokens "$tokens_used")
tokens_limit_fmt=$(format_tokens "$tokens_limit")

# Powerline separator - using actual character
sep=""

output=""

# Folder segment (dark brown bg, white text)
folder=$(basename "$cwd")
output+="\033[48;5;94m\033[97m $folder "

# Git segment (if in git repo)
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "detached")

    # Arrow: dark brown fg on dark gray bg
    output+="\033[38;5;94m\033[48;5;237m${sep}"

    # Branch (dark gray bg, white text)
    output+="\033[48;5;237m\033[97m $branch "

    # Arrow: dark gray fg on transparent (end of git segment)
    output+="\033[38;5;237m\033[0m${sep}"
else
    # Arrow: dark brown fg on transparent
    output+="\033[38;5;94m\033[0m${sep}"
fi

# Model badge (no bg, white text with spacing)
output+="   \033[97m$model\033[0m"

# Token usage (dim gray text)
if [ "$tokens_limit" -gt 0 ]; then
    output+="   \033[90m${tokens_used_fmt} / ${tokens_limit_fmt}\033[0m"
fi

echo -e "$output"
