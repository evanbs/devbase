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
| aws-cli v2 | AWS CLI |
| p7zip | Descompactação de múltiplos formatos |
| xclip | Suporte a clipboard (usado por `clip`) |

## Funções disponíveis

- `clip` — copia stdin para clipboard
- `mkcd <dir>` — cria diretório e entra nele
- `fcd [dir]` — navega com fzf
- `rgfzf [pattern]` — busca interativa com rg + fzf
- `extract <arquivo>` — descompacta qualquer formato
- `devinfo` — mostra versões de todas as ferramentas
- `devcontainer-init [nome]` — inicializa devcontainer do template devbase

## Estrutura do repositório

```
containers/
├── Dockerfile
├── config/
│   ├── .aliases          # aliases pessoais (sincronizados com dev-dotfiles)
│   ├── .functions        # clip, mkcd, fcd, rgfzf, extract, devinfo
│   ├── .zshrc.append     # inicialização do zsh (fnm, starship, aliases)
│   ├── devinfo           # mostra versões de todas as ferramentas
│   ├── devbase-setup     # solicita nome do projeto no postCreateCommand
│   └── starship.toml     # tema Catppuccin Frappé (baked from dev-dotfiles)
├── .devcontainer/
│   ├── devcontainer.json  # template para novos projetos
│   └── docker-compose.yml # app devcontainer base
```

## Extensões VS Code incluídas

O template inclui 16 extensões universais que são úteis para qualquer tipo de projeto:

### Essenciais (7)
- **editorconfig.editorconfig** — configuração de editor consistente
- **eamodio.gitlens** — Git avançado (blame, history, lens)
- **streetsidesoftware.code-spell-checker** — corretor ortográfico
- **gruntfuggly.todo-tree** — visualização de TODOs no código
- **christian-kohler.path-intellisense** — autocomplete de paths
- **sleistner.vscode-fileutils** — operações de arquivo (rename, move, duplicate)
- **mkxml.vscode-filesize** — mostra tamanho de arquivo na barra

### Docker (1)
- **ms-azuretools.vscode-containers** — suporte completo a Docker

### Markdown & Documentação (2)
- **yzhang.markdown-all-in-one** — Markdown completo
- **bierner.markdown-mermaid** — diagramas Mermaid

### API & HTTP (1)
- **anweber.vscode-httpyac** — cliente HTTP para arquivos `.http`

### Qualidade de Código (2)
- **nhoizey.gremlins** — detecta caracteres invisíveis
- **redhat.vscode-xml** — suporte a XML

### Visual (3)
- **naumovs.color-highlight** — highlight de cores no código
- **kisstkondoros.vscode-gutter-preview** — preview de imagens
- **hextorgb.hex-to-rgb** — conversor hex/rgb

### Extensões específicas de stack

Extensões para linguagens/frameworks específicos devem ser adicionadas no `devcontainer.json` de cada projeto:

- **Front-end**: Tailwind, auto-rename-tag, live-server, px-to-rem, import-cost
- **.NET**: csdevkit, csharp, dotnet-runtime  
- **JS/TS**: Biome, Prettier, ESLint, auto-barrel

## Uso em projetos

```bash
# Copiar template de devcontainer (dois arquivos)
mkdir -p ~/projetos/meu-projeto/.devcontainer
cp .devcontainer/devcontainer.json ~/projetos/meu-projeto/.devcontainer/
cp .devcontainer/docker-compose.yml ~/projetos/meu-projeto/.devcontainer/

# Descomentar features e portas necessárias, depois abrir no VS Code
# O nome do projeto será solicitado no terminal na primeira abertura
```

O template já inclui o fix de login shell (`zsh -l`) para que o terminal
integrado do VS Code carregue corretamente aliases, PATH do fnm e o prompt
starship.

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
