# Fresh: a responsive Pelican theme that uses HTML5

Fresh is a responsive [Pelican](http://getpelican.com) theme.
This theme uses HTML5 and its layout is responsive -- thanks to [Smashing HTML5](http://coding.smashingmagazine.com/2009/08/04/designing-a-html-5-layout-from-scratch/) and [Twitter Bootstrap](http://twitter.github.com/bootstrap/).

You can watch a live demo for the Fresh theme [here](http://jsliang.com/pelican-fresh-demo/blog/).

**Note**

Make sure not to set the ``RELATIVE_URLS`` global varibles to `True` (the default value is `False`) so that Facebook meta tags and canonical links are generated correctly.

## Features

*   Google Analytics
*   DISQUS comment system
*   Custom link lists
*   Social widgets
*   "Fork me on GitHub" ribbon
*   **Google Custom Search Engine** -- use this as your search bar!
*   **Hide categories from menu**
*   Syntax highlighting for code blocks
*   ShareThis

## Settings

The Fresh theme supports most built-in global variables of Pelican. There are also theme-specific global variables that allow you to add a search bar or to hide categories from menu.

### Built-in Global Variables

The theme supports most Pelican built-in global variables, and some of them are listed below.

*   `GOOGLE_ANALYTICS`
*   `DISQUS_SITENAME`
*   `LINKS = (('name1', 'url1'), ('name2', 'url2'))`
*   `SOCIAL = (('name1', 'url1'), ('name2', 'url2'))`
*   `GITHUB_URL`

Refer to [Pelican's documentation of settings](http://docs.getpelican.com/en/latest/settings.html) for description of these global variables.

### Theme-specific Global Variables

The theme also provides these global variables:

*   `GOOGLE_CUSTOM_SEARCH = 'your search engine unique ID'`

    The Fresh theme allows you to use [Google Custom Search Engine](http://www.google.com/cse/) as the search engine for your static website.

    Find the **search engine unique ID** of your customized search engine in Google Custom Search Engine's [control panel](http://www.google.com/cse/manage/all).
    Assign this ID to the `GOOGLE_CUSTOM_SEARCH` variable in your configuration, and a Google custom search bar will appear in the navigation bar.

*   `HIDE_CATEGORIES_FROM_MENU = True`

    If you want to hide categories from menu, you can do so by setting `HIDE_CATEGORIES_FROM_MENU` to `True` in your configuration.

*   `SHARETHIS_PUB_KEY = 'your ShareThis Pub Key'`

    The Fresh theme allows you to use [ShareThis](http://www.sharethis.com/) for social plugins.

    Find the **Pub Key** of your ShareThis Account in ShareThis's [Account Dashboard](http://www.sharethis.com/account/). Assign this ID to the `SHARETHIS_PUB_KEY` variable in your configuration, and two rows of social plugin buttons will appear before and after your article respectively.


## License

Copyright (c) 2013, Jui-Shan Liang &lt;jenny@jsliang.com&gt;

All rights reserved.

Licensed under GPL v2.
