import 'package:flutter/material.dart';
import 'package:gyroscope_widget/gyroscope_widget.dart';
import 'package:phases/pages/moon.dart';
import 'package:phases/pages/home.dart';

// import 'package:phases/pages/test.dart';
// import 'package:phases/pages/settings.dart';

import 'package:phases/pages/about.dart';

import 'package:phases/pages/highlights.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phases/cusom_icon/custom_icon_pack_icons.dart';


// import 'package:gyroscope_widget/gyroscope_widget.dart';


class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage>
{

  PageController pageController;
  int _currentIndex=0;
  int previndex=1;

  @override
  void initState() {
  
    super.initState();

    pageController = PageController();

  }

  @override
  void dispose() {
    

    pageController.dispose();
    super.dispose();
  }


  // Persistence problem
  //fixed
  //! Rapid switching problem // temporary workaround // replace graphing library eventually
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
          
          
        ],
        onTap: (index)
        {
          if(_currentIndex!=index)
          {
            setState(() 
            {
              
              
              previndex=_currentIndex;
              _currentIndex = index;
              if (pageController.hasClients) 
              {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.ease,
                );
              }
                
            
            },);
          }
        }
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GyroscopeWidget(
              scaleMargin: 0.07,
              child: Image.asset(
                "assets/bg6.jpg",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
              )
            ),
            Ink(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                controller: pageController,
                onPageChanged: (index)
                {
                  setState(() 
                  {
                    previndex=_currentIndex;
                    _currentIndex = index;
                  });
                },
                children: <Widget>[
                  for(int i=0; i<tabs.length; i++)
                  tabs[i]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}