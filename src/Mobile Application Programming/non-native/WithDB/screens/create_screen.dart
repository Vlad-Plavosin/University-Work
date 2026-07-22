import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../trip_provider.dart';
import '../models/trip.dart';

class CreateScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: 'Destination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _peopleController,
                decoration: InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of people';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  _startDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                },
                child: Text('Select Start Date'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _endDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                },
                child: Text('Select End Date'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true &&
                      _startDate != null &&
                      _endDate != null) {
                    final trip = Trip(
                      id: 0,
                      destination: _destinationController.text,
                      cost: int.parse(_costController.text),
                      people: int.parse(_peopleController.text),
                      startDate: _startDate!,
                      endDate: _endDate!,
                    );

                    context.read<TripProvider>().addTrip(trip);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
