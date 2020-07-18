import 'package:flutter/material.dart';



class HomeCard extends StatelessWidget {
  
  final List<Widget> children;
  HomeCard({this.children});
  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.all(5),
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
          onTap: (){},
          child: Padding(  
            padding: EdgeInsets.all(15),
            child: Column(
              children: this.children,
            ),
          ),
        ),
        
      ),
    );
  }
}