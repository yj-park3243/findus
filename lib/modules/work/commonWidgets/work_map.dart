import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/distanceCalc.dart';
import 'package:findus/constants/style.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorkMap extends StatefulWidget {
  late final String title;

  @override
  _WorkMapState createState() => _WorkMapState();
}

class _WorkMapState extends State<WorkMap> {
  late GoogleMapController googleMapcontroller;
  List<BitmapDescriptor>? pinLocationIcon = [];
  WorkController workController = Get.put(WorkController());
  MapController mapController = Get.put(MapController());

  @override
  void initState() {
    super.initState();
  }


  void _currentLocation() async {
    final GoogleMapController controller = await googleMapcontroller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(mapController.currentPostion.latitude, mapController.currentPostion.longitude),
        zoom: 17.0,
      ),
    ));
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final Set<Marker> markers = new Set();

  addMarker(BuildContext context) {
      setState(() {
        markers.add(Marker(
          infoWindow: InfoWindow(title: workController.work.value?.subject , snippet: getDistance(workController.work.value?.workLat as double, workController.work.value?.workLng as double, mapController.currentPostion.latitude, mapController.currentPostion.longitude).toString() ),
          markerId: const MarkerId('work'),
          position: LatLng(workController.work.value?.workLat as double, workController.work.value?.workLng as double),
          onTap: () => {},
        ));
      });
  }

  Position currentPosition = Position(
      accuracy: 0,
      altitude: 0,
      heading: 0,
      latitude: 37.48498465726607,
      longitude: 127.12152495566875,
      speed: 0,
      speedAccuracy: 0,
      timestamp: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text('지도로보기'.tr,
            style: tapMenuTitleTextStyle),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: Platform.isAndroid ? false:true,
            initialCameraPosition: CameraPosition(
              target: LatLng(workController.work.value?.workLat as double, workController.work.value?.workLng as double),
              zoom: 14.4746,
            ),
            markers: markers,
            onLongPress: (e) {
              print(e.latitude);
              print(e.longitude);
            },
            onMapCreated: (GoogleMapController controller1) {
              addMarker(context);
              controller1
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target:
                LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 14.4746,
              )));
              googleMapcontroller = controller1;
              mapController.googleMapcontroller = controller1;
              googleMapcontroller.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(
                        workController.work.value?.workLat as double, workController.work.value?.workLng as double),
                    zoom: 14.4746,
                  )));
              googleMapcontroller.showMarkerInfoWindow(const MarkerId('work') );
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Get.width*85/100,Get.height*70/100,10,0),

            child: Platform.isAndroid ? FloatingActionButton(
              heroTag: "googleMap",
              onPressed: _currentLocation,
              child: const Icon(EvaIcons.plusCircleOutline),
              foregroundColor: Color.fromARGB(255, 0, 0, 0),
              backgroundColor: Color.fromARGB(200, 255, 255, 255),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(CommonRadius.m))),
            ) : SizedBox(),
          ),
        ],
      ),
    );
  }
}
