# Makefile as a Deployment Tool
#
# Docs and examples:
#	http://www.gnu.org/software/make/manual/make.html
#	https://cbednarski.com/articles/makefiles-for-everyone/
#	https://github.com/njh/easyrdf/blob/master/Makefile

# Init
PHP := $(shell which php)
PHPDBG := $(shell which phpdbg)
COMPOSER := $(shell which composer)
NPM := $(shell which npm)
BOWER := $(shell which bower)
SASS := $(shell which node-sass)
POSTCSS := $(shell which postcss)
UGLIFYCSS := $(shell which uglifycss)
UGLIFYJS := $(shell which uglifyjs)

ifndef PHP
$(error PHP not found)
endif

.DEFAULT: help
all: help

# TARGET:install            Install utilities (NodeJS + NPM required)
.PHONY: install
install:
	$(info ... Installing utilities)
	$(NPM) install -g bower
	$(NPM) install -g node-sass
	$(NPM) install -g postcss-cli
	$(NPM) install -g autoprefixer
	$(NPM) install -g uglifycss
	$(NPM) install -g uglify-js
	$(NPM) install -g jshint

# TARGET:update             Update assets & dependencies
.PHONY: update
update:
	$(info ... Updating assets & dependencies)
	$(BOWER) update
	$(COMPOSER) update

# TARGET:clean              Clean up before building
.PHONY: clean
clean:
	$(info ... Cleaning up)
	rm -rf data/build
	rm -rf public/assets/*

# TARGET:build              Build assets
.PHONY: build
build: clean
	$(info ... Building assets)
	mkdir -p data/build
	mkdir -p public/assets/css
	mkdir -p public/assets/fonts
	mkdir -p public/assets/img
	mkdir -p public/assets/js
	$(UGLIFYJS) bower_components/prism/components/prism-core.js \
				bower_components/prism/components/prism-markup.js \
				bower_components/prism/components/prism-css.js \
				bower_components/prism/components/prism-clike.js \
				bower_components/prism/components/prism-javascript.js \
				bower_components/prism/components/prism-apacheconf.js \
				bower_components/prism/components/prism-bash.js \
				bower_components/prism/components/prism-batch.js \
				bower_components/prism/components/prism-css-extras.js \
				bower_components/prism/components/prism-git.js \
				bower_components/prism/components/prism-nginx.js \
				bower_components/prism/components/prism-php.js \
				bower_components/prism/components/prism-scss.js \
				bower_components/prism/components/prism-sql.js \
				bower_components/prism/components/prism-twig.js \
				bower_components/prism/components/prism-yaml.js \
	            --compress --mangle --output public/assets/js/core.min.js
	$(SASS) resources/public/scss/core.scss data/build/core.css
	$(POSTCSS) --use autoprefixer --autoprefixer.browsers "last 2 versions" \
	           --output data/build/core.prefixed.css data/build/core.css
	$(UGLIFYCSS) data/build/core.prefixed.css > public/assets/css/core.min.css
	cp bower_components/font-awesome/fonts/* public/assets/fonts/
	cp resources/public/img/* public/assets/img/

# TARGET:fix                Run PHP Code Beautifier and Fixer
.PHONY: fix
fix:
	$(info ... Fixing code)
	$(PHP) vendor/squizlabs/php_codesniffer/scripts/phpcbf

# TARGET:test               Run unit tests
.PHONY: test
test:
	$(info ... Running tests)
	$(PHP) vendor/squizlabs/php_codesniffer/scripts/phpcs
	$(PHP) vendor/phpunit/phpunit/phpunit

# TARGET:coverage           Generate code coverage report
.PHONY: coverage
coverage:
	$(info ... Generating code coverage report)
	rm -rf data/phpunit
	$(PHPDBG) -qrr vendor/phpunit/phpunit/phpunit --coverage-html ./data/phpunit

# TARGET:debug              List all variables and other debug info
.PHONY: debug
debug:
	$(info PHP          $(PHP))
	$(info PHPDBG       $(PHPDBG))
	$(info COMPOSER     $(COMPOSER))
	$(info BOWER        $(BOWER))
	$(info SASS         $(SASS))
	$(info POSTCSS      $(POSTCSS))
	$(info UGLIFYCSS    $(UGLIFYCSS))
	$(info UGLIFYJS     $(UGLIFYJS))

# TARGET:help               You're looking at it!
.PHONY: help
help:
	# Usage:
	#   make <target> [OPTION=value]
	#
	# Targets:
	@egrep "^# TARGET:" [Mm]akefile | sed 's/^# TARGET:/#   /'
	#
	# Options:
	#   PHP            Path to php
