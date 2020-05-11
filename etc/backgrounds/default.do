redo-ifchange "$2.suffix" "$2.zip"

home=$(env - PATH="$PATH" pwd)

dest=$(xdg-user-dir BACKGROUNDS)/$2/digitalblasphemy
file=$home/$2.zip
suff=$(head -1 < "$2.suffix")
temp=$(env TMPDIR=$HOME/tmp mktemp -d)

trap -- "rm -fr '$temp'" EXIT INT KILL

mkdir -p "$dest"
find "$dest" -type f -exec chmod =rwx {} +

(
  cd "$temp"
  7z x "$file" > /dev/null
  find . -type f -exec chmod =rw {} +

  sed "s/\$/$suff.jpg/" < "$home/black.list" | xargs rm -f 2> /dev/null || :
  sed "s/\$/$suff.jpg/" < "$home/white.list" | xargs mv -f -t "$dest" 2> /dev/null || :

  for file in *"$suff.jpg"
  do
    test -f "$file" || continue
    name=${file%"$suff.jpg"}
    pid=
    if test "x$DISPLAY" != x
    then
      feh -. "$file" 2> /dev/null &
      pid=$!
    fi
    while :
    do
      printf "Keep '%s'? (y/n): " "$name" > /dev/tty
      read -r keep < /dev/tty
      case "$keep" in
      ([Yy]*)
        mv -f "$file" "$dest"
        echo "$name" >> "$home/white.list{tmp}"
        break
        ;;
      ([Nn]*)
        rm -f "$file"
        echo "$name" >> "$home/black.list{tmp}"
        break
        ;;
      esac
    done
    test "x$pid" = x || kill "$pid" 2> /dev/null || :
  done
)

find "$dest" -type f -perm /0111 -delete

for i in black white
do
  file=$home/$i.list
  if test -f "$file{tmp}"
  then
    cat "$file" "$file{tmp}" | sort -u > "$file{new}"
    cmp -s "$file" "$file{new}" || mv -f "$file{new}" "$file"
    rm -f "$file{new}" "$file{tmp}"
  fi
done