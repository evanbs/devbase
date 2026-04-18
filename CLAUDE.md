# devbase — instruções para Claude Code

## Contexto

Repositório de imagem Docker base para desenvolvimento.
Construída sobre `mcr.microsoft.com/devcontainers/base:ubuntu`.
Publicada em `ghcr.io/evanbs/devbase`.

## Ambiente do host

- OS: Ubuntu 24.04 via WSL2
- Shell: zsh + oh-my-zsh + starship
- Docker: Docker Desktop com WSL2 backend
- Node: gerenciado por fnm (auto-switch via `.node-version`)
- Package managers: apt, npm, yarn, pnpm
- Ferramentas: git, eza, bat, ripgrep, fzf, jq, httpyac, claude code
- Funções disponíveis: clip, mkcd, fcd, rgfzf, extract, devinfo

## Estrutura do repositório

```
devbase/
├── Dockerfile                     # imagem base
├── README.md
├── config/
│   ├── .aliases                   # aliases universais
│   ├── .functions                 # clip, mkcd, rgfzf, devinfo...
│   └── .zshrc.append              # adicionado ao .zshrc padrão
├── .devcontainer/
│   └── devcontainer.json          # template para projetos
└── .github/
    └── workflows/
        └── build.yml              # publica no ghcr.io automaticamente
```

## Tarefas comuns

### Build local da imagem

```bash
cd ~/projetos/devbase
docker build -t devbase-local .
```

### Testar a imagem localmente

```bash
# Entrar no container e verificar o ambiente
docker run -it devbase-local

# Dentro do container, rodar devinfo para checar ferramentas
devinfo
```

### Build sem cache (quando algo quebrar)

```bash
docker build --no-cache --progress=plain -t devbase-local . 2>&1 | tee build.log
```

### Publicar no ghcr.io manualmente

```bash
echo $GH_TOKEN | docker login ghcr.io -u evanbs --password-stdin
docker build -t ghcr.io/evanbs/devbase:latest .
docker push ghcr.io/evanbs/devbase:latest
```

### Adicionar nova ferramenta à imagem base

1. Editar `Dockerfile` — adicionar instalação via `apt-get` ou binário
2. Se tiver alias: adicionar em `config/.aliases`
3. Se tiver função: adicionar em `config/.functions`
4. Build local e testar antes de publicar

### Criar .devcontainer para um projeto novo

```bash
cd ~/projetos/nome-do-projeto
mkdir .devcontainer
cp ~/projetos/devbase/.devcontainer/devcontainer.json .devcontainer/
```

Editar `.devcontainer/devcontainer.json`:
- Substituir `{{PROJECT_NAME}}` pelo nome do projeto
- Descomentar features da stack do projeto
- Descomentar portas necessárias
- Ajustar `postCreateCommand`

## Regras

- Nunca hardcodar valores de variáveis de ambiente — sempre usar `${localEnv:VAR}`
- Nunca adicionar configs pessoais na imagem base — essas ficam no dotfiles pessoal
- Projetos do time sempre apontam para `ghcr.io/evanbs/devbase:latest`
- Features de stack (Java, Android, Python, Rust) ficam no `devcontainer.json` do projeto, nunca na imagem base
- Projetos ficam em `~/projetos/` (FS do WSL2), nunca em `/mnt/c/`

## Variáveis de ambiente necessárias no host

```bash
# ~/.zshrc do WSL2
export ANTHROPIC_API_KEY="sk-ant-..."
export GH_TOKEN="ghp_..."
```

## Troubleshooting

**Container não abre o zsh corretamente:**
```bash
docker run -it --entrypoint /bin/bash devbase-local
cat ~/.zshrc  # verificar se .zshrc.append foi adicionado
```

**npm install -g falhou durante o build:**
```bash
# Verificar se nvm está no PATH durante o build
docker run -it devbase-local which node
docker run -it devbase-local node --version
```

**Ferramenta não encontrada no container:**
```bash
docker run -it devbase-local devinfo
# mostra versão de todas as ferramentas ou "não instalado"
```

**Build lento:**
O GitHub Actions usa cache entre builds (`cache-from: type=gha`).
Localmente, evite `--no-cache` a não ser que precise forçar reinstalação.
