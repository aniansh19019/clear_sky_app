import 'dart:math';


// * check for null on datetime values
class RaDecToAltAz
{
    double ra = 250.425; // * RA in hours decimal
    double dec = 36.46667; // * dec in degrees
    double lat = 51.76954; // * lat in degrees
    double long = 4.605606; // * long in degrees
    double alt;
    double az;
    DateTime riseTime;
    DateTime setTime;
    bool alwaysAbove=false;
    bool alwaysBelow=false;

    RaDecToAltAz({this.ra, this.dec, this.lat, this.long});

    void calculate(DateTime date)
        {

          this.ra *=15;
          
          date= date.toUtc();
            // Day offset and Local Siderial Time
            int dayOffset = (date.difference(DateTime(2000, 1, 1, 12, 0, 0).toUtc())).inDays;

            double lst = (100.46 + (0.985647 * dayOffset) + long + 15 * (date.hour + (date.minute / 60.0) ) +360) % 360;
            // print("LST: $lst");

            // Hour Angle
            double ha = (lst - ra + 360) % 360;

            // ha, dEC, lat to alt, AZ
            double x = cos(ha * (pi / 180)) * cos(dec * (pi / 180));
            double y = sin(ha * (pi / 180)) * cos(dec * (pi / 180));
            double z = sin(dec * (pi / 180));

            double xhor = x * cos((90 - lat) * (pi / 180)) - z * sin((90 - lat) * (pi / 180));
            double yhor = y;
            double zhor = x * sin((90 - lat) * (pi / 180)) + z * cos((90 - lat) * (pi / 180));

            this.az = atan2(yhor, xhor) * (180 / pi) + 180;
            this.alt = asin(zhor) * (180 / pi);



            if((dec-lat).abs()>90)
            {
              this.alwaysBelow=true;
            }
            else if((dec+lat).abs()>90)
            {
              this.alwaysAbove=true;
            } 
            else
            {
              double riseHour=ra - acos(-(tan(dec*pi/180)*tan(lat*pi/180)))* (180 / pi);
              double setHour=ra + acos(-(tan(dec* (pi/180) )*tan(lat* (pi/180) )))* (180 / pi);
              riseHour/=15;
              setHour/=15;

              // riseHour = (riseHour+24)%24;
              // setHour = (setHour+24)%24;

              // print("risehour $riseHour \n setHour $setHour");


              DateTime now = DateTime.now();

              this.setTime = DateTime.utc(now.year, now.month, now.day, setHour.floor(), ((setHour-setHour.floor())*60).round() );
              this.riseTime = DateTime.utc(now.year, now.month, now.day, riseHour.floor(), ((riseHour-riseHour.floor())*60).round() );
              this.setTime = this.setTime.toLocal();
              this.riseTime = this.riseTime.toLocal();
            }
            
            
        }
    }
