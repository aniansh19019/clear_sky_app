import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:phases/pages/home.dart';

import 'package:phases/widgets/home_card.dart';


class About extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) 
  {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(color: Colors.grey[800]),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
      HomeCard(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "About the App",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold
                      
                      // fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,

                  ),
                ),
              ],
            ),
          ],
      ),
      HomeCard(
          children: <Widget>[
            Text(
              """The App shows you the weather at your location after sunset, along with a 24 hourcloud cover forecast and visibility in km. 
              \nYou also get information about the phases, rise/set time, past/future dates of new moon and full moon. 
              \nYou can also check out the brightest celestial bodies in view at night. 
              \nThis information is meant to help you plan your observations/stargazing sessions. 
              
              Clear Skies! :)""",
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
                letterSpacing: 1,
                
                // fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
          ],
      ),
          // SizedBox(height: 100,),
          HomeCard(
            children: <Widget>[FlatButton.icon(
              onPressed: () async
              {
                final Email email = Email(
                body: 'Hey good job with the App!',
                subject: 'Great App!',
                recipients: ['aniansh@yahoo.com'],
                isHTML: false,
                );
                try
                {
                  await FlutterEmailSender.send(email);
                }
                catch(e)
                {
                  print("Something Went wrong! \n$e");
                }
              },
              icon: Icon(
                Icons.thumb_up,
                size: 35,
                color: Colors.grey,
                ),
              label: Flexible(
                                  child: Text(
                  "Send A Thumbs Up to the Dev?",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
              ),
              
              
              
              ),
            ]
          )
            ],

          ),
        ),
      ),
    );
      
    
  }
}