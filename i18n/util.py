
import csv

def dict_merge(source, destination):

    for key, value in source.items():
        if isinstance(value, dict):
            # get node or create one
            node = destination.setdefault(key, {})
            dict_merge(value, node)
        else:
            destination[key] = value

    return destination

def get_all_languages(d):
    return list(d[list(d.keys())[0]].keys())

def load(filename):
    with open(filename) as f:
        content = csv.reader(f, quotechar='"')

        data = {}
        languages = []
        for idx, row in enumerate(content):
            if idx == 0:
                languages = row
                continue

            result = dict(zip(languages, row))
            result['en'] = result['base']
            data[row[0]] = result

    return data

