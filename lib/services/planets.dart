// import 'package:flutter/services.dart';
// import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

//via api
//! build flutter api
//! format data and remove semantic inconsistencies
//! Add custom objects
class Planets 
{

  List<Map> formattedData;
  Map sunData;
  double lat;
  double long;
  String baseURL="http://aniansh-planets-api.herokuapp.com/bodies";
  // String baseURL="http://127.0.0.1:5000/bodies";
  Planets({this.lat, this.long});





  Future<String> getJsonFromStore()async
  {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    final jsonString = prefs.getString('planets_json') ?? "";
    
    return jsonString;
    

  }

  void saveJsonToStore(String jsonString)async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('planets_json', jsonString);
  }




  Future<String> fetchData()async
  {
    Response response;
    String jsonString="";

    

    try //* try fetching data from api
    {
      response = await get('${this.baseURL}?lat=${this.lat}&lon=${this.long}');
      jsonString = response.body;
      saveJsonToStore(jsonString);
    } catch (e) //*if cant fetch, try reading from store
    {
      jsonString = await getJsonFromStore();
    }
    
  
   
    return jsonString;
  }



  Future<bool> getData()async
  {
    //*init
    List data = List();
    this.formattedData = List();
    String jsonString;

    jsonString = await fetchData();

    if(jsonString=="")
    {
      return false;
    }
   
    data = jsonDecode(jsonString)['data'];
    // this.sunData = data[0];
    // debugPrint(jsonString);
    //*fromatting
    for(Map item in data)
    {
      Map tempMap={};
      DateTime riseTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(item["rise"],true);
      DateTime setTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(item["set"], true);

      riseTime = riseTime.toLocal();
      setTime = setTime.toLocal();
      
      // var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(riseTime, true);
      // print(item);
      tempMap.putIfAbsent("name", () => item["name"]);
      tempMap.putIfAbsent("ra", () => item["ra"]);
      tempMap.putIfAbsent("dec", () => item["dec"]);
      tempMap.putIfAbsent("mag", () => item["mag"]);
      tempMap.putIfAbsent("rise", () => riseTime);
      tempMap.putIfAbsent("set", () => setTime);
      this.formattedData.add(tempMap);
    }
    this.sunData=this.formattedData.removeAt(0);
    setOverlap();
    this.formattedData.sort( (a,b) => b['overlap'].compareTo(a['overlap']) );
    
    
    return true;
  

  }
  double toHour(DateTime date)
  {
    return date.hour+(date.minute/60.0);
  }

  void setOverlap()
  {
    for(int i=0; i<this.formattedData.length; i++)
    {
      double overlap=0;
      double sunRiseHour=toHour(this.sunData['rise']);
      double sunSetHour=toHour(this.sunData['set']);
      double planetRiseHour=toHour(this.formattedData[i]['rise']);
      double planetSetHour=toHour(this.formattedData[i]['set']);

      if( (planetRiseHour>sunSetHour || planetRiseHour<sunRiseHour))
      {
        if(planetRiseHour<sunSetHour)
        {
          overlap=sunRiseHour-planetRiseHour;
        }
        else
        {
          overlap=(24-planetRiseHour)+sunRiseHour;
        }
      }
      else
      {
        if(planetSetHour<sunSetHour)
        {
          overlap = (24-sunSetHour)+planetSetHour;
        }
        else
        { 
          overlap = planetSetHour-sunSetHour;
        }
      }
      this.formattedData[i].putIfAbsent("overlap", () => overlap);
    }
  }
  
}