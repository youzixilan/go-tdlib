# go-tdlib

Go wrapper for [TDLib](https://github.com/tdlib/td) with full API coverage and a CLI tool (`tgctl`).

## Features

- **Full API coverage** — Code generator produces 2198 types + 962 functions from `td_api.tl`
- **CGO bridge** — Thin wrapper around `td_json_client` C interface
- **tgctl CLI** — Login, send messages, create bots, list chats, search, listen, and more
- **Multi-account** — `--profile` flag for switching between Telegram accounts
- **OpenClaw Skill** — Ready-to-use skill in `skill/` directory

## Quick Start

### Prerequisites

- Go 1.21+
- TDLib compiled locally (see [install guide](skill/references/install.md))
- Telegram API credentials from https://my.telegram.org

### Build

```bash
# Build TDLib first (see skill/references/install.md)

# Build tgctl
CGO_CFLAGS="-I$HOME/.local/tdlib/include" \
CGO_LDFLAGS="-L$HOME/.local/tdlib/lib -ltdjson" \
go build -o ./bin/tgctl ./cmd/tgctl/

# macOS: fix dylib path
install_name_tool -add_rpath $HOME/.local/tdlib/lib ./bin/tgctl
```

### Login

```bash
export TELEGRAM_API_ID=<your_id>
export TELEGRAM_API_HASH=<your_hash>
./bin/tgctl login
```

### Usage

```bash
tgctl [--profile <name>] <command>

Commands:
  me                             Show current user
  send <chat> <msg>              Send message
  chats [limit]                  List chats
  create-bot <name> <username>   Create bot via BotFather
  history <chat> [limit]         Chat history
  search <query>                 Search public chats
  contacts                       List contacts
  listen [--user id] [--chat id] Real-time message listener
  logout                         Logout
```

### Chat ID Format

- **Private chat**: User ID directly (auto-creates via `createPrivateChat`)
- **Group/Channel**: Add `-100` prefix (e.g. `3805592010` → `-1003805592010`)
- **@username**: Use directly (e.g. `@BotFather`)

### Multi-Account

```bash
tgctl --profile work login
tgctl --profile personal login
tgctl --profile work me
```

## Project Structure

```
go-tdlib/
├── client/           # CGO bridge (td_json_client wrapper)
├── tdapi/            # Generated types + functions (from td_api.tl)
├── cmd/
│   ├── codegen/      # Code generator (TL schema → Go)
│   └── tgctl/        # CLI tool
├── skill/            # OpenClaw skill
│   ├── SKILL.md
│   └── references/
│       └── install.md
└── go.mod
```

## Code Generation

To regenerate `tdapi/` from a new TDLib version:

```bash
go run ./cmd/codegen/ /path/to/td_api.tl ./tdapi/
```

## OpenClaw Skill

Install from [ClawHub](https://clawhub.ai/youziyouzishu/telegram-cli-tdlib):

```bash
openclaw skills install telegram-cli-tdlib
```

## Security

- Store API credentials in environment variables only
- Session data in `~/.tgctl/` contains your Telegram auth — protect it
- Never send auth codes via Telegram (will be blocked)

## License

MIT
