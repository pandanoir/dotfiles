FROM node:24-slim

RUN apt update && \
    apt install -y zsh git curl fzf unzip gcc && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes
RUN curl -fsSL https://deno.land/x/install/install.sh | sh

# 最新ビルドのneovimをインストール
RUN if [ "$(uname -m)" = "x86_64" ]; then ARCH="linux-x86_64"; else ARCH="linux-arm64"; fi && \
    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-${ARCH}.tar.gz && \
    tar xzf nvim-${ARCH}.tar.gz && \
    rm nvim-${ARCH}.tar.gz && \
    mkdir -p /root/local && mv nvim-${ARCH} /root/local/nvim

COPY . /root/dotfiles
WORKDIR /root/dotfiles

RUN ./install.sh

CMD ["/bin/zsh"]
