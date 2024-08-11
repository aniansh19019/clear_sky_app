import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class NGC
{
  
  late List<Map<String, dynamic>> formattedData;
  Future<void> getData()async
  {

    //* init
    this.formattedData = [];
    List<Map<String, dynamic>> starData = [];


    //* reading from file
    String csvString = await rootBundle.loadString('database/ngc.csv');
    //* parsing
    List<List<dynamic>> rows = CsvToListConverter().convert(csvString);
    List<dynamic> header = rows[0];
    for(int i=1; i<rows.length; i++)
    {
      Map tempMap = {};
      for(int j=0; j<header.length; j++)
      {
        // print(j);
        tempMap.putIfAbsent(header[j], () => rows[i][j]);
      }
      // print(tempMap);
      if(tempMap!=null)
      {
        starData.add(tempMap);
      }
      
    }

    _genFormattedData(starData);
  }

  void _genFormattedData(List<Map> data)
  {
    //name, alt_name, mag, ra, dec

    for(Map item in data)
    {
      Map tempMap={};

      if(item['Common names']!="")
      {
        tempMap.putIfAbsent("name", () => item['Common names']);
      }
      else
      {
        tempMap.putIfAbsent("name", () => item['Identifiers']);

      }

      tempMap.putIfAbsent("mag", () => item['B-Mag']);
      String raString = item['RA'];
      String decString = item['Dec'];

      // print("ra: $raString \n dec: ${decString.substring(0,2)}");

      double dec=0;
      dec+=double.parse(decString.substring(0,3));
      dec+=double.parse(decString.substring(4,6))/60.0;
      // dec+=double.parse(decString.substring(7,11))/60.0;

      double ra=0;
      ra+=double.parse(raString.substring(0,2));
      ra+=double.parse(raString.substring(3,5))/60.0;
      // ra+=double.parse(decString.substring(6,11))/60.0;



      tempMap.putIfAbsent("ra", () => ra);
      tempMap.putIfAbsent("dec", () => dec);
      // tempMap.putIfAbsent("type", () => item['Type']);
      
      this.formattedData.add(tempMap);

    }
    
    //* sorting

    this.formattedData.sort( (a,b) =>a['mag'].compareTo(b['mag']));
    // print(this.formattedData[3]);
    
  }

  
  

}
