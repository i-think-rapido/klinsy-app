#!/usr/bin/env python3

from util import *

def merge(base, l10n):

    all_base_languages = set(get_all_languages(base))
    all_l10n_languages = set(get_all_languages(l10n))

    missing_languages = list(all_l10n_languages - all_base_languages)
    missing = {}
    for m in missing_languages:
        missing[m] = ""

    out = {}
    keys = list(base.keys())
    keys.sort()
    for key in keys:

        base_translations = base[key]
        l10n_translations = l10n.get(key)

        if not l10n_translations:
            out[key] = dict_merge(missing, base_translations)
        else:
            out[key] = dict_merge(l10n_translations, base_translations)

    rest_keys = list(set(list(l10n.keys())) - set(list(base.keys())))

    for key in rest_keys:
        out[key] = l10n[key]

    return out

def save(merged, filename):

    lines = []

    header = get_all_languages(merged)
    alt_languages = list(set(header) - set(['base', 'en']))
    if (len(alt_languages) > 0):
        lines.append('"base","en","{}"'.format('","'.join(alt_languages)))
    else:
        lines.append('"base","en"')

    keys = list(merged.keys())
    keys.sort()
    for key in keys:
        row = merged[key]
        line = [row['base'], row['en']]
        for l in alt_languages:
            line.append(row[l])
        lines.append('"{}"'.format('","'.join(line)))

    with open(filename, mode='w') as f:
        f.writelines(map(lambda x : x + "\n", lines))


if __name__ == '__main__':

    base = load('base.csv')
    l10n = load('l10n.csv')

    merged = merge(base, l10n)

    save(merged, 'l10n.csv.csv')
