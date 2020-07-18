import 'package:location/location.dart';


class LocationCustom
{
  double latitude;
  double longitude;
  double altitude;

  Future<bool> getLocation() async
  {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) 
    {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) 
      {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) 
    {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) 
      {
        return false;
      }
    }

    _locationData = await location.getLocation();
    this.latitude = _locationData.latitude;
    this.longitude = _locationData.longitude;
    this.altitude = _locationData.altitude;
    return true;
    // print('${_locationData.latitude}, ${_locationData.longitude}');
  }
}