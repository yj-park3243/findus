import 'package:latlong2/latlong.dart';

final Distance distance = Distance();

String getDistance(double a ,double b, double c,double d ){
  final double dis = distance.as(LengthUnit.Meter,
      LatLng(a, b), LatLng(c, d));
  final km = dis/1000;
  if( km > 100 ){
    return '${km.round().toString()}Km';
  }else if(km > 1){
    return '${km.toStringAsFixed(1)}Km';
  }else{
    return '${dis}m';
  }

}