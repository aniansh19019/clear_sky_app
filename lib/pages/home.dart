import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phases/services/weather.dart';
// import 'package:phases/services/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:phases/services/moon_phase.dart';

import 'package:phases/widgets/home_card.dart';
import 'package:phases/widgets/time_series_chart.dart';






//loading issue
//Fixed Loading issue

// ! Fix Tonight scene

//! rapid switching problem

class Home extends StatefulWidget 
{
  final Map data;
  Home(this.data);
  @override
  _HomeState createState() => _HomeState(this.data);
}

class _HomeState extends State<Home> 
{
  Map data;


  // double lat=0;
  // double long=0;
  String iconFile="";
  String city="";
  bool isLoaded=false;
  List<charts.Series<CloudCoverSeries, DateTime>> seriesList;
  String weatherDescription="Loading";
  String weatherTime="Tonight";
  double minTemp=100;
  double maxTemp=-100;
  double avgVisibility=0;


  _HomeState(this.data);


  //! remove async
  void getData()
  {
    Weather current = data['currentWeather'];
    
      
      // this.lat = testObject.latitude;
      // this.long = testObject.longitude;
      this.iconFile='assets/weather_icons/${current.dataList[0].data['weather']['icon']}.png';
      this.city=current.cityName;
      this.weatherDescription=current.dataList[0].data['weather']['description'];
      this.minTemp=current.minTemp;
      this.maxTemp=current.maxTemp;
      this.avgVisibility=current.avgVisibility;
      if(current.isNight)
      {
        this.weatherTime="Now";
      }
      else
      {
        this.weatherTime="Tonight";
      }
      // setting timeseries value
      this.seriesList=[
      new charts.Series<CloudCoverSeries, DateTime>(
        id: 'Cloud Cover',
        colorFn: (CloudCoverSeries cover, __) => charts.ColorUtil.fromDartColor(cover.lineColor),
        areaColorFn: (CloudCoverSeries cover, __) => charts.ColorUtil.fromDartColor(cover.shadeColor),
        domainFn: (CloudCoverSeries cover, _) => cover.time,
        measureFn: (CloudCoverSeries cover, _) => cover.cloudCover,
        data: current.cloudCoverList,
      )
    ];
      // this.isLoaded=true;
      Future.delayed(Duration(milliseconds: 500), ()
    {
      setState(() 
      {
        this.isLoaded=true;
      });
    });
    
    
  }


  @override
  void initState() 
  {
    super.initState();
    this.isLoaded=false;
    this.iconFile="";
    getData(); 
  }

  @override
  Widget build(BuildContext context)
  {
    // this.isLoaded=false;
    

    Phase moon = Phase();
    
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,10,20,0),
          child: Column(
            children: <Widget>[
              
              // Text('${this.lat}, ${this.long}\n${this.city}'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: HomeCard(
                      children: <Widget>[
                        Text(
                          "${this.city}",
                          style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[300],
                                    fontWeight: FontWeight.bold 
                                  ),
                                
                          )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: HomeCard(
                                children: <Widget>[
                                  Text(
                                    "Tonight",
                                    style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[300],
                                              fontWeight: FontWeight.bold 
                                            ),

                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Container(
                          // height: 280,
                          child: HomeCard(
                            
                            children: <Widget>[
                              
                              Image.asset(
                                this.iconFile,
                                height: 55,
                                ),
                              SizedBox(height: 10,),
                              Text(
                                "${this.weatherDescription}",//!Capitalise
                                style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(""),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FaIcon(
                                      FontAwesomeIcons.temperatureHigh,
                                      color: Colors.grey[300],
                                      
                                      )
                                    ),
                                  Expanded(
                                    flex: 10,
                                    child:Text(
                                      "${this.maxTemp} °C",
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.right,

                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(""),
                                  )
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(""),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FaIcon(
                                      FontAwesomeIcons.temperatureLow,
                                      color: Colors.grey[300],
                                      
                                      )
                                    ),
                                  Expanded(
                                    flex: 10,
                                    child:Text(
                                      "${this.minTemp} °C",
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.right,

                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(""),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //! Alignment center for moon column
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // height: 170,
                          child: HomeCard(
                            children: <Widget>[
                              Text(
                                    moon.phases[moon.phase],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[300], 
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                              ),
                              Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    child: Image.asset(
                                      "assets/moon_phases/${moon.phase}.png",
                                      height: 60,  
                                      ),
                              ),
                              SizedBox(height: 15,),
                              Text(
                                    "${moon.illumination} %",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[300],
                                      fontWeight: FontWeight.bold, 
                                    ),
                              ),
                            ],
                          ),
                        ),
                        HomeCard(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.landscape,
                              color: Colors.grey[300],
                              ),
                            Text(
                              " ${this.avgVisibility.round()} Km",
                              style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                        ),

                              ),
                            ],
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                ],
              ),
              
              HomeCard(
                children: <Widget>[
                  SizedBox(height: 10,),
                  WidgetLoader(
                    isLoaded: this.isLoaded,
                    child: SimpleTimeSeriesChart(
                      this.seriesList,
                      animate: true,
                      height: 140,
                    ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    "Cloud Cover",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 0,)
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
    
      
    
  }
}


//* Loads Widget after the data has been fetched!
class WidgetLoader extends StatelessWidget 
{
  final bool isLoaded;
  final Widget child;

  WidgetLoader({this.isLoaded, this.child});

  @override
  Widget build(BuildContext context) 
  {
    if(this.isLoaded)
    {
      return this.child;
    }
    else
    {
      return SpinKitFadingCircle(
          color: Colors.grey,
          size: 80.0,
          );

    }
  }
}





