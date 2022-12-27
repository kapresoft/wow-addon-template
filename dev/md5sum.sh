#!/usr/bin/env bash
_md5sum()
{
  local file=$1
  local sum
  sum="$(md5sum $file | awk '{split($0,a); print a[1]}')"
  echo "${sum}"
}

_md5sum $1

