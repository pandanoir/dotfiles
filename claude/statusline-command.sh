#!/usr/bin/env bash
# Claude Code status line — flat style with separators, no background colors
# Sections: [os] │ [directory] │ [git branch] │ [model/context] │ [vim mode]

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# --- Directory: truncate to last 3 segments, replace HOME with ~
home="$HOME"
dir="${cwd/#$home/~}"
IFS='/' read -ra parts <<< "$dir"
total=${#parts[@]}
if [ "$total" -gt 3 ]; then
  dir="…/${parts[$((total-3))]}/${parts[$((total-2))]}/${parts[$((total-1))]}"
fi

# --- Git branch (skip optional locks)
branch=""
if git_out=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
  branch="$git_out"
fi

# --- Context usage
ctx_info=""
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  ctx_info="${used_int}%"
fi

# ANSI colors — Claude Code theme (warm terracotta/coral palette)
C_RESET="\033[0m"
SEP="\033[2;38;2;120;113;108m │ \033[0m"  # dim warm gray separator

C_OS="\033[38;2;217;119;87m"        # terracotta (Claude brand accent)
C_DIR="\033[38;2;189;177;168m"      # warm light gray
C_GIT="\033[38;2;217;119;87m"       # terracotta for git branch
C_MODEL="\033[38;2;156;147;139m"    # muted warm gray
C_CTX="\033[38;2;217;119;87m"       # terracotta for context %
C_VIM_INSERT="\033[1;38;2;217;119;87m"   # bold terracotta for INSERT
C_VIM_NORMAL="\033[1;38;2;189;177;168m"  # bold warm gray for NORMAL


# Build output
line=""
first=1

# Helper: append separator before all sections except the first
sep() {
  if [ "$first" -eq 1 ]; then
    first=0
  else
    line+="${SEP}"
  fi
}

# Segment 1: directory
sep
line+="${C_DIR}${dir}${C_RESET}"

# Segment 3: git branch (only if in a repo)
if [ -n "$branch" ]; then
  sep
  line+="${C_GIT} ${branch}${C_RESET}"
fi

# Segment 4: model + context usage
sep
line+="${C_MODEL}${model}${C_RESET}"
if [ -n "$ctx_info" ]; then
  line+=" ${C_CTX}${ctx_info}${C_RESET}"
fi

# Segment 5: vim mode (only when active)
if [ -n "$vim_mode" ]; then
  sep
  if [ "$vim_mode" = "INSERT" ]; then
    line+="${C_VIM_INSERT}${vim_mode}${C_RESET}"
  else
    line+="${C_VIM_NORMAL}${vim_mode}${C_RESET}"
  fi
fi

printf "%b" "$line"
