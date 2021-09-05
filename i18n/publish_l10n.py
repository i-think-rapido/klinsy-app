#!/usr/bin/env python3

import json
from util import *

def convert_dict(d):

    out = {}
    languages = get_all_languages(l10n)[1:]

    for k in d.keys():
        for l in languages:
            if not out.get(l):
                out[l] = {}
            out[l][k] = d[k][l]

    return out

if __name__ == '__main__':
    l10n = load('l10n.csv')

    converted = convert_dict(l10n)

    for k in converted.keys():
        with open('../lang/{}.json'.format(k), 'w') as f:
            json.dump(converted[k], f)
