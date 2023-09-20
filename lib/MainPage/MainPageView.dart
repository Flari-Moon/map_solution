import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:map_solution/MainPage/MainPageViewModel.dart';

import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPageView extends StatelessWidget {
  //============= CONTROLLERS

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainPageViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _topBar(context, model),
              _centralContent(context, model),
              _bottomAppBar(context, model),
            ],
          ),
        );
      },
      viewModelBuilder: () => MainPageViewModel(),
      onViewModelReady: (model) => [],
    );
  }

  Widget _topBar(BuildContext context, MainPageViewModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Text(
              "Map Solution",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 48,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  controller: model.cep,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CEP',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  controller: model.addr,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address name',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  controller: model.nmbr,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'number',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  controller: model.neighbourhood,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Neighbourhood',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.05,
                child: IconButton(
                  focusColor: Colors.blueAccent,
                  color: Colors.black,
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    var fullAddress =
                        "${model.cep.text},${model.addr.text},${model.nmbr.text},${model.neighbourhood.text}";
                    model.findAddress(fullAddress);
                    model.notifyListeners();
                    model.finddata(model.cep.text);
                    model.notifyListeners();
                  },
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                  onPressed: () {
                    model.getUserCurrentLocation();
                  },
                  child: Text("Find My Location"))),
        ],
      ),
    );
  }

  Widget _centralContent(BuildContext context, MainPageViewModel model) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.25,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.65,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                  itemCount: model.displayStoreData.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        Text(
                            "${(jsonDecode(model.displayStoreData[i])['name'])}"),
                        Container(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ListView.builder(
                              itemCount:
                                  jsonDecode(model.displayStoreData[i])['links']
                                      .length,
                              itemBuilder: (BuildContext context, int y) {
                                return Text(
                                  "Item $y: ${jsonDecode(model.displayStoreData[i])['links'][y]}",
                                );
                              }),
                        ),
                        Container(
                          height: 10,
                        ),
                      ],
                    );
                  },
                )),
            Container(
              width: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.65,
              child: GoogleMap(
                compassEnabled: true,
                onLongPress: (position) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController controllerPin =
                          TextEditingController();
                      // retorna um objeto do tipo Dialog
                      return AlertDialog(
                        alignment: Alignment.topLeft,
                        title: Text("Describe new marker"),
                        content: TextFormField(
                          controller: controllerPin,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'new marker description',
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: new Text("Add Pin"),
                            onPressed: () {
                              model.addMarker(position, controllerPin.text);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                onCameraMove: (position) {},
                onMapCreated: (GoogleMapController controller) =>
                    model.mapController.complete(controller),
                initialCameraPosition: CameraPosition(
                  target: model.currentPosition,
                  zoom: 12.0,
                ),
                markers: model.markers,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomAppBar(BuildContext context, MainPageViewModel model) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.02,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 30,
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
