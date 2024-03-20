import 'package:flutter/material.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceOfInterests extends StatefulWidget {
  const PlaceOfInterests({super.key});

  @override
  State<PlaceOfInterests> createState() => _PlaceOfInterestsState();
}

class _PlaceOfInterestsState extends State<PlaceOfInterests> {
  late Position currentPosition;
  late double lat;
  late double lon;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try{
        currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true,
      );
        lat = currentPosition.latitude;
        lon = currentPosition.longitude;
      print('lat:- $lat and lon:- $lon');
    } catch (e){
      print(e);
    }
  }

  getNearbyPlaces(double latitude, double longitude,
      String type) async {
    const apiKey = 'AIzaSyCTcc0okRqXnFjCqMxyK0qolmZdD1Mdss4';
    const radius = 5000;
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=$latitude,$longitude'
        '&radius=$radius'
        '&type=$type'
        '&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('awa oi');
      // final Map<String, dynamic> data = json.decode(response.body);
      // if (data['status'] == 'OK') {
      //   final List<dynamic> results = data['results'];
      //   return results.map<Map<String, dynamic>>((result) {
      //     return {
      //       'name': result['name'],
      //       'vicinity': result['vicinity'],
      //       'latitude': result['geometry']['location']['lat'],
      //       'longitude': result['geometry']['location']['lng'],
      //     };
      //   }).toList();
      // } else {
      //   throw Exception('Failed to fetch nearby places');
      // }
    } else {
      throw Exception('Failed to fetch nearby places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: Text("Place Of Interests"),
      ),
      body: FutureBuilder(
        future: getCurrentLocation(), // This should return a Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Now that we have the location, we can safely use lat and lon
            return Column(
              children: [
                TextButton(
                  onPressed: () {
                    getNearbyPlaces(lat, lon, "pharmacy");
                  },
                  child: Text("click me"),
                ),
              ],
            );
          } else {
            // While waiting for the location, show a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

}
