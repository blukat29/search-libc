dbdir=libc-database/db
outfile=app/search/static/names.js

cat $dbdir/*.symbols \
    | cut -d ' ' -f 1 \
    | sort \
    | uniq \
    | awk ' \
    BEGIN { print "var names = [" }
    { printf "\"%s\",\n", $1 }
    END   { print "];" }' \
        > $outfile
wc -l $outfile
