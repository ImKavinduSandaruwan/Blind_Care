import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceOfInterests extends StatefulWidget {
  @override
  _PlaceOfInterestsState createState() => _PlaceOfInterestsState();
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
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true,
      );
      lat = currentPosition.latitude;
      lon = currentPosition.longitude;
      print('lat:- $lat and lon:- $lon');
    } catch (e) {
      print(e);
    }
  }

  // Future<List<Map<String, dynamic>>> getNearbyPlaces(double latitude, double longitude, String type) async {
  //   const apiKey = 'AIzaSyCTcc0okRqXnFjCqMxyK0qolmZdD1Mdss4';
  //   const radius = 5000;
  //   final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
  //       'location=$latitude,$longitude'
  //       '&radius=$radius'
  //       '&type=$type'
  //       '&key=$apiKey';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     if (data['status'] == 'OK') {
  //       final List<dynamic> results = data['results'];
  //       return results.map<Map<String, dynamic>>((result) {
  //         return {
  //           'name': result['name'],
  //           'vicinity': result['vicinity'],
  //           'latitude': result['geometry']['location']['lat'],
  //           'longitude': result['geometry']['location']['lng'],
  //         };
  //       }).toList();
  //     } else {
  //       throw Exception('Failed to fetch nearby places');
  //     }
  //   } else {
  //     throw Exception('Failed to fetch nearby places');
  //   }
  // }

  // void fetchNearbyPharmaciesAndHotel(double latitude, double longitude) {
  //   getNearbyPlaces(latitude, longitude, 'pharmacy').then((pharmacies) {
  //     getNearbyPlaces(latitude, longitude, 'lodging').then((hotels) {
  //       List<Map<String, dynamic>> places = [];
  //       places.addAll(pharmacies);
  //       places.addAll(hotels);
  //
  //       showModalBottomSheet(
  //         context: context,
  //         isScrollControlled: true,
  //         builder: (context) {
  //           return ListView.builder(
  //             itemCount: places.length,
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 title: Text(places[index]['name']),
  //                 subtitle: Text(places[index]['vicinity']),
  //               );
  //             },
  //           );
  //         },
  //       );
  //     }).catchError((e) {
  //       print('Error fetching nearby hotels: $e');
  //     });
  //   }).catchError((e) {
  //     print('Error fetching nearby pharmacies: $e');
  //   });
  // }


  // Simulated method to fetch nearby places
  Future<List<Map<String, dynamic>>> simulateFetchNearbyPlaces() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      {
        "name": "Pharmacy A",
        "vicinity": "123 Main St, Anytown",
        "latitude": 37.421999,
        "longitude": -122.084057
      },
      {
        "name": "Hotel B",
        "vicinity": "456 Elm St, Anytown",
        "latitude": 37.422999,
        "longitude": -122.085057
      },
      {
        "name": "Restaurant C",
        "vicinity": "789 Oak St, Anytown",
        "latitude": 37.423999,
        "longitude": -122.086057
      },
      {
        "name": "Grocery Store D",
        "vicinity": "1011 Pine St, Anytown",
        "latitude": 37.424999,
        "longitude": -122.087057
      },
      {
        "name": "Coffee Shop E",
        "vicinity": "1213 Maple St, Anytown",
        "latitude": 37.425999,
        "longitude": -122.088057
      },
      {
        "name": "Library F",
        "vicinity": "1415 Birch St, Anytown",
        "latitude": 37.426999,
        "longitude": -122.089057
      },
      {
        "name": "Park G",
        "vicinity": "1617 Cedar St, Anytown",
        "latitude": 37.427999,
        "longitude": -122.090057
      },
      {
        "name": "Gym H",
        "vicinity": "1819 Elmwood St, Anytown",
        "latitude": 37.428999,
        "longitude": -122.091057
      },
      {
        "name": "Hospital I",
        "vicinity": "2021 Oakwood St, Anytown",
        "latitude": 37.429999,
        "longitude": -122.092057
      },
      {
        "name": "Bank J",
        "vicinity": "2223 Pinewood St, Anytown",
        "latitude": 37.430999,
        "longitude": -122.093057
      },
      {
        "name": "Cinema K",
        "vicinity": "2425 Maplewood St, Anytown",
        "latitude": 37.431999,
        "longitude": -122.094057
      },
      {
        "name": "Museum L",
        "vicinity": "2627 Birchwood St, Anytown",
        "latitude": 37.432999,
        "longitude": -122.095057
      },
      {
        "name": "Pet Store M",
        "vicinity": "2829 Cedarwood St, Anytown",
        "latitude": 37.433999,
        "longitude": -122.096057
      },
      {
        "name": "Florist N",
        "vicinity": "3031 Elmwood St, Anytown",
        "latitude": 37.434999,
        "longitude": -122.097057
      },
      {
        "name": "Bookstore O",
        "vicinity": "3233 Oakwood St, Anytown",
        "latitude": 37.435999,
        "longitude": -122.098057
      },
      {
        "name": "Café P",
        "vicinity": "3435 Pinewood St, Anytown",
        "latitude": 37.436999,
        "longitude": -122.099057
      },
      {
        "name": "Bakery Q",
        "vicinity": "3637 Maplewood St, Anytown",
        "latitude": 37.437999,
        "longitude": -122.100057
      },
      {
        "name": "Fitness Center R",
        "vicinity": "3839 Birchwood St, Anytown",
        "latitude": 37.438999,
        "longitude": -122.101057
      },
      {
        "name": "Art Gallery S",
        "vicinity": "4041 Cedarwood St, Anytown",
        "latitude": 37.439999,
        "longitude": -122.102057
      },
      {
        "name": "Music Store T",
        "vicinity": "4243 Elmwood St, Anytown",
        "latitude": 37.440999,
        "longitude": -122.103057
      },
      {
        "name": "Café U",
        "vicinity": "4445 Pinewood St, Anytown",
        "latitude": 37.441999,
        "longitude": -122.104057
      },
      {
        "name": "Bakery V",
        "vicinity": "4647 Maplewood St, Anytown",
        "latitude": 37.442999,
        "longitude": -122.105057
      },
      {
        "name": "Fitness Center W",
        "vicinity": "4849 Birchwood St, Anytown",
        "latitude": 37.443999,
        "longitude": -122.106057
      },
      {
        "name": "Art Gallery X",
        "vicinity": "5051 Cedarwood St, Anytown",
        "latitude": 37.444999,
        "longitude": -122.107057
      },
      {
        "name": "Music Store Y",
        "vicinity": "5253 Elmwood St, Anytown",
        "latitude": 37.445999,
        "longitude": -122.108057
      },
      {
        "name": "Café Z",
        "vicinity": "5455 Pinewood St, Anytown",
        "latitude": 37.446999,
        "longitude": -122.109057
      }
    ];
  }

  void fetchNearbyPharmaciesAndHotel(double latitude, double longitude) {
    simulateFetchNearbyPlaces().then((places) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              //color: Colors.green,
              border: Border.all(color: Colors.black)
            ),
            height: MediaQuery.of(context).size.height/2, // Set the fixed height here
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
      print('Error simulating fetching nearby places: $e');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Of Interests"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    fetchNearbyPharmaciesAndHotel(lat, lon);
                  },
                  child: Text("Find Nearby Places"),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
