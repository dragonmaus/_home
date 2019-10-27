#!/bin/mksh
set -e

conf="$HOME/etc/wallpaper"
dest="$HOME/Pictures/Wallpapers"
dist="$HOME/Downloads"
temp="$HOME/tmp/wallpaper"

cat "$conf/res.list" |&

while read -pr res suf
do
	zip="$dist/$res.zip"
	[[ -e "$zip" ]] || continue
	dir="$dest/$res/digitalblasphemy"
	mkdir -p "$dir"
	find "$dir" -type f -print0 | xargs -0r chmod =rwx
	rm -fr "$temp"
	mkdir -p "$temp"
	(
		cd "$temp"
		7z x "$zip"
		find . -type f -print0 | xargs -0r chmod =rw
		sed "s/\$/$suf.jpg/" <"$conf/black.list" | xargs -r rm -f 2>/dev/null || :
		sed "s/\$/$suf.jpg/" <"$conf/white.list" | xargs -r mv -f -t "$dir" 2>/dev/null || :
		for file in *"$suf.jpg"
		do
			[[ -e "$file" ]] || continue
			name="${file%"$suf.jpg"}"
			pid=
			if [[ -n "$DISPLAY" ]]
			then
				feh -. "$file" 2> /dev/null &
				pid="$!"
			fi
			while :
			do
				print -nr "Keep '$name'? (y/n): " 1>&2
				read -r keep
				case "$keep" in
				([Yy]*)
					mv -fv "$file" "$dir"
					print -r -- "$name" >>"$conf/white.list{tmp}"
					break
					;;
				([Nn]*)
					rm -fv "$file"
					print -r -- "$name" >>"$conf/black.list{tmp}"
					break
					;;
				esac
			done
			[[ -n "$pid" ]] && kill "$pid" || :
		done
	)
	rm -fr "$temp"
	find "$dir" -type f -perm /0111 -print0 | xargs -0r rm -fv
	for i in black white
	do
		list="$conf/$i.list"
		if [[ -e "$list{tmp}" ]]
		then
			cat "$list" "$list{tmp}" | sort -u >"$list{new}"
			rm -f "$list{tmp}"
			diff -u "$list" "$list{new}" | cdiff
			mv -fv "$list{new}" "$list"
		fi
	done
done
