import '../../features/location/entities/location_entity.dart';

abstract interface class ILocationRepository {
  Future<LocationEntity> getCurrentLocation();

  Future<LocationEntity> reverseGeocode(double lat, double lng);

  Future<List<LocationEntity>> searchCities(String query);

  Future<LocationEntity?> getCachedLocation();

  Future<void> cacheLocation(LocationEntity location);
}

enum LocationExceptionCode {
  serviceDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  timeout,
  unavailable,
}

class LocationException implements Exception {
  const LocationException(this.code, this.message);

  final LocationExceptionCode code;
  final String message;

  @override
  String toString() => 'LocationException($code): $message';
}
