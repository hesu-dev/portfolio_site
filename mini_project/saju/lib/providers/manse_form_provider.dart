import 'package:flutter/material.dart';

enum Gender { female, male }

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.female:
        return '여성';
      case Gender.male:
        return '남성';
    }
  }
}

class ManseFormProvider extends ChangeNotifier {
  String? name;
  Gender? gender;
  DateTime? birthDate;
  TimeOfDay? birthTime;
  bool timeUnknown = false;
  bool isYajaJoja = false;
  String? city;

  bool get isValid =>
      name != null &&
      gender != null &&
      birthDate != null &&
      (timeUnknown || birthTime != null) &&
      city != null;

  void notify() => notifyListeners();

  void fillTestData() {
    name = '테스트네임';
    gender = Gender.female;
    birthDate = DateTime(1990, 12, 06);
    birthTime = const TimeOfDay(hour: 05, minute: 0);
    timeUnknown = false;
    isYajaJoja = false;
    city = '부산특별시';

    notifyListeners();
  }
}
