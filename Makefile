.PHONY: all
all: install

.PHONY: format
format: tmp/format_py

.PHONY: install update ref gz
install:
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:
