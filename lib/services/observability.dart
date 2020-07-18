import 'package:phases/services/stars.dart';
import 'package:phases/services/ngc.dart';
import 'package:phases/services/planets.dart';
// import 'package:phases/services/moon_phase.dart';
import 'package:phases/services/location.dart';
import 'package:phases/util/ra_dec_to_alt_az.dart';


class Observability
{
  double lat;
  double long;
  List starList;
  List ngcList;
  List planetList;
  Map moonData;
  DateTime sunSet;
  DateTime sunRise;
  final int starCount=20;
  final int ngcCount=15;
  final double horizonOffset=0.5;//offset for rise and set filtering in hours


  Future<bool> getData()async
  {
    // * init
    this.starList=List();
    this.ngcList=List();
    this.planetList=List();

    // Planets()

    LocationCustom here = LocationCustom();
    bool gotLocation = await here.getLocation();
    if(!gotLocation)
    {
      print("Error getting Location!");
      return false;
    }
    this.lat = here.latitude;
    this.long = here.longitude;

    Planets planets = Planets(lat: this.lat, long: this.long);
    Stars stars = Stars();
    NGC ngc = NGC();
    // Phase moon = Phase();

    

    print("Getting Planet Data..");
    bool success = await planets.getData();
    print("Getting Stars Data..");
    await stars.getData();
    print("Getting NGC Data..");
    await ngc.getData();

    if(!success)
    {
      return false;
    }

    this.sunRise = planets.sunData['rise'];
    this.sunSet = planets.sunData['set'];
    this.planetList=planets.formattedData;

    // setVisiblePlanets(planets.formattedData);
    this.starList=getVisibleObjects(stars.formattedData, this.starCount);
    this.ngcList=getVisibleObjects(ngc.formattedData, this.ngcCount);
    
    //! Moon left
    // overlap check
    //fixed
    
    
    // print(planetList);
    // print(starList);
    // print(ngcList);


    //* 
    return true;

    
  }

  

  List<Map> getVisibleObjects(List<Map> data, int count)
  {
    DateTime now = DateTime.now();
    List<Map> retlist = List();

    int counter=0;
    int index=0;
    while(counter<count)
    {
      RaDecToAltAz converter = RaDecToAltAz(
        lat: this.lat,
        long: this.long,
        ra: data[index]['ra'],
        dec: data[index]['dec'],
      );
      converter.calculate(now);

      if(!converter.alwaysBelow)
      {

        if(converter.alwaysAbove)
        {
          data[index].putIfAbsent("rise", () => converter.riseTime);
          data[index].putIfAbsent("set", () => converter.setTime);
          retlist.add(data[index]);
          counter++;
        }
        else
        {
          double sunRiseHour=toHour(this.sunRise)-this.horizonOffset;
          double sunSetHour=toHour(this.sunSet)+this.horizonOffset;
          double objRiseHour=toHour(converter.riseTime);
          double objSetHour=toHour(converter.setTime);

          if(!(objRiseHour>sunRiseHour && objRiseHour <sunSetHour && objSetHour>sunRiseHour && objSetHour < sunSetHour))
          {
            data[index].putIfAbsent("rise", () => converter.riseTime);
            data[index].putIfAbsent("set", () => converter.setTime);
            retlist.add(data[index]);
            counter++;
          }
        }
      }

      index++;
    }
    return retlist;
  }
  double toHour(DateTime date)
  {
    return date.hour+(date.minute/60.0);
  }

}