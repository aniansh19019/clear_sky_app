import urllib.request
import json
import math


KEY = 'Bk1NEzLKtAp8ZLFAfjnohGxbb0w8ATQn'
BASE_URL_HOURLY = 'https://api.weatherbit.io/v2.0/forecast/hourly'


LAT = "28.416"
LONG = "77.840"


def get_data():
    data = None
    request = f'{BASE_URL_HOURLY}?lat={LAT}&lon={LONG}&key={KEY}'
    print(request)

    data = urllib.request.urlopen(request)
    data = data.read()

    data_dict = json.loads(data)
    print(data_dict)


get_data()
