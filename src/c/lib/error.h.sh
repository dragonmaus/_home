#!/bin/sh

echo() { printf '%s\n' "$*"; }

echo '/* automatically generated */'
echo '#ifndef ERROR_H'
echo '#define ERROR_H'
echo
echo '#ifndef errno'
echo 'extern int *__errno_location(void);'
echo '#define errno (*__errno_location())'
echo '#endif'
echo
while read -r name errno temp str
do
  [[ $name = - ]] && continue
  echo "extern int $name;"
done <error.list
echo
echo 'extern const char * error_str(int);'
echo 'extern unsigned int error_temp(int);'
echo
echo '#endif'
