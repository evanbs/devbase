FROM mcr.microsoft.com/devcontainers/base:debian

ARG DEBIAN_FRONTEND=noninteractive

# Core tools + Node.js (via NodeSource) para httpyac no build
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    jq \
    ripgrep \
    fzf \
    bat \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    xclip \
    git-delta \
    p7zip-full \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# bat: symlink resiliente — Debian instala como batcat em algumas versões
RUN command -v bat >/dev/null 2>&1 || ln -sf /usr/bin/batcat /usr/local/bin/bat

# eza — binário direto do release (evita instabilidade do repo deb.gierens.de)
RUN curl -fsSL \
    "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" \
    | tar xz -C /tmp \
    && mv /tmp/eza /usr/local/bin/eza \
    && chmod +x /usr/local/bin/eza

# httpyac (Node já está no PATH via apt)
RUN npm install -g httpyac

# starship prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

# fnm — apenas para uso em runtime (gerenciar versões de Node nos projetos)
USER vscode
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.fnm" --skip-shell

# Copiar configs
USER root
COPY config/.aliases       /etc/profile.d/devbase_aliases.sh
COPY config/.functions     /etc/profile.d/devbase_functions.sh
COPY config/.zshrc.append  /tmp/.zshrc.append
COPY config/devinfo        /usr/local/bin/devinfo
RUN chmod +x /usr/local/bin/devinfo

RUN cat /tmp/.zshrc.append >> /home/vscode/.zshrc \
    && chown vscode:vscode /home/vscode/.zshrc

# starship config (Catppuccin Frappé, baked from dev-dotfiles)
RUN mkdir -p /home/vscode/.config
COPY config/starship.toml /home/vscode/.config/starship.toml
RUN chown -R vscode:vscode /home/vscode/.config

USER vscode
