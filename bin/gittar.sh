#!/bin/sh

usage() {
cat <<USAGE
 USAGE: $0 ( name | tgz | tbz )

  Prepare a tarball of the repository with the name set by the latest tag and
  the number of revisions since that tag.

USAGE
}

root() {
  relative_path_to_git_file=`git rev-parse --git-dir`
  working_dir=`dirname "$relative_path_to_git_file"`
  cd "$working_dir"
  pwd
}

name() {
  r=`root`
  v=`git describe`
  project_name=`basename "$r"`
  echo "$project_name-$v"
}

archive() {
  r=`root`
  n=`name`
  t="$n.$1"
  case "$1" in
    tbz)            archiver=bzip2;;
    tgz)            archiver=gzip;;
  esac
  echo "Creating archive:" 1>&2
  echo $t
  git archive HEAD --prefix="$n"/ | $archiver > $t
}


case "$1" in
  -h|-?|--help)     usage ; exit 0 ;;
  name)             name ;;
  tgz|tbz)          archive $1 ;;
  *)                (echo "Input error." ; usage) 1>&2 ; exit 2 ;;
esac




