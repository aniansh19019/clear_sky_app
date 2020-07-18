import 'package:http/http.dart';
import 'dart:convert';
import 'package:phases/services/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phases/services/planets.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
// flutter: Error getting Weather data! : type 'int' is not a subtype of type 'double'
//fixed
//! fix sunrise sunset
class Weather
{
  double lat;
  double long;
  String apiKey="16c3252852304f0bb7bddec8e0bb8fad";
  String baseURL="https://api.weatherbit.io/v2.0/forecast/hourly";
  String practiceData='''''';
  String cityName="Error getting data";
  Map dataDict;
  final bool testing=false;
  List <CloudCoverSeries> cloudCoverList;
  List <DataSeries> dataList;
  bool isNight;
  double avgVisibility;
  double maxTemp;
  double minTemp;
  DateTime sunRise;
  DateTime sunSet;
  // String responseJsonString;


  Weather()
  {
    this.cloudCoverList = List();
    this.dataList = List();
    this.maxTemp=-100;
    this.minTemp=100;
  }

  //* redundant code
  Future<String> getJsonFromStore()async
  {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    final jsonString = prefs.getString('weather_json') ?? "";
    
    return jsonString;
    

  }

  void saveJsonToStore(String jsonString)async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('weather_json', jsonString);
  }




  Future<String> fetchData()async
  {
    Response response;
    String jsonString="";

    if(!testing)
    {

      try //* try fetching data from api
      {
        response = await get('${this.baseURL}?lat=${this.lat}&lon=${this.long}&key=${this.apiKey}');
        jsonString = response.body;
        saveJsonToStore(jsonString);

      } catch (e) //*if cant fetch, try reading from store
      {
        jsonString = await getJsonFromStore();
      }

      
    }
    else
    {
      jsonString = await rootBundle.loadString('database/weather_data.json');
    }
    return jsonString;
  }


  Future<bool> getData()async
  {
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
    if(!await planets.getData())
    {
      return false;
    }

    this.sunRise = planets.sunData['rise'];
    this.sunSet = planets.sunData['set'];



   
      
    String jsonString = await fetchData();



    if(jsonString=="")
    {
      return false;
    }

      

    Map data = jsonDecode(jsonString);
    // print('${this.baseURL}?lat=${this.lat}&lon=${this.long}&key=${this.apiKey}');
    this.cityName = data['city_name'];
    this.dataDict = data;

    genCloudSeries();
    // for (Map item in dataDict['data'])
    // {
    //   print(item['vis']);
    // }


    return true;
    
  } 

  void genCloudSeries()// develop into intermediary preprocessing function //done
  {
    DateTime now;
    if(!testing)
    {
      now = DateTime.now();
    }
    else
    {
      now = DateTime.parse("2020-07-11T02:30:00");
    }
    // print(toHour(now));


    // ! change to sunrise to sunset
    if(toHour(now) < toHour(this.sunSet) && toHour(now) > toHour(this.sunRise))
    {
      this.isNight=false;
    }
    else
    {
      this.isNight=true;
    }

    // print("now:$now");
    // print("sunrise:$sunRise");
    // print("sunset:$sunSet");
    // print("isnight:$isNight");
    DateTime tempStart;
    DateTime tempEnd;

    // avoid too thin of a graph set constraints to roll over the day
    //done
    if(this.isNight)
    {
      double hourIncrement;
      // int minuteIncrement=0;
      if(toHour(now)>toHour(this.sunRise))
      {
        hourIncrement = (24-toHour(now))+toHour(this.sunRise);
      }
      else if(toHour(now)<toHour(this.sunRise))
      {
        hourIncrement = toHour(this.sunRise)-toHour(now);
      }
      else
      {
        hourIncrement = 2;//* to avoid zero
      }


      tempStart = now;
      tempEnd = tempStart.add(toDuration(hourIncrement));
      // print("is night end: $tempEnd, start: $tempStart");
    }
    else
    {
      double hourIncrement = toHour(this.sunSet)-toHour(now);
      tempStart = now.add(toDuration(hourIncrement));
      hourIncrement = toHour(this.sunSet) - toHour(this.sunRise);
      tempEnd = tempStart.add(toDuration(hourIncrement));
      // print("is day end: $tempEnd, start: $tempStart");
    }

    // improve interval
    //done

    
    int counter=0;
    double sum=0;


    // EXPERIMENTAL

    // * Converting to a 24 hr interval beginning from now()
    DateTime start=now;
    DateTime end=start.add(Duration(hours: 24));

    // EXPERIMENTAL


    // Weather and avg visibility fix because of new data range!!!!!
    //fixed
    bool night;
    DateTime legendSunRise;
    DateTime legendSunSet;

    for(int i=0; i<this.dataDict['data'].length; i++)
    {
      DateTime current;
      CloudCoverSeries temp;
      DataSeries t;

      current = DateTime.parse(this.dataDict['data'][i]['timestamp_local']);
      // print(tempEnd);
      if(current.isAfter(start) && current.isBefore(end))
      {
        

        //* fixing for date range change
        if(current.isBefore(tempEnd) && current.isAfter(tempStart))
        {
          
          counter++;
          sum+=dataDict['data'][i]['vis'];

          double temperature=this.dataDict['data'][i]['temp'].toDouble();
          if(this.maxTemp<temperature)
          {
            this.maxTemp=temperature;
          }
          if(this.minTemp>temperature)
          {
            this.minTemp=temperature;
          }
        }
        


        temp = CloudCoverSeries(time: current, cloudCover: this.dataDict['data'][i]['clouds']);
        t=DataSeries(current, dataDict['data'][i]);
        
        if(current.hour>toHour(this.sunRise) && current.hour<toHour(this.sunSet))
        {
          
          temp.lineColor=Colors.amber;
          temp.shadeColor=Colors.amber[200].withOpacity(0.3);

          if(night==null)
          {
            night=false;
          }

          if(night)
          {
            legendSunRise=current;
          }
          night=false;
        }
        else
        {
          // print(current);
          temp.lineColor=Colors.deepPurple;
          temp.shadeColor=Colors.deepPurple[400].withOpacity(0.3);
          //*debug
          // print("Okay");

          if(night==null)
          {
            night=true;
          }
          if(!night)
          {
            legendSunSet=current;
          }
          night=true;
          

        }
        //! error
        // temp.sunRise=tempEnd.add(Duration(hours: 1));
        // double hourIncrement = toHour(this.sunSet) - toHour(tempEnd);
        // temp.sunSet=tempEnd.add(toDuration(hourIncrement+1));

        this.dataList.add(t);
        
        this.cloudCoverList.add(temp);
        
      }

      
      

    }

    this.cloudCoverList[0].sunRise=legendSunRise;
    this.cloudCoverList[0].sunSet=legendSunSet;
    this.avgVisibility=sum/counter;
    // print("Okay2");
    // print(cloudCoverList);
   



  }

  double toHour(DateTime date)
  {
    return date.hour+(date.minute/60.0);
  }

  Duration toDuration(double hour)
  {
    int h = hour.floor();
    double minute = (hour-h)*60.0;
    int m = minute.floor();
    int s = ((minute-m)*60).round();

    return Duration(hours: h, minutes: m, seconds: s);
  }

  
}

class CloudCoverSeries
{
  DateTime time;
  DateTime sunRise;
  DateTime sunSet;
  int cloudCover;
  Color lineColor;
  Color shadeColor;


  CloudCoverSeries({this.time, this.cloudCover});
}

class DataSeries
{
  DateTime time;
  Map data;

  DataSeries(this.time, this.data);
}





// if(!testing)
//       {
//         // * 48 hour data
        
//         jsonString = await getJsonFromStore();
//         print(jsonString);
//         print("Got the key!");
        
//         if(jsonString!="")
//         {
//           Map tempJson = jsonDecode(jsonString);
//           DateTime firstEntry = DateTime.parse(tempJson['data'][0]['timestamp_local']);
//           DateTime now = DateTime.now();

//           if(now.difference(firstEntry).inHours>2)
//           {
//             response = await get('${this.baseURL}?lat=${this.lat}&lon=${this.long}&key=${this.apiKey}');
//             jsonString = response.body;
//           }
//         }
//         else
//         {
//           response = await get('${this.baseURL}?lat=${this.lat}&lon=${this.long}&key=${this.apiKey}');
//           jsonString = response.body;
//         }
//         saveJsonToStore(jsonString);
//       }
//       else
//       {
//         jsonString = await rootBundle.loadString('database/weather_data.json');
//       }
      