import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectblindcare/constants/constant.dart';

class PlaceOfInterests extends StatefulWidget {
  @override
  _PlaceOfInterestsState createState() => _PlaceOfInterestsState();
}

class _PlaceOfInterestsState extends State<PlaceOfInterests> {

  late Position currentPosition;
  late double lat;
  late double lon;
  Future<Position>? _locationFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = getCurrentLocation();
  }

  Future<Position> getCurrentLocation() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true,
      );
      lat = currentPosition.latitude;
      lon = currentPosition.longitude;
      fetchNearbyPharmaciesAndHotel(lat, lon);
      return currentPosition;
    } catch (e) {
      print(e);
      throw Exception('Failed to get location');
    }
  }


  ///This method is responsible for make a http request using API key and fetch
  ///relevant places according to the current location
  Future<List<Map<String, dynamic>>> getNearbyPlaces(double latitude, double longitude, String type) async {
    const apiKey = 'AIzaSyCTcc0okRqXnFjCqMxyK0qolmZdD1Mdss4';
    const radius = 5000;
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=$latitude,$longitude'
        '&radius=$radius'
        '&type=$type'
        '&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final List<dynamic> results = data['results'];
        return results.map<Map<String, dynamic>>((result) {
          return {
            'name': result['name'],
            'vicinity': result['vicinity'],
            'latitude': result['geometry']['location']['lat'],
            'longitude': result['geometry']['location']['lng'],
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch nearby places');
      }
    } else {
      throw Exception('Failed to fetch nearby places');
    }
  }

  ///This method is responsible for fetching nearby pharmacies and hotels
  void fetchNearbyPharmaciesAndHotel(double latitude, double longitude) {
    getNearbyPlaces(latitude, longitude, 'pharmacy').then((pharmacies) {
      getNearbyPlaces(latitude, longitude, 'lodging').then((hotels) {
        List<Map<String, dynamic>> places = [];
        places.addAll(pharmacies);
        places.addAll(hotels);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  border: Border.all(color: Colors.black)
              ),
              height: MediaQuery.of(context).size.height/2,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(places[index]['name']),
                    subtitle: Text(places[index]['vicinity']),
                  );
                },
              ),
            );
          },
        );
      }).catchError((e) {
        print('Error fetching nearby hotels: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching nearby hotels: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }).catchError((e) {
      print('Error fetching nearby pharmacies: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching nearby pharmacies: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: Text("Place Of Interests"),
      ),
      body: FutureBuilder<Position>(
        future: _locationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              lat = snapshot.data!.latitude;
              lon = snapshot.data!.longitude;
              return Stack(
                children: [
                  GoogleMapScreen(latitude: lat, longitude: lon),
                  Positioned(
                    bottom: 0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(mainThemeColor),
                      ),
                      onPressed: () {
                        fetchNearbyPharmaciesAndHotel(lat, lon);
                      },
                      child: Text("Find Nearby Places"),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('Failed to get location'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class GoogleMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  GoogleMapScreen({required this.latitude, required this.longitude});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController _controller;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 14.4746,
      ),
    );
  }
}

