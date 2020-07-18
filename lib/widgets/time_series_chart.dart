import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';



//  domainAxisTickProvider not implemented correctly
// fixed

//  Line annotation color
//fixed

class SimpleTimeSeriesChart extends StatelessWidget 
{
  final List<charts.Series> seriesList;
  final bool animate;
  final double height;

  SimpleTimeSeriesChart(this.seriesList, {this.animate, this.height=300});



  @override
  Widget build(BuildContext context) 
  {


    final staticTicksDomain = <charts.TickSpec<DateTime>>[
      new charts.TickSpec(
          // Value must match the domain value.
          seriesList[0].data[0].time,
          // Optional label for this tick, defaults to domain value if not set.
          // label: '%',
          // The styling for this tick.
          style: new charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[300])
              )
              ),
      // If no text style is specified - the style from renderSpec will be used
      // if one is specified.
      // new charts.TickSpec(10),
      new charts.TickSpec(seriesList[0].data[3].time),
      new charts.TickSpec(seriesList[0].data[6].time),
      new charts.TickSpec(seriesList[0].data[9].time),
      new charts.TickSpec(seriesList[0].data[12].time),
      new charts.TickSpec(seriesList[0].data[15].time),
      new charts.TickSpec(seriesList[0].data[18].time),
      new charts.TickSpec(seriesList[0].data[21].time),
      // new charts.TickSpec(seriesList[0].data[seriesList[0].data.length-1].time),

      
    ];
    final staticTicksMeasure = <charts.TickSpec<int>>[
      new charts.TickSpec(
          // Value must match the domain value.
          0,
          // Optional label for this tick, defaults to domain value if not set.
          // label: '%',
          // The styling for this tick.
          style: new charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[300])
              )
              ),
      // If no text style is specified - the style from renderSpec will be used
      // if one is specified.
      // new charts.TickSpec(10),
      new charts.TickSpec(20),
      new charts.TickSpec(40),
      new charts.TickSpec(60),
      new charts.TickSpec(80),
      new charts.TickSpec(100),
      
    ];

    final customTickFormatter = charts.BasicNumericTickFormatterSpec((num value) => '${value.round()} %');

    return Container(
      height: height,
          child: new charts.TimeSeriesChart(
        
        seriesList,
        animate: animate,
        behaviors: [charts.RangeAnnotation([
           
            charts.LineAnnotationSegment(
            seriesList[0].data[0].sunRise, charts.RangeAnnotationAxisType.domain,
            startLabel: 'Sunrise\n',
            color: charts.ColorUtil.fromDartColor(Colors.orange[900]),
            labelStyleSpec: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[100]),
              // fontSize: 8
              // fontWeight: "bold",
            ),
            labelDirection: charts.AnnotationLabelDirection.horizontal,
            labelPosition: charts.AnnotationLabelPosition.margin,
            labelAnchor: charts.AnnotationLabelAnchor.end,
            
            ),
            charts.LineAnnotationSegment(
            seriesList[0].data[0].sunSet, charts.RangeAnnotationAxisType.domain,
            startLabel: 'Sunset\n',
            color: charts.ColorUtil.fromDartColor(Colors.orange[900]),
            labelStyleSpec: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[100]),
              // fontSize: 8
              // fontWeight: "bold",
            ),
            labelDirection: charts.AnnotationLabelDirection.horizontal,
            labelPosition: charts.AnnotationLabelPosition.margin,
            labelAnchor: charts.AnnotationLabelAnchor.end,
            
            ),
      ])],
        defaultRenderer: new charts.LineRendererConfig(
          includeArea: true, 
          stacked: true,
          includePoints: false,
          ),
        primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            axisLineStyle: charts.LineStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[300]),
            ),
            labelStyle: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[300]),
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[300].withOpacity(0.2)),
            )
          ),
          // tickProviderSpec: charts.BasicNumericTickProviderSpec(dataIsInWholeNumbers: true, desiredMaxTickCount: 10,desiredMinTickCount: 5),
          tickProviderSpec: charts.StaticNumericTickProviderSpec(staticTicksMeasure),
          tickFormatterSpec: customTickFormatter
          ),
        domainAxis: new charts.DateTimeAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            axisLineStyle: charts.LineStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.white),
            ),
            labelStyle: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[300]),
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey[300].withOpacity(0.2)),
            )
          ),
            tickProviderSpec: charts.StaticDateTimeTickProviderSpec(staticTicksDomain),
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                // day: new charts.TimeFormatterSpec(
                //     format: 'd', 
                //     transitionFormat: 'dd'
                //     ),
            hour: charts.TimeFormatterSpec(
              format: 'h',
              transitionFormat: 'h'
              ),
            )),
        
              
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        // dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
    
  }

}
