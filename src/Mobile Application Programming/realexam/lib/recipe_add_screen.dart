import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeAddScreen extends StatefulWidget {
  final Function onRecipeAdded;

  RecipeAddScreen({required this.onRecipeAdded});

  @override
  _RecipeAddScreenState createState() => _RecipeAddScreenState();
}

class _RecipeAddScreenState extends State<RecipeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _instructor = '';
  String _description = '';
  int _students = 0;
  int _duration = 0;
  String _status = '';

  Future<void> _addRecipe() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final response = await http.post(
        Uri.parse('http://localhost:2506/course'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'instructor': _instructor,
          'name': _name,
          'description': _description,
          'students': _students,
          'status': _status,
          'duration': _duration
        }),
      );

      if (!mounted) return; // Check if the widget is still in the tree

      if (response.statusCode == 201) {
        widget.onRecipeAdded(); // Refresh the list after adding
        Navigator.pop(context); // Go back to the list screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add course')));
        print("Failed to add course. Status code: ${response.statusCode}");

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Instructor'),
                onSaved: (value) => _instructor = value!,
                validator: (value) => value!.isEmpty ? 'Please enter instructor' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Students'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _students = int.tryParse(value!) ?? 0,
                validator: (value) => value!.isEmpty ? 'Please enter students' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _duration = int.tryParse(value!) ?? 0,
                validator: (value) => value!.isEmpty ? 'Please enter a duration' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Status'),
                onSaved: (value) => _status = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a status' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addRecipe,
                child: Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
