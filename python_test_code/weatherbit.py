import urllib.request
import json
import math


KEY = '16c3252852304f0bb7bddec8e0bb8fad'
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
    for i in range(len(data_dict['data'])):
        print(data_dict['data'][i]['clouds'])


get_data()
