#!/bin/sh

usage() {
cat <<USAGE
 USAGE: gittar name
        gittar ( tar | tgz | tbz | tar.gz | tar.bz2 )

  In the first form, output the name the package would be assigned. In second
  form, prepare an archive of the package in the desired format.

USAGE
}

archiver() {
  case "$1" in
    tar)            echo cat ;;
    tbz)            echo bzip2 ;;
    tar.bz2)        echo bzip2 ;;
    tgz)            echo gzip ;;
    tar.gz)         echo gzip ;;
  esac
}

root() {
  relative_path_to_git_file=`git rev-parse --git-dir`
  working_dir=`dirname "$relative_path_to_git_file"`
  cd "$working_dir"
  pwd
}

version() {
  v="-`git describe`"
  [ $? = 0 ] && echo "$v"
}

name() {
  r=`root`
  project_name=`basename "$r"`
  echo "$project_name`version 2>/dev/null`"
}

archive() {
  r=`root`
  n=`name`
  t="$n.$1"
  echo "Creating archive." 1>&2
  echo $t
  git archive HEAD --prefix="$n"/ | `archiver $1` > $t
}


case "$1" in
  -h|'-?'|--help)   usage ; exit 0 ;;
  name)             name ;;
  *)                case `archiver "$1"` in
                      '')       (echo "Input error." ; usage) 1>&2 ; exit 2 ;;
                      *)        archive $1 ;;
                    esac ;;
esac

