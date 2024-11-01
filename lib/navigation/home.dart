import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty/modules/home/entities/restaurant.dart';
import 'package:empty/modules/home/screens/content_column.dart';
import 'package:empty/modules/widgets/details_restaurant.dart';
import 'package:empty/modules/widgets/list_restaurant_data.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = FirebaseFirestore.instance;
  List<Restaurant> restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    try {
      db.collection('restaurants').snapshots().listen((snapshot) {
        final fetchedRestaurants = snapshot.docs.map((doc) {
          return Restaurant(
            doc['name'],
            doc['description'],
            List<String>.from(doc['images']),
            doc['rating'],
            doc['count'],
          );
        }).toList();
        restaurants.clear();
        setState(() {
          restaurants = fetchedRestaurants;
          isLoading = false;
        });
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching restaurants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          // Implement the action for the FloatingActionButton here
        },
        child: const Icon(Icons.star_rate),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            for (var restaurant in restaurants)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsRestaurant(restaurant: restaurant),
                    ),
                  );
                },
                child: ListRestaurantData(restaurant: restaurant),
              ),
          ],
        ),
      ),
    );
  }
}
