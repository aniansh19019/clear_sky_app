import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:phases/cusom_icon/custom_icon_pack_icons.dart';

class Highlights extends StatefulWidget 
{
  final Map<String, dynamic> data;
  const Highlights(this.data, {Key? key}) : super(key: key);

  @override
  _HighlightsState createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> with SingleTickerProviderStateMixin
{
  late AnimationController controller;
  late Animation<double> positionController;
  late Animation<double> heightController;
  late Animation<double> widthController;


  final Map data;

  bool active=false;

  late List<Map<String, dynamic>> starList;
  late List<Map<String, dynamic>> ngcList;
  late List<Map<String, dynamic>> planetList;


  void switchController()
  { 
    this.active=!this.active;
    controller.isDismissed
  ? controller.forward()
  : controller.reverse();
  }


  void topToggle() 
  {
    switchController();
    this.listSelect=0;
  }

  void middleToggle()
  {
    switchController();
    this.listSelect=1;
  }

  void bottomToggle()
  {
    switchController();
    this.listSelect=2;
  }
  Future<bool> popScope()async
  {
    if(this.active)
    {
      switchController();
      return false;
    }
    return true;
  }

  // Future<bool> _onWill
  

  late List<Function> toggles;

  late List<List<Map<String, dynamic>>> dataLists;




  
  final double initialWidth=300.0;
  final double widthOffset=30.0;

  
  final double initialHeight=155.0;
  final double heightOffset=350.0;

  // double planetWidth=300;
  // double planetHeight=300;
  final List<String> labels =[
    "Solar System",
    "Stars",
    "Deep Sky Objects"
  ];


  int listSelect=0;
  final List<double> initialPosition=[0.0,185.0,370.0];
  
  late List<Widget> icons;

  late List<double> animatedHeight;
  late List<double> animatedWidth;
  late List<double> animatedPosition;
  late List<double> animatedOpacity;

  // Map<>
  // bool planetToggle=false;

  _HighlightsState();

  void getData() {
    starList = List<Map<String, dynamic>>.from(data['starList'] ?? []);
    ngcList = List<Map<String, dynamic>>.from(data['ngcList'] ?? []);
    planetList = List<Map<String, dynamic>>.from(data['planetList'] ?? []);
  }


  @override
  void dispose() 
  {
    controller.dispose();
    // positionController.dispose();
    // heightController.dispose();
    // widthController.dispose();  
    super.dispose();
  }

  @override
  void initState() 
  {
    super.initState();
    getData();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      
    );
    controller.reverse();

    //* custom animation controllers

    //ease
    //elastiin
    this.positionController = new Tween(
      begin: 0.0,
      end: 1.0,
      ).animate(new CurvedAnimation(
        parent: controller,
        curve: Curves.ease
        ));
    this.widthController = new Tween(
      begin: 0.0,
      end: 1.0,
      ).animate(new CurvedAnimation(
        parent: controller,
        curve: Curves.easeInToLinear
        ));
    this.heightController = new Tween(
      begin: 0.0,
      end: 1.0,
      ).animate(new CurvedAnimation(
        parent: controller,
        curve: Curves.easeInToLinear
        ));

    this.animatedPosition = List.filled(3, 0.0);
    this.animatedHeight = List.filled(3, 0.0);
    this.animatedWidth = List.filled(3, 0.0);
    this.animatedOpacity = List.filled(3, 0.0);
    // this.initialPosition=List(3);

    for(int i=0; i<3; i++)
    {
      this.animatedHeight[i]=this.initialHeight;
      this.animatedWidth[i]=this.initialWidth;
      this.animatedPosition[i]=this.initialPosition[i];
      this.animatedOpacity[i]=1;
    }


    
    this.toggles=[
      topToggle,
      middleToggle,
      bottomToggle
    ];

    this.dataLists=
    [
      planetList,
      starList,
      ngcList
    ];

    this.icons=
    [
      Icon(
      CustomIconPack.planet,
        color: Colors.grey[300],
        ),
      Icon(
        CustomIconPack.star,
        color: Colors.grey[300],
        ),
      Icon(
        CustomIconPack.galaxy,
        color: Colors.grey[300],
        ),
      

    ];

    

  }

  @override
  Widget build(BuildContext context) 
  {

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: WillPopScope(
        onWillPop: popScope,
        child: AnimatedBuilder(
          animation: this.controller,
          builder:(context, _)
          {
            for(int i=0; i<3; i++)
            {
              this.animatedOpacity[i]=pow((1-controller.value), 4);
            }
            
            this.animatedOpacity[this.listSelect] = 1;
            this.animatedPosition[this.listSelect] = (1-positionController.value)*this.initialPosition[this.listSelect];
            this.animatedHeight[this.listSelect] = this.initialHeight+heightController.value*this.heightOffset;
            this.animatedWidth[this.listSelect] =this.initialWidth+widthController.value*this.widthOffset;
            // print(this.positionController.value);
            return  Padding(
              padding: const EdgeInsets.all(30),
              child: Stack(
                // overflow: Overflow.visible,
                alignment: Alignment.center,
              children: <Widget>[
                for(int i=0; i<3; i++)
                Positioned(
                  top: this.animatedPosition[i],
                  // left:10,
                  child: Offstage(
                    offstage: this.animatedOpacity[i]<=0,
                    child: Opacity(
                      opacity: this.animatedOpacity[i],
                      child: ExpandingList(
                        data: this.dataLists[i],
                        label: this.labels[i],
                        icon: icons[i],
                        height: this.animatedHeight[i],
                        width: this.animatedWidth[i],
                        titleTap: this.toggles[i],
                        ),
                    ),
                  ),
                ),
                

              ],
          ),
            );
          }
          // child: 
        ),
      ),
    );
  }
}
// TODO change list order
class ExpandingList extends StatelessWidget 
{
  final List<Map<String, dynamic>> data;
  final String label;
  final Widget icon;
  final double height;
  final double width;
  final Function titleTap;
  

  ExpandingList({
    required this.data,
    required this.label,
    required this.icon,
    this.height = 300,
    this.width = 300,
    required this.titleTap,

    });
  @override
  Widget build(BuildContext context) 
  {
    return Ink(
      // duration: Duration(milliseconds: 500),
      // curve: Curves.easeOutCirc,
      height: this.height,
      width: this.width,
      padding: EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        elevation: 10,
        // borderOnForeground: false,
        color: Colors.grey[900].withOpacity(1),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
          onTap: this.titleTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 4),
                  child: Text(
                  this.label,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 30),
                //   child: Divider(
                //     height: 10,
                //     color: Colors.grey[300],
                //     thickness: 2,
                //     ),

                // ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index)
                    {
                      String timeString="Always above Horizon.";
                      if (data[index]['rise'] != null) {
                        timeString = "Rises ${DateFormat('jm').format(data[index]['rise'])}, ";
                        timeString += "Sets ${DateFormat('jm').format(data[index]['set'])} ";
                      }
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                          ),
                        elevation: 2,
                        
                        color: Colors.black.withAlpha(0),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                              ),
                          onTap: this.titleTap,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: ListTile(
                                leading: this.icon,
                                // onTap: titleTap,
                                title: Text(
                                  data[index]['name'],
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 20,
                                  ),
                                  ),
                                subtitle: Text(

                                  timeString,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                  ),
                                  
                              ),
                          ),
                        ),
                        );
                    },
                    ),
                )

              ],
            ),
          ),
        ),
      )
      
    );
  }
}







