class TripModel {
  final String id;
  final String driverId;
  final String from;
  final String to;
  final DateTime date;
  final String time;
  final int availableSeats;
  final double price;
  final bool isBoosted;
  final String? driverName;
  final String? driverAvatar;

  TripModel({
    required this.id,
    required this.driverId,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.availableSeats,
    required this.price,
    this.isBoosted = false,
    this.driverName,
    this.driverAvatar,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      from: json['departure'] as String,
      to: json['destination'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      availableSeats: json['seats'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isBoosted: json['is_boosted'] as bool? ?? false,
      driverName: json['profiles']?['name'] as String?,
      driverAvatar: json['profiles']?['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'departure': from,
      'destination': to,
      'date': date.toIso8601String(),
      'time': time,
      'seats': availableSeats,
      'price': price,
      'is_boosted': isBoosted,
    };
  }
}
