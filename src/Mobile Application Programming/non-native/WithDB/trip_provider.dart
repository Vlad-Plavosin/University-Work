import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/trip.dart';

class TripProvider extends ChangeNotifier {
  final List<Trip> _trips = [];

  TripProvider() {
    fetchTrips();
  }

  List<Trip> get trips => _trips;

  Future<void> fetchTrips() async {
    final response = await Supabase.instance.client
        .from('trips')
        .select()
        .order('id', ascending: true);

    if (response != null) {
      _trips.clear();
      _trips.addAll(
        (response as List<dynamic>).map((item) => Trip.fromMap(item)),
      );
      notifyListeners();
    } else {
      print("Error fetching trips: Failed to fetch data");
    }
  }

  Future<void> addTrip(Trip trip) async {
    final response = await Supabase.instance.client
        .from('trips')
        .insert(trip.toMap());

    if (response == null) {
      await fetchTrips();
    } else {
      print("Error adding trip: Failed to insert data");
    }
  }

  Future<void> updateTrip(Trip updatedTrip) async {
    final response = await Supabase.instance.client
        .from('trips')
        .update(updatedTrip.toMap())
        .eq('id', updatedTrip.id);

    if (response == null) {
      await fetchTrips();
    } else {
      print("Error updating trip: Failed to update data");
    }
  }

  Future<void> deleteTrip(int id) async {
    final response = await Supabase.instance.client
        .from('trips')
        .delete()
        .eq('id', id);

    if (response == null) {
      await fetchTrips();
    } else {
      print("Error deleting trip: Failed to delete data");
    }
  }

  Trip getTripById(int id) {
    return _trips.firstWhere((trip) => trip.id == id);
  }
}
