# her-data

## load data
activate your virtual environment, then run:
```
./load_data.sh
```

it will prompt you for a path to your arches repo (path can be relative)

be sure to run the script from the root folder of this repo

## configuration

here are some application settings you'll probably want to use (add to your `settings_local.py`):
```
SEARCH_ITEMS_PER_PAGE = 15
SEARCH_EXPORT_ITEMS_PER_PAGE = 100000
SEARCH_DROPDOWN_LENGTH = 100
WORDS_PER_SEARCH_TERM = 10

CLUSTER_DISTANCE = 8
CLUSTER_MAX_ZOOM = 5
CLUSTER_MIN_POINTS = 5

HEX_BIN_BOUNDS = (-0.6222,53.18,-0.4925,53.3)
HEX_BIN_SIZE = 0.20
HEX_BIN_PRECISION = 8
```
