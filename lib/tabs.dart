import 'package:flutter/material.dart';
import 'package:phases/pages/moon.dart';
import 'package:phases/pages/home.dart';

// import 'package:phases/pages/test.dart';
// import 'package:phases/pages/settings.dart';

import 'package:phases/pages/about.dart';

import 'package:phases/pages/highlights.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phases/cusom_icon/custom_icon_pack_icons.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin
{

  AnimationController controller;
  var opacityController;
  var positionController;
  int _currentIndex=0;
  List<double> animatedOpacity;
  List<double> animatedPosition;
  int previndex=1;

  @override
  void initState() {
  
    super.initState();

    //init

    animatedOpacity=List(4);
    animatedPosition=List(4);

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      
    );
    controller.forward();


    this.opacityController = new Tween(
      begin: 0.0,
      end: 1.0,
      ).animate(new CurvedAnimation(
        parent: controller,
        curve: Curves.ease
        ));
    
    this.positionController = new Tween(
      begin: 0.0,
      end: 1.0,
      ).animate(new CurvedAnimation(
        parent: controller,
        curve: Curves.ease
        ));

    for(int i=0;i<4;i++)
    {
      animatedOpacity[i]=0;
      animatedPosition[i]=0;
    }
    // animatedOpacity[this._currentIndex]=1;
    // controller.reverse();
    // controller.
  }


  // Persistence problem
  //fixed
  //! Rapid switching problem
  @override
  Widget build(BuildContext context) 
  {
    Map data={};

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    

    final tabs = [
    Home(data),
    Moon(),
    Highlights(data),
    About(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        // unselectedIconColor: Colors.grey[300],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurpleAccent,

        type : BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.moon),
            title: Text("Moon")
          ),
          BottomNavigationBarItem(
            // icon: FaIcon(FontAwesomeIcons.binoculars),
            icon: Icon(CustomIconPack.telescope),
            title: Text("Highlights")
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.info),
            title: Text("Info")
          ),
          
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text("Settings")
          // ),
          
          
        ],
        onTap: (index)
        {
          setState(() 
          {
            if(_currentIndex!=index)
            {
            previndex=_currentIndex;
            _currentIndex = index;
            controller.reset();
            controller.forward();
            }
          });
        },
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: AnimatedBuilder(
            animation: this.controller,
            builder: (context,_)
            {

              for(int i=0;i<4;i++)
              {
                if(this.animatedOpacity[i]!=0)
                {
                  this.animatedOpacity[i]=1-opacityController.value;
                }
                // this.animatedOpacity[i]=0;
              }
              if(_currentIndex-previndex>0)
              {
                this.animatedPosition[this.previndex]=-(positionController.value*MediaQuery.of(context).size.width);
                this.animatedPosition[this._currentIndex]=((1-positionController.value)*MediaQuery.of(context).size.width);

              }
              else
              {
                this.animatedPosition[this.previndex]=(positionController.value*MediaQuery.of(context).size.width);
                this.animatedPosition[this._currentIndex]=-((1-positionController.value)*MediaQuery.of(context).size.width);
              }
              
              this.animatedOpacity[this._currentIndex]=opacityController.value;

              return Stack(
              children: <Widget>[
                for(int i=0; i<tabs.length; i++)
                  Positioned(
                    left: this.animatedPosition[i],
                    right: -this.animatedPosition[i],
                    top:0,
                    bottom: 0,
                     child: Opacity(
                      opacity: 1,
                      child: Offstage(
                        offstage: this.animatedOpacity[i]==0,
                        child: TickerMode(
                          enabled: this._currentIndex==i,
                          child: tabs[i],
                        ),
                      ),
                    ),
                  )
              ],
            );
          
            },
            
          ),
        ),
      ),
      
    );
  }
}