import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectblindcare/constants/constant.dart';
import 'package:projectblindcare/screens/poi_google_map_screen.dart';

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

  /// Asynchronously retrieves the current location of the device.
  /// This function uses the Geolocator package to get the device's current position with low accuracy.
  /// It also forces the use of the Android location manager for better compatibility.
  /// Upon successful retrieval, it stores the latitude and longitude, fetches nearby pharmacies and hotels,
  /// and returns the current position.
  /// In case of failure, it prints the error and throws an exception.
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


  /// Asynchronously fetches nearby places of a specified type within a 5000-meter radius.
  /// This function constructs a URL for the Google Places API with the provided latitude, longitude, and type.
  /// It then sends a GET request to the API and processes the response to extract relevant place information.
  /// The function returns a list of maps, each containing the name, vicinity, latitude, and longitude of a nearby place.
  /// In case of an error or if the API response is not OK, it throws an exception.
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

  /// Fetches nearby pharmacies and hotels based on the provided latitude and longitude.
  /// This function first retrieves a list of nearby pharmacies and then a list of nearby hotels.
  /// It combines these lists into a single list of places and displays them in a modal bottom sheet.
  /// The modal bottom sheet is dynamically sized to fit the content and provides a scrollable list of places.
  /// In case of errors while fetching pharmacies or hotels, it displays an error message using a SnackBar.
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

