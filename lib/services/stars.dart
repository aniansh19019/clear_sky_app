import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class Stars
{
  
  List<Map> formattedData;
  Future<void> getData()async
  {

    //* init
    this.formattedData=List();
    List<Map> starData;

    starData =List();


    //* reading from file
    String csvString = await rootBundle.loadString('database/stars.csv');
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

      if(item['proper'] !="")
      {
        tempMap.putIfAbsent("name", () => item['proper']);
      }
      else
      {
        if(item['bf']!="")
        {
          tempMap.putIfAbsent("name", () => item['bf']);
        }
        else
        {
          tempMap.putIfAbsent("name", () => item['gl']);
        }
        
      }
      
      
      tempMap.putIfAbsent("mag", () => item['mag']);
      tempMap.putIfAbsent("ra", () => item['ra']);
      tempMap.putIfAbsent("dec", () => item['dec']);
      
      this.formattedData.add(tempMap);

    }
    
    //* sorting

    this.formattedData.sort( (a,b) =>a['mag'].compareTo(b['mag']));
    
  }

  
  

}