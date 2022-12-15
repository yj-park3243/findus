import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:findus/modules/map/search/mongol_town.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMap extends StatefulWidget {
  late final String title;

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  late GoogleMapController googleMapcontroller;
  List<BitmapDescriptor>? pinLocationIcon = List.filled(30, BitmapDescriptor.defaultMarker) ;

  @override
  void initState() {
    super.initState();
  }

  Future<void> setCustomMapPin() async {
    for (var i = 0; i < mapController.mapCategory.value.length; i++) {
      pinLocationIcon?[mapController.mapCategory.value[i].locationCategoryId as int] =  await getBitmapDescriptorFromAssetBytes(
          'assets/find_us_images/map/' + mapController.mapCategory.value[i].categoryNameEn! + '.png', 85);
    }
  }

  void _currentLocation() async {
    final GoogleMapController controller = await googleMapcontroller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 17.0,
      ),
    ));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  MapController mapController = Get.put(MapController());

  // 이 값은 지도가 시작될 때 첫 번째 위치입니다.

  // 지도 클릭 시 표시할 장소에 대한 마커 목록
  final Set<Marker> markers = new Set();

  addMarker(BuildContext context) async {

    await setCustomMapPin();
    for (var i = 0; i < mapController.mapData.length; i++) {
      var e = mapController.mapData[i];
      if (e.latitude == null || e.longitude == null || e.parent_id != null) continue;
      setState(() {
        markers.add(Marker(
          markerId: MarkerId(e.locationId.toString()),
          position: LatLng(e.latitude as double, e.longitude as double),
          icon: pinLocationIcon?[(e.locationCategoryId as int) ] ??
              BitmapDescriptor.defaultMarker,
          onTap: () {
            if(e.arr_yn ==false){
              mapController.onMarkerTap(e);
            }else{
              mapController.selectedLocation.value = e;
              Get.to(() => const MongolTown(),
                  transition: Transition.rightToLeft);
            }
          },
        ));
      });
    }
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
      body: Stack(
        children: [
          GoogleMap(
            minMaxZoomPreference: MinMaxZoomPreference(7.5, 18),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: Platform.isAndroid ? false : true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(47.87971643818456, 106.90982446074486),
              zoom: 14.4746,
            ),
            markers: markers,
            onLongPress: (e) {
              print(e.latitude);
              print(e.longitude);
            },
            onMapCreated: (GoogleMapController controller1) {
              controller1
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target:
                    LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 14.4746,
              )));
              googleMapcontroller = controller1;
              mapController.googleMapcontroller = controller1;
              getCurrentLocation().then((val) => setState(() {
                    currentPosition = val;
                    googleMapcontroller.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(
                          currentPosition.latitude, currentPosition.longitude),
                      zoom: 14.4746,
                    )));
                  }));
              addMarker(context);
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Get.width * 85 / 100, Get.height * 50 / 100, 10, 0),
            child: Platform.isAndroid
                ? FloatingActionButton(
                    heroTag: "googleMap",
                    onPressed: _currentLocation,
                    child: const Icon(EvaIcons.plusCircleOutline),
                    foregroundColor: Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: Color.fromARGB(200, 255, 255, 255),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(CommonRadius.m))),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
