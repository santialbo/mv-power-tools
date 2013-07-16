# Module definitions
MODULE_FILES = main settings-panel shortcuts infinite-scrolling author-enhancements extended-reply-form live-preview
MODULE_DIR = ./modules/
MODULES = $(addsuffix .coffee, $(addprefix $(MODULE_DIR), $(MODULE_FILES)))
CSS = $(addsuffix .css, $(addprefix $(MODULE_DIR), $(MODULE_FILES)))

# Build options
FILE_OUT = mv-power-tools.user.js
CSS_OUT = mv-power-tools.css
DEV_DIR = ./debug

DEV_OPTIONS = --compile --join $(DEV_DIR)/$(FILE_OUT)
CSS_OPTIONS = --keep-line-breaks --output $(DEV_DIR)/$(CSS_OUT)

# Extension bundling options
FIREFOX_OUT = Firefox/resources/mv-power-tools/data/
CHROME_OUT = Chrome/

# Rules
.PHONY=all dev watch-coffee

all: dev

watch-coffee: $(MODULES)
	coffee --watch $(DEV_OPTIONS) $(MODULES)

dev: $(MODULES)
	coffee $(DEV_OPTIONS) $(MODULES) 
	cat $(CSS) | cleancss $(CSS_OPTIONS)
	cp $(DEV_DIR)/$(FILE_OUT) $(DEV_DIR)/$(FIREFOX_OUT)
	rm -f $(DEV_DIR)/mv-power-tools.xpi
	cd $(DEV_DIR)/Firefox/; zip -9 -r mv-power-tools.xpi .
	cp $(DEV_DIR)/$(FILE_OUT) $(DEV_DIR)/$(CHROME_OUT)
