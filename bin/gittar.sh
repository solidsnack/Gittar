#!/bin/sh

usage() {
cat <<USAGE
 USAGE: $0 ( name | tar | tgz | tbz )

  Prepare a tarball of the repository with the name set by the latest tag and
  the number of revisions since that tag.

USAGE
}

root() {
  relative_path_to_root=`git rev-parse --git-dir`
  cd "$relative_path_to_root"
}

name() {
  root
  p=`pwd`
  project_name=`dirname $p`
  v=`git describe`
  echo "$project_name-$v"
}

tar() {
  root
  n=`name`
  git-archive HEAD --prefix="$n"/
}

tbz() {
  tar | bzip2
}

tgz() {
  tar | gzip
}


case "$1" in
  -h|-?|--help)                 usage ; exit 0 ;;
  name|tar|tbz|tgz)             $1 ;;
  *)                            (echo "Input error." ; usage) 1>&2 ; exit 2 ;;
esac


