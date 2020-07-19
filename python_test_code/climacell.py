import urllib.request
import json
import math


KEY = 'Bk1NEzLKtAp8ZLFAfjnohGxbb0w8ATQn'
BASE_URL_HOURLY = 'https://api.climacell.co/v3/weather/forecast/hourly'
START_TIME = 'now'

FIELDS = 'cloud_cover'

LAT = "28.416"
LONG = "77.840"


def get_data():
    data = None
    request = f'{BASE_URL_HOURLY}?lat={LAT}&lon={LONG}&start_time=now&fields={FIELDS}&unit_system=si&apikey={KEY}'
    # request = 'https://api.climacell.co/v3/weather/forecast/hourly?lat=28.416&lon=77.84&start_time=now&fields=cloud_cover%2Cwind_gust&apikey=Bk1NEzLKtAp8ZLFAfjnohGxbb0w8ATQn&unit_system=si'
    print(request)

    data = urllib.request.urlopen(request)
    data = data.read()

    data_dict = json.loads(data)
    print(data_dict[0])


get_data()
