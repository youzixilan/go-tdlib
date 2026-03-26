TDLIB_PREFIX ?= $(HOME)/.local/tdlib
CGO_CFLAGS := -I$(TDLIB_PREFIX)/include
CGO_LDFLAGS := -L$(TDLIB_PREFIX)/lib -ltdjson
BINARY := ./bin/tgctl

.PHONY: build install clean codegen publish-skill

build:
	CGO_CFLAGS="$(CGO_CFLAGS)" CGO_LDFLAGS="$(CGO_LDFLAGS)" go build -o $(BINARY) ./cmd/tgctl/
	@if [ "$$(uname)" = "Darwin" ]; then install_name_tool -add_rpath $(TDLIB_PREFIX)/lib $(BINARY) 2>/dev/null || true; fi
	@echo "Built $(BINARY)"

install: build
	cp $(BINARY) /usr/local/bin/tgctl || cp $(BINARY) $(HOME)/.local/bin/tgctl
	@echo "Installed tgctl"

clean:
	rm -f $(BINARY)

codegen:
	go run ./cmd/codegen/ $(TDLIB_PREFIX)/../td/td/generate/scheme/td_api.tl ./tdapi/
	@echo "Code generation complete"

publish-skill:
	clawhub publish ./skill --slug telegram-cli-tdlib --name "Telegram CLI (TDLib)" --tags latest
