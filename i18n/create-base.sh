#/bin/bash

echo '"base","en"' > base.csv

find .. -name '*.dart' | xargs egrep -ho "trans\(context, '[^']+'\)" | cut -c17- | sed -r "s\$'\)\$\$" | sort | uniq | sed -r 's/(.*)/"\1","\1"/' >> base.csv

./merge-base-l10n.py

