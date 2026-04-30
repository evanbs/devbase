# devbase

Imagem Docker base para desenvolvimento, construída sobre `mcr.microsoft.com/devcontainers/base:debian`.

Publicada em `ghcr.io/evanbs/devbase`.

## Ferramentas incluídas

| Ferramenta | Descrição |
|---|---|
| zsh + oh-my-zsh | Shell e framework |
| starship | Prompt Catppuccin Frappé (baked from dev-dotfiles) |
| fnm | Gerenciador de versões do Node |
| git + git-delta | Controle de versão com diff colorido |
| eza | `ls` moderno com ícones |
| bat | `cat` com syntax highlight |
| ripgrep | Busca rápida em arquivos |
| fzf | Fuzzy finder interativo |
| jq | Processador de JSON |
| httpyac | Cliente HTTP para arquivos `.http` |
| p7zip | Descompactação de múltiplos formatos |
| xclip | Suporte a clipboard (usado por `clip`) |

## Funções disponíveis

- `clip` — copia stdin para clipboard
- `mkcd <dir>` — cria diretório e entra nele
- `fcd [dir]` — navega com fzf
- `rgfzf [pattern]` — busca interativa com rg + fzf
- `extract <arquivo>` — descompacta qualquer formato
- `devinfo` — mostra versões de todas as ferramentas

## Estrutura do repositório

```
containers/
├── Dockerfile
├── config/
│   ├── .aliases          # aliases pessoais (sincronizados com dev-dotfiles)
│   ├── .functions        # clip, mkcd, fcd, rgfzf, extract, devinfo
│   ├── .zshrc.append     # inicialização do zsh (fnm, starship, aliases)
│   ├── devinfo           # script de diagnóstico de ferramentas
│   └── starship.toml     # tema Catppuccin Frappé (baked from dev-dotfiles)
└── .devcontainer/
    └── devcontainer.json # template para novos projetos
```

## Uso em projetos

```bash
# Copiar template de devcontainer
cp .devcontainer/devcontainer.json ~/projetos/meu-projeto/.devcontainer/

# Editar: substituir {{PROJECT_NAME}}, descomentar features e portas
```

O template já inclui o fix de login shell (`zsh -l`) para que o terminal
integrado do VS Code carregue corretamente aliases, PATH do fnm e o prompt
starship.

## Autenticar no GHCR

A imagem é privada. É necessário autenticar uma vez por máquina antes de fazer pull:

```bash
echo $GH_TOKEN | docker login ghcr.io -u evanbs --password-stdin
```

## Build local

```bash
docker build -t devbase-local .
docker run -it devbase-local devinfo
```

## Publicar manualmente

```bash
echo $GH_TOKEN | docker login ghcr.io -u evanbs --password-stdin
docker build -t ghcr.io/evanbs/devbase:latest .
docker push ghcr.io/evanbs/devbase:latest
```
