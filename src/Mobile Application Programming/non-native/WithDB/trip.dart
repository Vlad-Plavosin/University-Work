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

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      cost: map['cost'],
      people: map['people'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      destination: map['destination'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cost': cost,
      'people': people,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'destination': destination,
    };
  }
}
