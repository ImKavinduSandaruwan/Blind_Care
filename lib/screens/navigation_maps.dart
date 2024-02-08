import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main(){
  runApp(mapPage());
}

class mapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavMaps',
      home: LocationMap(),
    );
  }
}

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  GoogleMapController? mapController;
  TextEditingController _destinationController = TextEditingController();
  Set<Marker> markers = {};
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation'),
      ),
      body: Stack(
        children: [
          GoogleMap(onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0.0, 0.0),
            zoom: 15.0
            ),
            myLocationEnabled: true,
            markers: markers,
            padding: const EdgeInsets.only(top: 100.0),
          ),
      Positioned(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  hintText: 'Enter Destination',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchDestination,
                  )
                ),
              )
            ],
        ),
      )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
    });
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 15.0
      ));
      setState(() {
        currentPosition = position;
        markers.clear();
        markers.add(
          Marker(
            markerId: MarkerId('My Location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(
              title: 'My Location',
            ),
          ),
        );
      });
    }
    catch (e){
      print('Error getting current location: $e');
    }
  }

  void _searchDestination() async {
    String destination = _destinationController.text;
    try{
      List<Location> locations = await locationFromAddress(destination);
      if (locations.isNotEmpty){
        final Location location = locations.first;
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(location.latitude,location.longitude), 15.0));
        setState(() {
          markers.clear();
          markers.add(
            Marker(
              markerId: MarkerId('Destination'),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: destination,
              ),
            ),
          );
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Place Not Found'),
                content: Text('No location found'),
                actions: <Widget>[
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                  ),
                ],
              );
            }
        );
      }
    }catch(e){
      print('Error $e');
    }
  }
}
