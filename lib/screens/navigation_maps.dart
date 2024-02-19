import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';


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
  final TextEditingController _destinationController = TextEditingController();
  Set<Marker> markers = {};
  Position? currentPosition;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  DetailsResult? endPosition;
  late FocusNode endFocusNode;

  double? s1,s2,e1,e2;

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String apiKey = "";

  @override
  void initState() {
    super.initState();
    apiKey = 'AIzaSyBhwULmCSuNyr7hpqt-u9zEHydv31ucMfo';
    googlePlace = GooglePlace(apiKey);

    _getCurrentLocation();

    endFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    endFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation'),
      ),
      body: Stack(
        children: [
          if (currentPosition != null)
            GoogleMap(
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                ),
                zoom: 15.0,
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
                  focusNode: endFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter Destination',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(),
                    suffixIcon: _destinationController.text.isNotEmpty
                        ? IconButton(
                            onPressed: (){
                              setState(() {
                                predictions = [];
                                _destinationController.clear();
                              });
                            },
                          icon: const Icon(Icons.clear_outlined),
                        )
                  :null),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      setState(() {
                        predictions = [];
                        endPosition = null;
                      });
                    }
                  },
                ),
                Container(
                  color: Colors.blueGrey,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          predictions[index].description.toString(),
                        ),
                        onTap: () async {
                          final placeId = predictions[index].placeId!;
                          final details = await googlePlace.details.get(placeId);
                          if(details != null && details.result != null && mounted) {
                            setState(() {
                              endPosition = details.result;
                              _destinationController.text = details.result!.name!;
                              predictions = [];
                            });
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                  child: TextButton(
                    onPressed: () {
                      _setDestination();
                      _getPolyline();
                    },
                    child: Text('Start', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  void autoCompleteSearch(String value) async{
    var result = await googlePlace.autocomplete.get(value);
    if(result != null && result.predictions != null && mounted){
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
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
      setState(() {
        currentPosition = position;
        markers.clear();
        markers.add(
          Marker(
            markerId: MarkerId('Start'),
            position: LatLng(position.latitude, position.longitude),
            )
        );
      });
    }
    catch (e){
      print('Error getting current location: $e');
    }
  }

  void _setDestination() async {
    s1 = currentPosition?.latitude;
    s2 = currentPosition?.longitude;
    e1 = endPosition!.geometry!.location!.lat!;
    e2 = endPosition!.geometry!.location!.lng!;

    double? ne1, ne2, sw1, sw2;
    if(s1!>e1!){
      ne1 = s1;
      sw1 = e1;
    } else{
      ne1 = e1;
      sw1 = s1;
    }
    if(s2!>e2!){
      ne2 = s2;
      sw2 = e2;
    } else{
      ne2 = e2;
      sw2 = s2;
    }
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(sw1!-0.1,sw2!-0.1), northeast: LatLng(ne1!+0.1,ne2!+0.1)),
      1
    ));
    markers.remove('End');
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('End'),
          position: LatLng(
              endPosition!.geometry!.location!.lat!,
              endPosition!.geometry!.location!.lng!
          ),
        ),
      );
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates, width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(s1!, s2!),
        PointLatLng(e1!, e2!),
        travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

}