import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: MyApp(),

    ),
  );
}

class Trip {
  final int id;
  final int cost;
  final int people;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;

  Trip({
    required this.id,
    required this.cost,
    required this.people,
    required this.startDate,
    required this.endDate,
    required this.destination,
  });

  Trip copyWith({
    int? id,
    int? cost,
    int? people,
    DateTime? startDate,
    DateTime? endDate,
    String? destination,
  }) {
    return Trip(
      id: id ?? this.id,
      cost: cost ?? this.cost,
      people: people ?? this.people,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destination: destination ?? this.destination,
    );
  }
}

class TripProvider extends ChangeNotifier {
  final List<Trip> _trips = [

    Trip(id: 1, cost: 300, people: 5, startDate: DateTime(2023, 6, 15), endDate: DateTime(2023, 6, 20), destination: 'Paris'),
    Trip(id: 2, cost: 150, people: 3, startDate: DateTime(2023, 7, 10), endDate: DateTime(2023, 7, 15), destination: 'New York'),
    Trip(id: 3, cost: 500, people: 8, startDate: DateTime(2023, 8, 5), endDate: DateTime(2023, 8, 12), destination: 'Tokyo'),
  ];

  List<Trip> get trips =>  _trips;

  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  void updateTrip(Trip updatedTrip) {
    final index =_trips.indexWhere((trip) => trip.id == updatedTrip.id);
    if (index !=-1) {
      _trips[index]=updatedTrip;
      notifyListeners();
    }
  }

  void deleteTrip(int id) {
    _trips.removeWhere((trip) => trip.id == id);
    notifyListeners();
  }

  Trip getTripById(int id) {
    return _trips.firstWhere((trip) => trip.id == id);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/read': (context) => ReadScreen(),
        '/create': (context) => CreateScreen(),
        '/update': (context) => UpdateScreen(),
        '/delete_confirm': (context) => DeleteConfirmationScreen(
            tripId: ModalRoute.of(context)?.settings.arguments as int),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Trip Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/read');
              },
              child: Text('Start Planning'),

            ),
          ],
        ),
      ),
    );
  }
}

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

class CreateScreen extends StatelessWidget {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            TextField(
              controller: costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: peopleController,
              decoration: InputDecoration(labelText: 'People'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(labelText: 'Start Date (yyyy-MM-dd)'),
            ),
            TextField(
              controller: endDateController,
              decoration: InputDecoration(labelText: 'End Date (yyyy-MM-dd)'),
            ),
            ElevatedButton(
              onPressed: () {
                final tripProvider = context.read<TripProvider>();
                final newTrip = Trip(
                  id: tripProvider.trips.length + 1,
                  cost: int.tryParse(costController.text) ?? 0,
                  people: int.tryParse(peopleController.text) ?? 0,
                  startDate: DateTime.tryParse(startDateController.text) ?? DateTime.now(),
                  endDate: DateTime.tryParse(endDateController.text) ?? DateTime.now(),
                  destination: destinationController.text,
                );
                tripProvider.addTrip(newTrip);
                Navigator.pop(context);
              },
              child: Text('Add Trip'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Trip trip = ModalRoute.of(context)?.settings.arguments as Trip;
    final TextEditingController destinationController = TextEditingController(text: trip.destination);
    final TextEditingController costController = TextEditingController(text: trip.cost.toString());
    final TextEditingController peopleController = TextEditingController(text: trip.people.toString());
    final TextEditingController startDateController = TextEditingController(text: trip.startDate.toIso8601String());
    final TextEditingController endDateController = TextEditingController(text: trip.endDate.toIso8601String());

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            TextField(
              controller: costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: peopleController,
              decoration: InputDecoration(labelText: 'People'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(labelText: 'Start Date (yyyy-MM-dd)'),
            ),
            TextField(
              controller: endDateController,
              decoration: InputDecoration(labelText: 'End Date (yyyy-MM-dd)'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedTrip = trip.copyWith(
                  destination: destinationController.text,
                  cost: int.tryParse(costController.text) ?? trip.cost,
                  people: int.tryParse(peopleController.text) ?? trip.people,
                  startDate: DateTime.tryParse(startDateController.text) ?? trip.startDate,
                  endDate: DateTime.tryParse(endDateController.text) ?? trip.endDate,
                );
                context.read<TripProvider>().updateTrip(updatedTrip);
                Navigator.pop(context);
              },
              child: Text('Update Trip'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteConfirmationScreen extends StatelessWidget {
  final int tripId;

  DeleteConfirmationScreen({required this.tripId});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final trip = tripProvider.getTripById(tripId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Deletion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to delete this trip?",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            Text("Destination: ${trip.destination}", style: TextStyle(fontSize: 18)),
            Text("Cost: \$${trip.cost}", style: TextStyle(fontSize: 18)),
            Text("People: ${trip.people}", style: TextStyle(fontSize: 18)),
            Text("Start Date: ${trip.startDate}", style: TextStyle(fontSize: 18)),
            Text("End Date: ${trip.endDate}", style: TextStyle(fontSize: 18)),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // On Confirm Delete
                    tripProvider.deleteTrip(tripId);
                    Navigator.popUntil(context, ModalRoute.withName('/read')); // Go back to trip list
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Confirm"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // On Cancel
                    Navigator.pop(context); // Just go back to the previous page
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
