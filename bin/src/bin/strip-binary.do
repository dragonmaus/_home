redo-always
which sstrip strip 2> /dev/null | head -1 > "$3"
redo-stamp < "$3"
