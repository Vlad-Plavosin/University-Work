import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'ongoing_screen.dart';
import 'recipe_edit_screen.dart';
import 'recipe_add_screen.dart';
import 'explore_screen.dart';
import 'recipe_detail_screen.dart'; // Import the new detail screen

class ExploreScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<ExploreScreen> {
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = false; // To track if data is being loaded
  bool _isOffline = false;
  int courselen = 5;


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
      _fetchRecipes();
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

  // Function to fetch recipes
  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    // Log server interaction
    print("Fetching courses from server...");

    try {
      final response = await http.get(Uri.parse('http://localhost:2506/allCourses'));

      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = json.decode(response.body);
        setState(() {
          _courses = recipesJson.map((recipe) => Map<String, dynamic>.from(recipe)).toList();
        });
        print("Fetched Courses successfully.");
      } else {
        throw Exception("Failed to load courses. Status code: ${response.statusCode}");
      }
      if(courselen > _courses.length)
        courselen = _courses.length;
      _courses.sort((a, b) {
        int statusComparison = a['status'].compareTo(b['status']);
        if (statusComparison != 0) {
          return statusComparison; // If statuses are different, return the result of status comparison
        } else {
          return b['students'].compareTo(a['students']); // If statuses are the same, compare by students
        }
      });
    } catch (e) {
      // Show error using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load recipes: $e')));

      // Log the error
      print("Error fetching courses: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide progress indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses by Status and Student number'),
      ),
      body: _courses.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if list is empty
          : ListView.builder(
        itemCount: courselen,
        itemBuilder: (context, index) {
          final recipe = _courses[index];
          return ListTile(
            title: Text(recipe['name']),
            subtitle: Text("${recipe['duration']} ${recipe['status']} ${recipe['students']}"),
          );
        },
      ),

    );
  }
}
