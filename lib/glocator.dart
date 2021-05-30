import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';


class Glocator extends StatefulWidget {
  @override
  _GlocatorState createState() => _GlocatorState();
}

class _GlocatorState extends State<Glocator> {

  String latitutedata = ' ';
  String longgitutedata = ' ';
  Position _position;
  StreamSubscription<Position> _streamSubscription;
  Address _address;

  Future convertCoordinateToAddress(Coordinates coordinates) async {

    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return address.first;

  }

  getLocation() async {
    final geopostion = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _streamSubscription = Geolocator().getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        _position = position;

        final coordinates = new Coordinates(position.latitude, position.longitude);
        convertCoordinateToAddress(coordinates).then((value) => _address = value);
      });

    });

    setState(() {
      latitutedata = '${geopostion.latitude}';
      longgitutedata = '${geopostion.longitude}';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    //getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Locator"),
      ),
      body:Column(
        children: [
          Text(latitutedata),
          Text(longgitutedata),

          Container(
            child: Center(
              child: Text(
                '${_address?.addressLine??'loading'}\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xff966936),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
