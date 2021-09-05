#/bin/bash

echo '"base","en"' > base.csv

find .. -name '*.dart' | xargs egrep -o "trans\(context, '[^']+'\)" | cut -d: -f2 | cut -c17- | sed -r "s\$'\)\$\$" | sort | uniq | sed -r 's/(.*)/"\1","\1"/' >> base.csv
