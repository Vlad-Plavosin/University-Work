import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsightsScreen extends StatefulWidget {
  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}


class _InsightsScreenState extends State<InsightsScreen> {

  List<Map<String, dynamic>> _courses = []; // List of strings to store genres
  List<Map<String, dynamic>> _coursestemp = []; // List of strings to store genres
  bool _isOffline = false;
  int courselen = 0;



  @override
  void initState() {
    super.initState();
    _checkConnectionRecipes(); // Fetch recipes when the screen loads
  }

  Future<void> _checkConnectionRecipes() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      _showOfflineMessage();
    } else {
      // Fetch data from the server
      _fetchAllGenres();
    }
  }
  void _showOfflineMessage() {
    setState(() {
      _isOffline = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('You are offline. This is available only online.'),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: _checkConnectionRecipes,
      ),
    ));
  }

  Future<void> _fetchAllGenres() async {
    final response = await http.get(Uri.parse('http://localhost:2506/allCourses'));

    if (response.statusCode == 200) {
      final List<dynamic> recipesJson = json.decode(response.body);
      setState(() {
        _coursestemp = recipesJson.map((recipe) => Map<String, dynamic>.from(recipe)).toList();
      });
      print("Fetched transactions successfully.");
    } else {
      throw Exception("Failed to load transactions. Status code: ${response.statusCode}");
    }
    setState(() {
      _courses = _coursestemp.where((course) => course['status'] == "ongoing").toList();
    });
    courselen = _courses.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Courses'),
      ),
      body: _courses.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if list is empty
          : ListView.builder(
        itemCount: courselen,
        itemBuilder: (context, index) {
          final workout = _courses[index]; // Access each genre string
          return ListTile(
            title: Text(workout['name'].toString()),
            subtitle: Text("${workout['duration']}, ${workout['status']}, ${workout['students']}"),
          );
        },
      ),
    );
  }
}

