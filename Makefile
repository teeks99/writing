PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

GH_OUTDIR=$(BASEDIR)/gh-output
GH_PUBLISHCONF=$(BASEDIR)/gh-conf.py

FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

S3_BUCKET=my_s3_bucket

CLOUDFILES_USERNAME=my_rackspace_username
CLOUDFILES_API_KEY=my_rackspace_api_key
CLOUDFILES_CONTAINER=my_cloudfiles_container

DROPBOX_DIR=~/Dropbox/Public/

GITHUB_PAGES_BRANCH=gh-pages

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          start/restart develop_server.sh    '
	@echo '   make stopserver                     stop local server                  '
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '   make venv                           setup local pelican venv           '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html: venv
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	[ ! -d $(GH_OUTDIR) ] || rm -rf $(GH_OUTDIR)
	[ ! -d .venv ] || rm -rf .venv

regenerate: venv
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve: venv
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

serve-global: venv
ifdef SERVER
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 $(SERVER)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 0.0.0.0
endif


devserver: venv
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver: venv
	$(BASEDIR)/develop_server.sh stop
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

publish: venv
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)

github: venv
	$(PELICAN) $(INPUTDIR) -o $(GH_OUTDIR) -s $(GH_PUBLISHCONF) $(PELICANOPTS)
	ghp-import -m "Generate Pelican site" -b $(GITHUB_PAGES_BRANCH) $(GH_OUTDIR)
	git push origin $(GITHUB_PAGES_BRANCH)

venv: .venv/bin/activate

.venv/bin/activate: requirements.txt
	test -d .venv || virtualenv -p python3 .venv
	. .venv/bin/activate; pip install -Ur requirements.txt
	touch .venv/bin/activate

.PHONY: html help clean regenerate serve serve-global devserver stopserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github
