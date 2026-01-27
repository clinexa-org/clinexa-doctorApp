import '../../domain/entities/clinic_entity.dart';

class ClinicModel extends ClinicEntity {
  const ClinicModel({
    required super.id,
    required super.name,
    required super.address,
    super.phone,
    super.latitude,
    super.longitude,
    super.city,
    super.locationLink,
    required super.slotDuration,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;

    if (json['location'] != null && json['location']['coordinates'] != null) {
      final coords = json['location']['coordinates'] as List;
      if (coords.length >= 2) {
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    }

    return ClinicModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'],
      latitude: lat,
      longitude: lng,
      city: json['city'],
      locationLink: json['location_link'],
      slotDuration: json['slotDurationMinutes'] ??
          json['slot_duration'] ??
          30, // Support both keys
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      if (phone != null) 'phone': phone,
      if (city != null) 'city': city,
      if (locationLink != null) 'location_link': locationLink,
      'slot_duration': slotDuration,
    };
  }
}
