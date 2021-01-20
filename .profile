# ~/.profile
# User-specific login shell profile

# Enforce `separation of concerns' between login and interactive shells
shell=$(basename "$SHELL")
: ${shell:=sh}
case $- in
(*i*)
	exec $shell -l -c 'exec $shell -i "$@"' $shell "$@"
	;;
esac

# Ask if X should be started
startx=
if command -v startx > /dev/null 2>&1
then
	case $(tty) in
	(/dev/tty*)
		echo -n 'Start X? (y/n): ' 1>&2
		read reply || echo n 1>&2
		case "$reply" in
		([Yy]*)
			startx='exec startx'
			;;
		esac
		;;
	esac
fi

# XDG directories
CONF=${XDG_CONFIG_HOME:-~/.config}
DATA=${XDG_DATA_HOME:-~/.local/share}

# Clean up and augment PATH
path=
ifs=$IFS
IFS=:
for d in ~/bin ~/sbin ~/.cargo/bin ~/.local/bin $PATH
do
	d=$(readlink -f $d 2> /dev/null || echo $d)
	case ":$path:" in
	(*:$d:*)
		continue
		;;
	esac
	path=$path:$d
done
IFS=$ifs
path=${path#:}

# Set environment
set -a

## Paths
MANPATH=$DATA/man:$MANPATH
PATH=$path

## Shell configuration
ENV=~/.shrc

## Global configuration
EDITOR=nvim
HOSTNAME=${HOSTNAME:-$(hostname -s)}
PAGER=less

## X keyboard configuration
XKB_DEFAULT_LAYOUT=us
XKB_DEFAULT_MODEL=pc105
XKB_DEFAULT_OPTIONS=compose:paus
XKB_DEFAULT_VARIANT=dvorak
XKB_INTERNAL_OPTIONS='compose:paus ctrl:nocaps'

## App-specific configuration
GPG_TTY=$(tty)
LESS=FMRXi
LESSHISTFILE=-
PASSWORD_STORE_DIR=~/.password-store
PASSWORD_STORE_KEY=$(cat ~/etc/secret/encryption.key)
PASSWORD_STORE_SIGNING_KEY=$(cat ~/etc/secret/signing.key)
RIPGREP_CONFIG_PATH=$CONF/ripgrep.conf

set +a

# SSH agent
[[ -f ~/.ssh/agent.sh ]] && . ~/.ssh/agent.sh

# Update SSH environment
f=~/.ssh/environment
rm -f $f{new}
grep -v '^PATH=' < $f > $f{new}
echo "PATH=$PATH" >> $f{new}
mv -f $f{new} $f

# Hand off to X if requested
$startx
