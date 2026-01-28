import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

// 1. Enums & Models
enum AlertSensitivity {
  quiet,
  standard,
  active;

  String get label => name[0].toUpperCase() + name.substring(1);
}

// 사용자 지정 위치 모델
class CustomLocation {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final bool isActive;

  CustomLocation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.isActive = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lng': lng,
      'isActive': isActive,
    };
  }

  factory CustomLocation.fromJson(Map<String, dynamic> json) {
    return CustomLocation(
      id: json['id'],
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
      isActive: json['isActive'] ?? false,
    );
  }

  CustomLocation copyWith({
    String? id,
    String? name,
    double? lat,
    double? lng,
    bool? isActive,
  }) {
    return CustomLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isActive: isActive ?? this.isActive,
    );
  }
}

// 2. State Class (Immutable)
class SettingsState {
  final AlertSensitivity sensitivity;
  final bool morningBriefEnabled;
  final TimeOfDay morningBriefTime;
  final bool weekendAlertsEnabled;
  final List<CustomLocation> customLocations;
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({
    this.sensitivity = AlertSensitivity.standard,
    this.morningBriefEnabled = true,
    this.morningBriefTime = const TimeOfDay(hour: 7, minute: 30),
    this.weekendAlertsEnabled = false,
    this.customLocations = const [],
    this.themeMode = ThemeMode.light, // Default to Light
    this.locale = const Locale('ko'), // Default to Korean
  });

  SettingsState copyWith({
    AlertSensitivity? sensitivity,
    bool? morningBriefEnabled,
    TimeOfDay? morningBriefTime,
    bool? weekendAlertsEnabled,
    List<CustomLocation>? customLocations,
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsState(
      sensitivity: sensitivity ?? this.sensitivity,
      morningBriefEnabled: morningBriefEnabled ?? this.morningBriefEnabled,
      morningBriefTime: morningBriefTime ?? this.morningBriefTime,
      weekendAlertsEnabled: weekendAlertsEnabled ?? this.weekendAlertsEnabled,
      customLocations: customLocations ?? this.customLocations,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

// 3. Notifier (Logic)
class SettingsNotifier extends Notifier<SettingsState> {
  late Box _box;

  @override
  SettingsState build() {
    if (Hive.isBoxOpen('settings')) {
      _box = Hive.box('settings');
      return _loadFromHive();
    } else {
      return const SettingsState();
    }
  }

  SettingsState _loadFromHive() {
    final sensitivityIndex = _box.get('alert_sensitivity', defaultValue: 1); // 1: standard
    final mbEnabled = _box.get('morning_brief_enabled', defaultValue: true);
    final mbTimeStr = _box.get('morning_brief_time', defaultValue: "07:30");
    final weekendAlerts = _box.get('weekend_alerts', defaultValue: false);
    
    // Custom Locations
    final List<dynamic> locationsJson = _box.get('custom_locations', defaultValue: []);
    final locations = locationsJson.map((e) => CustomLocation.fromJson(jsonDecode(e))).toList();

    // Theme & Locale
    final themeIndex = _box.get('theme_mode', defaultValue: 1); // 0: system, 1: light, 2: dark. Let's say Default is Light(1)
    final languageCode = _box.get('locale', defaultValue: 'ko');

    // TimeOfDay Parsing
    final timeParts = mbTimeStr.split(':');
    final time = TimeOfDay(
      hour: int.parse(timeParts[0]), 
      minute: int.parse(timeParts[1])
    );

    return SettingsState(
      sensitivity: AlertSensitivity.values[sensitivityIndex],
      morningBriefEnabled: mbEnabled,
      morningBriefTime: time,
      weekendAlertsEnabled: weekendAlerts,
      customLocations: locations,
      themeMode: ThemeMode.values[themeIndex],
      locale: Locale(languageCode),
    );
  }

  // --- Actions ---

  Future<void> setSensitivity(AlertSensitivity value) async {
    state = state.copyWith(sensitivity: value);
    await _box.put('alert_sensitivity', value.index);
  }

  Future<void> setMorningBrief(bool enabled) async {
    state = state.copyWith(morningBriefEnabled: enabled);
    await _box.put('morning_brief_enabled', enabled);
  }

  Future<void> setMorningBriefTime(TimeOfDay time) async {
    state = state.copyWith(morningBriefTime: time);
    final timeStr = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    await _box.put('morning_brief_time', timeStr);
  }

  Future<void> setWeekendAlerts(bool enabled) async {
    state = state.copyWith(weekendAlertsEnabled: enabled);
    await _box.put('weekend_alerts', enabled);
  }

  // --- Custom Locations Actions ---
  
  Future<void> addLocation(CustomLocation location) async {
    final newLocations = [...state.customLocations, location];
    state = state.copyWith(customLocations: newLocations);
    await _saveLocations(newLocations);
  }

  Future<void> removeLocation(String id) async {
    final newLocations = state.customLocations.where((l) => l.id != id).toList();
    state = state.copyWith(customLocations: newLocations);
    await _saveLocations(newLocations);
  }

  Future<void> toggleLocationActive(String id) async {
    final newLocations = state.customLocations.map((loc) {
      if (loc.id == id) {
        // Toggle Active Logic:
        // If clicking on already active, maybe do nothing or defined by requirement?
        // Requirement says: "Select to change (active)". So if I click one, it becomes active, others inactive?
        // Let's implement: Clicked one becomes Active, others Inactive. (Single Selection)
        // Or if the switch is "Toggle", then it's multi-active?
        // Request says: "변경시 메인페이지 위치가 변경됨" -> Implies Single Active Selection for Main Page.
        return loc.copyWith(isActive: true);
      } else {
        return loc.copyWith(isActive: false);
      }
    }).toList();
    
    state = state.copyWith(customLocations: newLocations);
    await _saveLocations(newLocations);
  }

  Future<void> _saveLocations(List<CustomLocation> locations) async {
    final List<String> jsonList = locations.map((e) => jsonEncode(e.toJson())).toList();
    await _box.put('custom_locations', jsonList);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _box.put('theme_mode', mode.index);
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _box.put('locale', locale.languageCode);
  }
}

// 4. Provider Definition
final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
