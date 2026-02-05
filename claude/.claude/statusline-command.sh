#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Get current directory from JSON input
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Get username and hostname
username=$(whoami)
hostname=$(hostname -s)

# Get token usage information
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Calculate context usage percentage
if [ "$total_input" != "0" ] && [ "$context_size" != "0" ]; then
    percent_used=$((total_input * 100 / context_size))
else
    percent_used=0
fi

# Format the status line
# Color codes: \033[32m = green, \033[33m = yellow, \033[36m = cyan, \033[0m = reset
printf "\033[32m[%s@%s]\033[0m %s \033[36m|\033[0m In:%s Out:%s (%s%%) \033[36m|\033[0m \$%s" \
    "$username" "$hostname" "$current_dir" "$total_input" "$total_output" "$percent_used" "$total_cost"
