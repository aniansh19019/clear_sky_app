import 'package:flutter/material.dart';
import 'package:phases/services/location.dart';
import 'package:phases/services/weather.dart';
// import 'package:flutter/services.dart';
import 'package:phases/services/observability.dart';

import 'package:connectivity/connectivity.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}
//!!Handle fullscreen

class _LoadingState extends State<Loading> 
{
  //add timer
  final int loadingDelay=3000;

  void setupApp()async
  {
    //* try to get data from api
    //* try to get from store
    //*restart app


    //* Setting up timing
    DateTime timer = DateTime.now();
    int startTime = timer.millisecondsSinceEpoch; 
    LocationCustom locationObject = LocationCustom();
    bool gotLocation = await locationObject.getLocation();

    //do not move ahead until location access is granted
    while(!gotLocation)
    {
      await errorAlert(
        "Error getting location!",
        "Please turn on location services and allow location access!"
      );
      gotLocation = await locationObject.getLocation();
    }

    //checking for network connection
    var connectivityResult = await (Connectivity().checkConnectivity());


    // bool isConnected=true;
    bool gotWeather=false;
    bool  gotData=false;

    if(connectivityResult==ConnectivityResult.none)
    {
      // isConnected=false;
      await errorAlert(
        "Could not fetch information!",
        "You appear to be offline! Please connect to the internet!\n\n The data may be outdated!"
      );
      // connectivityResult = await (Connectivity().checkConnectivity());
    }

    Weather currentWeather;
    Observability astroData;

    currentWeather = Weather();
    gotWeather = await currentWeather.getData();
    astroData = Observability();
    gotData = await astroData.getData();

    while(!gotWeather || !gotData)
    {
      await errorAlert(
        "Error! Could not retrieve data!",
        "Please connect to the internet to fetch data!!"
       );


      currentWeather = Weather();
      gotWeather = await currentWeather.getData();
      astroData = Observability();
      gotData = await astroData.getData();
      //can wrap everything in a while loop
      
    }



    //* Comparing timer
    int timePassed = DateTime.now().millisecondsSinceEpoch- startTime;
    // print(timePassed);
    // print(loadingDelay);
    // print(loadingDelay-timePassed);
    //* Delaying accordingly
    if(timePassed<this.loadingDelay)
    {
      await Future.delayed(Duration(milliseconds: this.loadingDelay-timePassed), (){});
    }




    // * disable fullscreen
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Navigator.pushReplacementNamed(context, '/tabs', arguments: {
      'currentWeather' : currentWeather,
      'starList': astroData.starList,
      'ngcList' : astroData.ngcList,
      'planetList' : astroData.planetList,

        }
      );

  }

  Future<void> errorAlert(String title, String subtitle) async 
  {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) 
    {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ) ,
        backgroundColor: Colors.grey[900],
        title: Text(
          title,
          style: TextStyle(color: Colors.grey[300]),
          ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[300]),
                
                ),
              // Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  @override
  void initState() 
  {
    super.initState();
    setupApp();

  }
  @override
  Widget build(BuildContext context) 
  {
    //* enable fullscreen
    // SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Color.fromARGB(1, 26, 26, 26),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/loading.jpg"),
            fit: BoxFit.cover
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 30,
              child:Text(""),
            ),
            Expanded(
              flex: 10,
              child:Text(
                "Clear Sky",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 36,
                ),
                ),
            ),
            Expanded(
              flex: 10,
              child:Text(""),
            ),
            Expanded(
              flex: 5,
              child:Text(
                "Copyright© 2020 Aniansh Raj Singh",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 10,
                ),
                ),
            ),
            
          ],
        ),
      ),
    );
  }
}