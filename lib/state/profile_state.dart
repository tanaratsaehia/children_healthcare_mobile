import 'package:flutter_riverpod/flutter_riverpod.dart';

class BabyProfile {
  final String age;
  final String weight;
  final String gender;
  final String gestationalAge;

  BabyProfile({
    this.age = '',
    this.weight = '',
    this.gender = '',
    this.gestationalAge = '',
  });
}

class ProfileNotifier extends Notifier<BabyProfile> {
  @override
  BabyProfile build() {
    return BabyProfile(); 
  }

  void saveProfile({
    required String age,
    required String weight,
    required String gender,
    required String gestationalAge,
  }) {
    state = BabyProfile(
      age: age,
      weight: weight,
      gender: gender,
      gestationalAge: gestationalAge,
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, BabyProfile>(() {
  return ProfileNotifier();
});