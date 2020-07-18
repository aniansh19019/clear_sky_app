import 'package:flutter/material.dart';
import 'package:phases/services/moon_phase.dart';

import 'package:phases/widgets/home_card.dart';


class Moon extends StatefulWidget {
  @override
  _MoonState createState() => _MoonState();
}

class _MoonState extends State<Moon> {
  @override
  Widget build(BuildContext context) 
  {
    Phase moon = Phase();

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10,20,10,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text("Date"),
              Text(
          moon.phases[moon.phase],
          style: TextStyle(
            fontSize: 30,
            color: Colors.grey[300], 
          ),
              ),
              SizedBox(height: 10,),
              Text(
          "${moon.illumination} %",
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[300],
            fontWeight: FontWeight.bold, 
          ),
              ),
              Padding(
          padding: const EdgeInsets.fromLTRB(80, 20, 80, 15),
          child: Image.asset("assets/moon_phases/${moon.phase}.png"),
              ),
              
                // padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                HomeCard(
                      children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                      //   child: Divider(
                      //     height: 30,
                      //     color: Colors.grey[300],
                      //     thickness: 2,
                      //     ),
                      // ),
                      Descriptor(label: "Rise Time", value: moon.riseTime,),
                      SizedBox(height: 12,),
                      Descriptor(label: "Set Time", value: moon.setTime,),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                      //   child: Divider(
                      //     height: 30,
                      //     color: Colors.grey[300],
                      //     thickness: 2,
                      //     ),
                      // ),
                      ]),
                      HomeCard(
                      
                      children: <Widget>[
                      Descriptor(label: "Next Full Moon", value: moon.nextFullMoon,),
                      SizedBox(height: 12,),
                      Descriptor(label: "Next New Moon", value: moon.nextNewMoon,),
                      SizedBox(height: 12,),
                      Descriptor(label: "Previous Full Moon", value: moon.prevFullMoon,),
                      SizedBox(height: 12,),
                      Descriptor(label: "Previous New Moon", value: moon.prevNewMoon),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                      //   child: Divider(
                      //     height: 30,
                      //     color: Colors.grey[300],
                      //     thickness: 2,
                      //     ),
                      // ),

                      ],
                ),
              
              
              
            ],
          ),
        ),
      ),
    );
  }
}

class Descriptor extends StatelessWidget 
{
  const Descriptor({
    Key key,
    @required this.value,
    @required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              this.label,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 18,
                fontWeight: FontWeight.bold
                ),                    
              ),
            ),
          // Expanded(
          //   flex: 1,
          //   child: Text(""),
          //   ),
          Expanded(
            flex: 2,
            child: Text(
              this.value,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 17,
                fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.right,
              ),
            )

        ],
        
      ),
    );
  }
}