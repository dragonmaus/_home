redo-ifchange ~/etc/secret/digitalblasphemy.netrc "$2.headers"

uri=https://secure.digitalblasphemy.com/content/zips
curl -Rs -o "$3" --netrc-file ~/etc/secret/digitalblasphemy.netrc "$uri/$2.zip"
