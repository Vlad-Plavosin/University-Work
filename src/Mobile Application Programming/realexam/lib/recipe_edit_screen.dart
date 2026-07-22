import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeEditScreen extends StatefulWidget {
  final int recipeId;
  final Map<String, dynamic> existingRecipe;
  final Function onRecipeUpdated;

  RecipeEditScreen({
    required this.recipeId,
    required this.existingRecipe,
    required this.onRecipeUpdated,
  });

  @override
  _RecipeEditScreenState createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  dynamic _recipeId;
  bool _isLoading = false; // To track if data is being loaded


  @override
  void initState() {
    super.initState();
    this._recipeId = widget.recipeId;
  }
  Future<void> _deleteRecipe() async {
    final deleteResponse = await http.delete(
      Uri.parse('http://localhost:2506/course/${widget.recipeId}'),
    );
    if (deleteResponse.statusCode == 200) {
      widget.onRecipeUpdated();  // Refresh the list immediately
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Course with id ' + this._recipeId.toString()),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _deleteRecipe,
                child: Text('Delete Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
