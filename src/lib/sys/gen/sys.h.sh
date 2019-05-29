#!/bin/sh

echo() { printf '%s\n' "$*"; }

echo '#ifndef SYS_H'
echo '#define SYS_H'

if [[ -r sys.h.pre ]]
then
	echo
	cat sys.h.pre
fi

echo
while read -r number name prototype
do
	echo "$prototype"
	if [[ $number = - ]]
	then
		continue
	fi
	{
		echo 'format	elf64'
		echo
		echo "section	'.text' executable"
		echo
		echo "public	$name"
		echo
		echo "$name:"
		echo "	mov	eax, $number		; syscall $name"
		echo '	syscall'
		echo '	ret'
	} >$name.asm.new
	cmp -s $name.asm.new $name.asm || mv -f $name.asm.new $name.asm
	rm -f $name.asm.new
done <sys.h.list

if [[ -r sys.h.post ]]
then
	echo
	cat sys.h.post
fi

echo
echo '#endif'