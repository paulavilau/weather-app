import 'package:clima/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String? cityName;
  List<String> recentCities = [];

  @override
  void initState() {
    super.initState();
    fetchRecentSearches();
  }

  // Extrage ultimele 5 cautari ale userului
  Future<void> fetchRecentSearches() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('search_history')
        .where('userUid', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .limit(5) // Ultimele 5 căutări
        .get();

    List<String> cities =
        snapshot.docs.map((doc) => doc['city_name'] as String).toList();

    setState(() {
      recentCities = cities;
    });
  }

  // Adauga orasul cautat in istoric (Firebase)
  Future<void> saveCitySearch(String city) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Adauga orasul in istoric doar daca nu exista deja
    var existingCity = await FirebaseFirestore.instance
        .collection('search_history')
        .where('userUid', isEqualTo: user.uid)
        .where('city_name', isEqualTo: city)
        .get();

    if (existingCity.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('search_history').add({
        'userUid': user.uid,
        'city_name': city,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizare interfata
      fetchRecentSearches();
    } else {
      print("City already exists in search history");
    }
  }

  // Sterge istoricul de cautare
  Future<void> clearSearchHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('search_history')
        .where('userUid', isEqualTo: user.uid)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    setState(() {
      recentCities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 40.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          cityName = value;
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          icon: Icon(Icons.location_city, color: Colors.white),
                          hintText: "Enter city name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Ultimele cautari
                      recentCities.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Recent Searches:",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: clearSearchHistory,
                                      child: const Text(
                                        "Clear",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: recentCities.map((city) {
                                    return ListTile(
                                      title: Text(
                                        city,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      leading: const Icon(Icons.history,
                                          color: Colors.white),
                                      onTap: () {
                                        Navigator.pop(context, city);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (cityName != null && cityName!.isNotEmpty) {
                      await saveCitySearch(cityName!);
                      Navigator.pop(context, cityName!);
                    }
                  },
                  child: const Text(
                    'Get Weather',
                    style: kButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
