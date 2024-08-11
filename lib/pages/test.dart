import 'package:flutter/material.dart';
// import 'package:phases/services/observability.dart';
// import 'package:phases/services/planets.dart';
class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> 
{
  void getData()async
  {
    // Observability current = Observability();
    // await current.getData();


    //  RaDecToAltAz position = RaDecToAltAz(
    //   ra: 19.6,
    //   dec: -20.1,
    //   lat: 28.605,
    //   long: 77.216
    //   );
    //   position.calculate(DateTime.now());
    //   print("rise: ${position.riseTime}\nset: ${position.setTime}");

      // current.getData();

    // Planets planets = Planets(lat: 28.605,long: 77.216);
    // await planets.getData();

  }
  @override
  void initState() 
  {
    super.initState();
    
    getData();

  }
  @override
  Widget build(BuildContext context) 
  {
    return Center();
  }
}
