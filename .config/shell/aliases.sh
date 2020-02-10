alias lc='ls -C'
alias ll='ls -Fl'

case "$( uname )" in
(OpenBSD)
	alias ls='ls -1A'
	;;
(*)
	alias ls='ls -1AN --color=auto'
	alias pstree='pstree -achlnp'
	;;
esac

for c in doas sudo
do
	which $c > /dev/null 2>&1 && alias $i="$i "
done
unset c
