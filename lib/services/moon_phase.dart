import 'package:intl/intl.dart';
// ! Increase Accuracy!
class Phase
{

  String prevFullMoon;
  String prevNewMoon;
  String nextFullMoon;
  String nextNewMoon;
  String riseTime;
  String setTime;
  int phaseDay;
  int illumination; // ! Not linearly dependent!
  List<String> phases =[
    "New Moon",
    "Young Moon",
    "Waxing Crescent", 
    "First Quarter", 
    "Waxing Gibbous", 
    "Full Moon", 
    "Waning Gibbous", 
    "Last Quarter", 
    "Waning Crescent",
    "Old Moon"
    ];
  int phase;

  Phase()
  {
    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;
    int year = now.year;
    dynamic r = year%100;
    r%=19;
    if(r>9)
    {
      r-=19;
    }
    r=((r*11)%30) + month + day;
    if(month<3)
    {
      r+=2;
    }
    if(year<2000)
    {
      r-=4;
    }
    else
    {
      r-=8.3;
    }
    r+=0.5;
    r=r.floor();
    r%=30;
    if(r<0)
    {
      r+=30;
    }
    this.phaseDay=r.round();
    if(r<=15)
    {
      this.illumination = ((r/15)*100).round();
    }
    else
    {
      this.illumination=(((30-r)/15)*100).round();
    }
    
    switch(phaseDay)
    {
      case 29:
      case 0:
        this.phase=0;
        break;
      case 1:
      case 2:
        this.phase=1;
        break;
      case 3:
      case 4:
      case 5:
      case 6:
        this.phase=2;
        break;
      case 7:
        this.phase=3;
        break;
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
        this.phase=4;
        break;
      case 14:
      case 15:
        this.phase=5;
        break;
      case 16:
      case 17:
      case 18:
      case 19:
      case 20:
      case 21:
        this.phase=6;
        break;
      case 22:
        this.phase=7;
        break;
      case 23:
      case 24:
      case 25:
      case 26:
        this.phase=8;
        break;
      case 27:
      case 28:
        this.phase=9;
        break; 
    }
    // * Calculating rise time and set time

    double rise_time=(6+((this.phaseDay/30)*24))%24;
    double set_time=(18+((this.phaseDay/30)*24))%24;
    this.setTime = neatTime(set_time);
    this.riseTime = neatTime(rise_time);

    // * Calculating New Moons and Full Moons

    DateTime pf,pn,nf,nn;

    // this.phaseDay=16;

    if(this.phaseDay < 15)
    {
      pn=now.subtract(Duration(days: this.phaseDay));
      pf=now.subtract(Duration(days: this.phaseDay+15));
      nf=now.add(Duration(days: 15-this.phaseDay));
      nn=now.add(Duration(days: 30-this.phaseDay));
    }
    else
    {
      pn=now.subtract(Duration(days: this.phaseDay));
      pf=now.subtract(Duration(days: this.phaseDay-15));
      nf=now.add(Duration(days: 45-this.phaseDay));
      nn=now.add(Duration(days: 30-this.phaseDay));
    }
    this.prevNewMoon = neatDate(pn);
    this.prevFullMoon = neatDate(pf);
    this.nextNewMoon = neatDate(nn);
    this.nextFullMoon = neatDate(nf);





  }

  // zero padded output needed
  //done
  String neatTime(double t)
  {
    int i = t.floor();
    // bool pm = i~/12==0 ? false:true;
    int minute = ((t-i)*60).round();
    // int hour = i%12;
    
    return DateFormat('jm').format(DateTime(2020, 6,5,i,minute));
    // return "$hour:$minute ${pm ? "PM" : "AM"}";
  }

  String neatDate(DateTime t)
  {
    List<String> months=[
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return "${t.day} ${months[t.month-1]}";
  }


}