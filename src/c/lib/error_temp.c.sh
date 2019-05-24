#!/bin/sh

echo() { printf '%s\n' "$*"; }

echo '/* automatically generated */'
echo '#include <errno.h>'
echo '#include "error.h"'
echo
echo '#define X(n) if (e == n) return 1'
echo
echo '  unsigned int'
echo 'error_temp(int e)'
echo '{'
while read -r name errno temp str
do
  [[ $temp = soft ]] || continue
  if [[ $name = - ]]
  then
    echo "#ifdef $errno"
    echo "  X($errno);"
    echo "#endif"
  else
    echo "  X($name);"
  fi
done <error.list
echo '  return 0;'
echo '}'
