import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_edit_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  final Function onRecipeUpdated;  // Callback to update recipe in the parent widget

  RecipeDetailScreen({required this.recipeId, required this.onRecipeUpdated});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic>? course;
  bool isLoading = true;

  Future<void> _fetchRecipeDetails() async {
    final response = await http.get(Uri.parse('http://localhost:2506/course/${widget.recipeId}'));
    if (response.statusCode == 200) {
      setState(() {
        course = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load course details');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecipeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course?['name'] ?? 'Loading...'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: ${course!['id']}'),
            Text('name: ${course!['name']}'),
            Text('description: ${course!['description']}'),
            Text('students: ${course!['students']}'),
            Text('status: ${course!['status']}'),
            Text('instructor: ${course!['instructor']}'),
            Text('duration: ${course!['duration']}'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
