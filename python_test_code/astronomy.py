import urllib.request
import json
import math


def get_data():
    request = "http://server1.sky-map.org/search?star=polaris"
    response = urllib.request.urlopen(request)
    print(response.read())



get_data()
