# Module definitions
MODULE_FILES = main.coffee extended-reply-form.coffee # shortcuts.js author-enhancements.js infinite-scrolling.js live-preview.js
MODULE_DIR = ./modules/
MODULES = $(addprefix $(MODULE_DIR), $(MODULE_FILES))

# Build options
FILE_OUT = mv-power-tools.user.js
DEV_DIR = ./debug

DEV_OPTIONS = --compile --join $(DEV_DIR)/$(FILE_OUT)

# Extension bundling options
FIREFOX_OUT = Firefox/resources/mv-power-tools/data/
CHROME_OUT = Chrome/

# Rules
.PHONY=all dev

all: dev

dev: $(MODULES)
	coffee $(DEV_OPTIONS) $(MODULES) 
	cp $(DEV_DIR)/$(FILE_OUT) $(DEV_DIR)/$(FIREFOX_OUT)
	rm -f $(DEV_DIR)/mv-power-tools.xpi
	cd $(DEV_DIR)/Firefox/; zip -9 -r mv-power-tools.xpi .
	cp $(DEV_DIR)/$(FILE_OUT) $(DEV_DIR)/$(CHROME_OUT)
