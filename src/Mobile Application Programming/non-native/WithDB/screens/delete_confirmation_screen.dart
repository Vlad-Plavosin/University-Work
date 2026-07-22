import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../trip_provider.dart';

class DeleteConfirmationScreen extends StatelessWidget {
  final int tripId;

  const DeleteConfirmationScreen({required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Confirmation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Are you sure you want to delete this trip?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<TripProvider>().deleteTrip(tripId);
                  Navigator.popUntil(context, ModalRoute.withName('/read'));
                },
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
