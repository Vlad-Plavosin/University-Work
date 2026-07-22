import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ongoing_screen.dart';
import 'recipe_edit_screen.dart';
import 'recipe_add_screen.dart';
import 'explore_screen.dart';
import 'recipe_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = false; // To track if data is being loaded
  bool _isOffline = false;
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _checkConnectionCourses(); // Fetch recipes when the screen loads
    _connectToWebSocket();
  }
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
  // Connect to WebSocket
  void _connectToWebSocket() {
    // Establish a WebSocket connection to the server
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:2506'), // Assuming the WebSocket server is running on this URL
    );

    // Listen for incoming messages (e.g., new transaction or recipe data)
    _channel.stream.listen((message) {
      // Log the received message for debugging
      print("Received message: $message");

      // Parse the received message
      final data = json.decode(message);
      // Show the received data in a Snackbar
      _showNewElementSnackbar(data);
    });
  }
  void _showNewElementSnackbar(Map<String, dynamic> course) {
    // Log to check if this function is called
    print("Showing Snackbar with data: ${course['name']}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New Workout: ${course['name']}, Description: ${course['description']}, Trainer: ${course['instructor']}'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _checkConnectionCourses() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      _showOfflineMessage();
      _loadOfflineData(); // Load data from local storage
    } else {
      // Fetch data from the server
      _fetchRecipes();
    }
  }
  Future<void> _saveWorkoutsLocally(List<Map<String, dynamic>> recipes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedRecipes', json.encode(recipes));
  }

  Future<void> _loadOfflineData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('cachedRecipes');
    if (cachedData != null) {
      setState(() {
        _courses = List<Map<String, dynamic>>.from(json.decode(cachedData));
      });
    }
  }

  void _showOfflineMessage() {
    setState(() {
      _isOffline = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('You are offline. Showing cached data.'),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: _checkConnectionCourses,
      ),
    ));
  }

  // Function to fetch recipes
  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    await Future.delayed(Duration(seconds: 2));

    // Log server interaction
    print("Fetching recipes from server...");

    try {
      final response = await http.get(Uri.parse('http://localhost:2506/courses'));

      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = json.decode(response.body);
        setState(() {
          _courses = recipesJson.map((recipe) => Map<String, dynamic>.from(recipe)).toList();
        });
        print("Fetched transactions successfully.");

        _saveWorkoutsLocally(_courses);
      } else {
        throw Exception("Failed to load transactions. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Show error using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load recipes: $e')));

      // Log the error
      print("Error fetching recipes: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide progress indicator
      });
    }
  }

  // Navigate to the Edit Screen
  void _goToEditScreen(int recipeId, Map<String, dynamic> existingRecipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeEditScreen(
          recipeId: recipeId,
          existingRecipe: existingRecipe,
          onRecipeUpdated: _fetchRecipes, // Pass the callback to refresh the list
        ),
      ),
    );
  }

  // Navigate to the Add Screen
  void _goToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeAddScreen(
          onRecipeAdded: _fetchRecipes, // Pass the callback to fetch recipes after adding
        ),
      ),
    );
  }

  // Navigate to the Explore Screen
  void _goToExploreScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExploreScreen(),
      ),
    );
  }
  void _goToInsightsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsightsScreen(),
      ),
    );
  }

  // Navigate to the Detail Screen
  void _goToDetailScreen(Map<String, dynamic> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeId: recipe['id'],onRecipeUpdated: _fetchRecipes), // Navigate to detail screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchRecipes, // Refresh the list on button press
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _goToAddScreen, // Navigate to the add recipe screen
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _goToExploreScreen, // Navigate to the explore screen
          ),
          IconButton(
            icon: Icon(Icons.charging_station),
            onPressed: _goToInsightsScreen, // Navigate to the explore screen
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if loading
          : ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return ListTile(
            title: Text(course['name'].toString()),
            subtitle: Text("${course['id']}, ${course['instructor']}, ${course['description']}"),
            onTap: () => _goToDetailScreen(course), // Navigate to the detail screen when tapped
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _goToEditScreen(course['id'], course),
            ),
          );
        },
      ),
    );
  }
}
