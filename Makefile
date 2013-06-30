# Module definitions
MODULE_FILES = header.js main.js shortcuts.js
MODULE_DIR = ./modules/
MODULES = $(addprefix $(MODULE_DIR), $(MODULE_FILES))

# Build options
FILE_OUT = mv-power-tools.user.js
DEV_DIR = ./debug
BUILD_DIR = ./build

KEEP_COMMENTS = --comments all
DEV_OPTIONS = --screw-ie8 --lint --beautify $(KEEP_COMMENTS) --output $(DEV_DIR)/$(FILE_OUT)
BUILD_OPTIONS = --screw-ie8 --compress --mangle $(KEEP_COMMENTS) --output $(BUILD_DIR)/$(FILE_OUT)

# Extension bundling options
FIREFOX_OUT = Firefox/resources/mv-power-tools/data/
CHROME_OUT = Chrome/

# Rules
.PHONY=all dev

all: dev

dev: $(MODULES)
	uglifyjs $(MODULES) $(DEV_OPTIONS)
	cp $(DEV_DIR)/$(FILE_OUT) $(DEV_DIR)/$(FIREFOX_OUT)
	rm -f $(DEV_DIR)/mv-power-tools.xpi
	cd $(DEV_DIR)/Firefox/; zip -9 -r mv-power-tools.xpi .
	mv $(DEV_DIR)/Firefox/mv-power-tools.xpi $(DEV_DIR)
	cp $(DEV_DIR)/$(FILE_OUT) $(DEV_DIR)/$(CHROME_OUT)

$(BUILD_DIR)/$(FILE_OUT): $(MODULES)
	uglifyjs $(MODULES) $(OPTIONS)
