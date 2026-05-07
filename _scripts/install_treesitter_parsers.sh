#!/usr/bin/env bash
# tree-sitter パーサーをビルドし、クエリを配置するスクリプト
# 依存: tree-sitter-cli, git, C compiler
set -euo pipefail

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site"
PARSER_DIR="$DATA_DIR/parser"
QUERY_DIR="$DATA_DIR/queries"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

case "$(uname -s)" in
  Darwin)               EXT=dylib ;;
  MINGW*|MSYS*|CYGWIN*) EXT=dll ;;
  *)                    EXT=so ;;
esac

# 形式: "lang,owner/repo,location"
GH="https://github.com"
PARSERS=(
  "bash,tree-sitter/tree-sitter-bash,"
  "css,tree-sitter/tree-sitter-css,"
  "html,tree-sitter/tree-sitter-html,"
  "javascript,tree-sitter/tree-sitter-javascript,"
  "json,tree-sitter/tree-sitter-json,"
  "lua,tree-sitter-grammars/tree-sitter-lua,"
  "markdown,tree-sitter-grammars/tree-sitter-markdown,tree-sitter-markdown"
  "markdown_inline,tree-sitter-grammars/tree-sitter-markdown,tree-sitter-markdown-inline"
  "scss,serenadeai/tree-sitter-scss,"
  "toml,tree-sitter-grammars/tree-sitter-toml,"
  "typescript,tree-sitter/tree-sitter-typescript,typescript"
  "tsx,tree-sitter/tree-sitter-typescript,tsx"
  "vim,tree-sitter-grammars/tree-sitter-vim,"
  "vimdoc,neovim/tree-sitter-vimdoc,"
  "vue,tree-sitter-grammars/tree-sitter-vue,"
)
BUILTIN_QUERY_LANGS="c lua markdown markdown_inline query vim vimdoc"
QUERY_LANGS=("${PARSERS[@]%%,*}" ecma jsx html_tags)

clone_repo() {
  local repo=$1 dest="$WORK_DIR/${repo##*/}"
  echo "  clone: $repo"
  git clone --quiet --depth 1 "$GH/$repo.git" "$dest"
}

build_parsers() {
  echo "==> Building parsers..."
  mkdir -p "$PARSER_DIR"

  # cloneが必要なリポジトリを収集 (重複排除)
  declare -A NEED_CLONE
  for entry in "${PARSERS[@]}"; do
    IFS=',' read -r lang repo location <<< "$entry"
    [[ -f $PARSER_DIR/$lang.$EXT ]] && continue
    NEED_CLONE[$repo]=1
  done

  # 並列 clone を実行
  for repo in "${!NEED_CLONE[@]}"; do
    clone_repo "$repo" &
  done
  wait

  # ビルド
  for entry in "${PARSERS[@]}"; do
    IFS=',' read -r lang repo location <<< "$entry"
    if [[ -f $PARSER_DIR/$lang.$EXT ]]; then
      echo "  skip: $lang"
      continue
    fi
    local clone_dir="$WORK_DIR/${repo##*/}"
    echo "  build: $lang"
    tree-sitter build -o "$PARSER_DIR/$lang.$EXT" \
      "${clone_dir}${location:+/$location}"
  done
}

fetch_queries() {
  echo "==> Fetching queries..."
  mkdir -p "$QUERY_DIR"
  # nvim-treesitter をクエリファイルの取得元として clone
  local nvim_ts="$WORK_DIR/nvim-treesitter"
  git clone --quiet --depth 1 --branch main \
    "$GH/nvim-treesitter/nvim-treesitter.git" "$nvim_ts"

  for lang in "${QUERY_LANGS[@]}"; do
    # Neovim 本体に同梱されている言語はスキップ
    if echo "$BUILTIN_QUERY_LANGS" | grep -qw "$lang"; then
      echo "  skip (builtin): $lang"
      continue
    fi
    local src="$nvim_ts/runtime/queries/$lang"
    if [[ -d $src ]]; then
      echo "  copy: $lang"
      rm -rf "$QUERY_DIR/$lang"
      cp -r "$src" "$QUERY_DIR/$lang"
    else
      echo "  warn: no queries for $lang"
    fi
  done
}

build_parsers
fetch_queries
echo "==> Done."
