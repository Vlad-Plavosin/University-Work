import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../trip_provider.dart';

class ReadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trips = context.watch<TripProvider>().trips;

    return Scaffold(
      appBar: AppBar(
        title: Text('View Trips'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create');
            },
            child: Text('Add Trip'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Card(
                  child: ListTile(
                    title: Text('${trip.destination}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cost: ${trip.cost}'),
                        Text('People: ${trip.people}'),
                        Text('Start: ${trip.startDate.toLocal()}'),
                        Text('End: ${trip.endDate.toLocal()}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(context, '/update', arguments: trip);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/delete_confirm',
                              arguments: trip.id,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
