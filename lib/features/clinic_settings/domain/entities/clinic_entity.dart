import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? locationLink;
  final int slotDuration;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.latitude,
    this.longitude,
    this.city,
    this.locationLink,
    required this.slotDuration,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        latitude,
        longitude,
        city,
        locationLink,
        slotDuration
      ];
}
