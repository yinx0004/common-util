GO := go
ROOT_PACKAGE := github.com/yinx0004/common-util
ifeq ($(origin ROOT_DIR), undefined)
ROOT_DIR := $(shell pwd)
endif

# Linux command settings
FIND := find . ! -path './third_party/*' ! -path './vendor/*'
XARGS := xargs --no-run-if-empty

all: test format lint

## test: test the package
.PHONY: test
test:
		@echo "===========> Testing packages"
		@$(GO) test $(ROOT_PACKAGE)/...

.PHONY: goimports.install
goimports.install:
ifeq (,$(shell which goimports 2>/dev/null))
	@echo "==========> Installing goimports"
	@$(GO) install golang.org/x/tools/cmd/goimports@latest
endif

.PHONY: golines.install
golines.install:
ifeq (,$(shell which golines 2>/dev/null))
	@echo "===========> Installing golines"
	@$(GO) install github.com/segmentio/golines@latest
endif

## format: Format the package with `gofmt`
.PHONY: format
format: golines.install goimports.install
	@echo "===========> Formating codes"
	 @$(FIND) -type f -name '*.go' | $(XARGS) gofmt -s -w
	 @$(FIND) -type f -name '*.go' | $(XARGS) goimports -w -local $(ROOT_PACKAGE)
	 @$(FIND) -type f -name '*.go' | $(XARGS) golines -w --max-len=120 --reformat-tags --shorten-comments --ignore-generated .

.PHONY: lint.verify
lint.install:
ifeq (,$(shell which golangci-lint 2>/dev/null))
		@echo "===========> Installing golangci lint"
		@$(GO) install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.61.0
endif

## lint: Check syntax and styling of go sources.
.PHONY: lint
lint: lint.install
		@echo "===========> Run golang-lint"
		@golangci-lint run $(ROOT_DIR)/...

.PHONY: go-mod-outdated.install
go-mod-outdated.install:
ifeq (,$(shell which go-mod-outdated 2>/dev/null))
	@echo "===========> Installing go-mod-outdated"
	@$(GO) install github.com/psampaz/go-mod-outdated@latest
endif

## check-updates: Check outdated dependencies of the go projects.
.PHONY: check-updates
check-updates: go-mod-outdated.install
	@$(GO) list -u -m -json all | go-mod-outdated -update -direct

## help: Show this help info.
.PHONY: help
help: Makefile
	@echo -e "\nUsage: make <TARGETS> ...\n\nTargets:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo "$$USAGE_OPTIONS"