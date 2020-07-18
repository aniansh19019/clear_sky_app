import urllib.request
import json
import math


KEY = 'eeb485be1a7de1eab4cc120a013fb72c'
BASE_URL_HOURLY = 'https://api.openweathermap.org/data/2.5/forecast'


LAT = "28.416"
LONG = "77.840"



def get_data():
    data=None
    request=f'{BASE_URL_HOURLY}?lat={LAT}&lon={LONG}&appid={KEY}'

    data = urllib.request.urlopen(request)
    data = data.read()
    data_dict = json.loads(data)
    city = data_dict['city']['name']
    for i in range(40):
        print(data_dict['list'][i]['clouds']['all'])
get_data()

