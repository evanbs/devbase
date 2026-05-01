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
| aws-cli v2 | AWS CLI pré-configurado para ambiente local (DynamoDB Local + MinIO) |
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
│   ├── devinfo           # mostra versões de todas as ferramentas
│   ├── devbase-setup     # solicita nome do projeto no postCreateCommand
│   └── starship.toml     # tema Catppuccin Frappé (baked from dev-dotfiles)
├── .devcontainer/
│   └── devcontainer.json # template para novos projetos
└── local-aws/
    └── docker-compose.yml # DynamoDB Local + MinIO (ambiente AWS local compartilhado)
```

## Ambiente AWS local

Todos os devcontainers derivados apontam automaticamente para serviços locais de AWS via variáveis de ambiente pré-configuradas no template. Os serviços são compartilhados entre projetos e precisam ser iniciados uma única vez no host:

```bash
docker compose -f local-aws/docker-compose.yml up -d
```

| Serviço | Porta | Equivalente AWS |
|---|---|---|
| DynamoDB Local | 8000 | DynamoDB |
| MinIO | 9000 | S3 |
| MinIO console | 9001 | — |

O console web do MinIO (`http://localhost:9001`) permite inspecionar buckets visualmente (user: `devlocal`, password: `devlocal`).

O estado persiste via volumes Docker — dados sobrevivem a `docker compose restart`.

## Uso em projetos

```bash
# Copiar template de devcontainer
cp .devcontainer/devcontainer.json ~/projetos/meu-projeto/.devcontainer/

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

## Testar ambiente AWS local

```bash
# 1. Subir os serviços (uma vez)
docker compose -f local-aws/docker-compose.yml up -d

# 2. Build da imagem
docker build -t devbase-local .

# 3. Testar AWS CLI contra os serviços locais
docker run -it --rm \
  --add-host=host.docker.internal:host-gateway \
  -e AWS_ACCESS_KEY_ID=devlocal \
  -e AWS_SECRET_ACCESS_KEY=devlocal \
  -e AWS_DEFAULT_REGION=us-east-1 \
  -e AWS_ENDPOINT_URL_DYNAMODB=http://host.docker.internal:8000 \
  -e AWS_ENDPOINT_URL_S3=http://host.docker.internal:9000 \
  devbase-local zsh -c "aws --version && aws dynamodb list-tables && aws s3 ls && devinfo"
```

> O `--add-host` é necessário apenas no teste manual via `docker run`. Dentro de um devcontainer o Docker Desktop resolve `host.docker.internal` automaticamente.

## Publicar manualmente

```bash
echo $GH_TOKEN | docker login ghcr.io -u evanbs --password-stdin
docker build -t ghcr.io/evanbs/devbase:latest .
docker push ghcr.io/evanbs/devbase:latest
```
