#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Tom'
SITENAME = 'Tom\'s Writing'
SITEURL = ''
THEME = "themes/fresh"

PATH = 'content'

TIMEZONE = 'America/Chicago'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

#PAGE_PATH = ['pages']
#DISPLAY_PAGES_ON_MENU = False
#MENUITEMS = (
#    ('Homepage', 'https://teeks99.com')
#)

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

DEFAULT_PAGINATION = False
#INDEX_SAVE_AS = 'posts_index.html'

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.tables':{},
        'markdown.extensions.fenced_code':{},
        'markdown.extensions.codehilite':{},
    }
}
