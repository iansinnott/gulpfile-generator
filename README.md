# Gulpfile Generator

#### A simple ruby script to generate a gulpfile for compiling Sass stylesheets.

Gulp.js can be used for many things. This script only sets up a base gulpfile.js and installs all the packages necessary for super fast Sass compilation through node-sass. You should check out the Gulp.js Homepage for info on the project itself.

## Install

1. Clone the repo: `git clone this repo`
2. Link the file: `ln -sh path/to/gulpgen.rb /usr/local/bin/gulpgen`

After linking, you will probably have to restart your terminal window to access the `gulpgen` command in your path. 

## Commands

There are only two

- `gulpgen`: Generates a gulpfile.js and installs the necessary node modules. Also creates package.json if not found.
- `gulpgen implode`: Remove the packages installed by this script as well as the generated gulpfile.js. package.json will not be removed in case you already had one installed.

## Uninstall

1. Remove the git repo from wherever you cloned it to.
2. In terminal: `rm /usr/local/bin/gulpgen`. If you linked the binary to somewhere else in your path, you should remove the link there instead.
