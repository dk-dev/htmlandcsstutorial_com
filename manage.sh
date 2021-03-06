#!/bin/bash
BASE="$(cd `dirname "$0"` && pwd)"

main () {
  local cmd="$1"
  case $cmd in
    'setup')
      shift
      setup "$@"
      ;;
    'build')
      shift
      build "$@"
      ;;
    'devserver')
      shift
      devserver "$@"
      ;;
    'clean')
      shift
      clean "$@"
      ;;
    * )
      echo "
Exiting without running any operations.
Possible operations include:

  setup - Install dependencies.
    Usage: ./manage.sh setup

  build - Build static content.
    Usage: ./manage.sh build

  devserver - Run the deverserver for local development.
    Usage: ./manage.sh devserver

  clean - Remove everything generated by this script.
    Usage: ./manage.sh clean
            "
      ;;
  esac
}

setup () {
  if ! [ -d "$BASE/node_modules" ]; then
    cd "$BASE/"
    mkdir "$BASE/node_modules"
    npm install ecstatic@0.4.13
    npm install coffee-script@1.7.1
  fi
  if ! [ -d "$BASE/scripts/node_modules" ]; then
    cd "$BASE/scripts/"
    mkdir "$BASE/scripts/node_modules"
    npm install filepath@0.2.1
    npm install marked@0.3.2
    npm install swig@1.3.2
    npm install request@2.34.0
    cd "$BASE"
  fi
}

build () {
  setup
  node scripts/gstatic.js "$BASE/content/" "$BASE/templates/" "$BASE/public/"
}

devserver () {
  setup
  bin/devserver
}

clean () {
  rm -rf "$BASE/node_modules/"
  rm -rf "$BASE/scripts/node_modules/"
}

main "$@"
