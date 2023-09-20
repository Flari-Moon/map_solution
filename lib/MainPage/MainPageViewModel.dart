import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js_interop';

import 'dart:math';

import 'package:flutter/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoder2/geocoder2.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPageViewModel extends BaseViewModel {
  var storeData = {
    '69088-282': {
      'name': "Rua São Raimundo",
      'links': [
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
      ]
    },
    '59078-040': {
      'name': "Rua dos Gerânios",
      'links': [
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
        'https://randomstore.com',
      ]
    },
  };

  var displayStoreData = [];
  var cep = TextEditingController();
  var addr = TextEditingController();
  var nmbr = TextEditingController();
  var neighbourhood = TextEditingController();

  static const kGoogleApiKey = "AIzaSyDp7JPEBwPmlSSZC80bRkN3VdJSranMBgE";

  var currentPosition = LatLng(20.42796133580664, 75.885749655962);

  Set<Marker> markers = {};

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  void MapCreate() async {
    final LatLng _center = const LatLng(45.521563, -122.677433);
  }

  String generateRandomString(int len) {
    var r = Random();
    String randomString =
        String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
    return randomString;
  }

  addMarker(position, description) async {
    var id = generateRandomString(20);
    markers.add(Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(
        title: description,
      ),
    ));
    notifyListeners();
  }

  changePosition(newPosition) async {
    CameraPosition cameraPosition = new CameraPosition(
      target: newPosition,
      zoom: 14,
    );

    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  findAddress(address) async {
    GeoData data = await Geocoder2.getDataFromAddress(
        address: address,
        googleMapApiKey: "AIzaSyDp7JPEBwPmlSSZC80bRkN3VdJSranMBgE");

    var newPosition = LatLng(data.latitude, data.longitude);

    changePosition(newPosition);
  }

  finddata(sentCep) async {
    if (storeData.containsKey(sentCep) == true) {
      displayStoreData.add(jsonEncode(storeData[sentCep]));
      notifyListeners();
    }

    notifyListeners();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });

    var location = await Geolocator.getCurrentPosition();

    currentPosition = LatLng(location.latitude, location.longitude);

    markers.add(Marker(
      markerId: MarkerId("2"),
      position: currentPosition,
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),
    ));
    CameraPosition cameraPosition = new CameraPosition(
      target: currentPosition,
      zoom: 14,
    );

    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    displayStoreData.add('rua doutor clemente segundo pinho');
    print(displayStoreData);
    notifyListeners();
    return location;
  }
}
