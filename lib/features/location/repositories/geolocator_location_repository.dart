import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/repositories/i_location_repository.dart';
import '../entities/location_entity.dart';

const locationCacheBoxName = 'location_cache';

class GeolocatorLocationRepository implements ILocationRepository {
  GeolocatorLocationRepository({Box<dynamic>? cacheBox})
    : _cacheBox = cacheBox ?? Hive.box<dynamic>(locationCacheBoxName);

  static const _lastLocationKey = 'last_location';
  static const _timeout = Duration(seconds: 10);

  final Box<dynamic> _cacheBox;

  @override
  Future<LocationEntity> getCurrentLocation() async {
    await _ensureLocationAccess();

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _timeout,
        ),
      );

      final location = await reverseGeocode(
        position.latitude,
        position.longitude,
      );
      await cacheLocation(location);
      return location;
    } on TimeoutException {
      throw const LocationException(
        LocationExceptionCode.timeout,
        'Không lấy được vị trí trong 10 giây.',
      );
    } on LocationServiceDisabledException {
      throw const LocationException(
        LocationExceptionCode.serviceDisabled,
        'Dịch vụ vị trí đang tắt.',
      );
    } on PermissionDeniedException {
      throw const LocationException(
        LocationExceptionCode.permissionDenied,
        'Ứng dụng chưa được cấp quyền vị trí.',
      );
    }
  }

  @override
  Future<LocationEntity> reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      final placemark = placemarks.isEmpty ? null : placemarks.first;
      return LocationEntity(
        name: _nameFromPlacemark(placemark),
        lat: lat,
        lng: lng,
        country: placemark?.country ?? placemark?.isoCountryCode ?? '',
      );
    } on Exception {
      throw const LocationException(
        LocationExceptionCode.unavailable,
        'Không thể chuyển tọa độ thành địa chỉ.',
      );
    }
  }

  @override
  Future<List<LocationEntity>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    try {
      final locations = await locationFromAddress(trimmed);
      final unique = <String, LocationEntity>{};

      for (final location in locations.take(5)) {
        final item = await _locationForSearchResult(location, trimmed);
        unique['${item.lat.toStringAsFixed(4)}_${item.lng.toStringAsFixed(4)}'] =
            item;
      }

      return unique.values.toList(growable: false);
    } on Exception {
      throw const LocationException(
        LocationExceptionCode.unavailable,
        'Không thể tìm thành phố.',
      );
    }
  }

  @override
  Future<LocationEntity?> getCachedLocation() async {
    final raw = _cacheBox.get(_lastLocationKey);
    if (raw is Map) return LocationEntity.fromJson(raw);
    return null;
  }

  @override
  Future<void> cacheLocation(LocationEntity location) {
    return _cacheBox.put(_lastLocationKey, location.toJson());
  }

  Future<void> _ensureLocationAccess() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        LocationExceptionCode.serviceDisabled,
        'Dịch vụ vị trí đang tắt.',
      );
    }

    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isPermanentlyDenied) {
      throw const LocationException(
        LocationExceptionCode.permissionPermanentlyDenied,
        'Quyền vị trí đã bị chặn vĩnh viễn trong cài đặt.',
      );
    }

    if (!status.isGranted) {
      throw const LocationException(
        LocationExceptionCode.permissionDenied,
        'Ứng dụng chưa được cấp quyền vị trí.',
      );
    }
  }

  Future<LocationEntity> _locationForSearchResult(
    Location location,
    String fallbackName,
  ) async {
    try {
      return await reverseGeocode(location.latitude, location.longitude);
    } on LocationException {
      return LocationEntity(
        name: fallbackName,
        lat: location.latitude,
        lng: location.longitude,
        country: '',
      );
    }
  }

  String _nameFromPlacemark(Placemark? placemark) {
    if (placemark == null) return 'Vị trí hiện tại';

    final parts = [
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
    ].where((part) => part != null && part.trim().isNotEmpty).cast<String>();

    return parts.isEmpty ? placemark.country ?? 'Vị trí hiện tại' : parts.first;
  }
}
