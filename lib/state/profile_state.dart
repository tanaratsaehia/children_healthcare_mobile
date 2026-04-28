import 'package:flutter_riverpod/flutter_riverpod.dart';

// The data model
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

// The modern Riverpod Notifier
class ProfileNotifier extends Notifier<BabyProfile> {
  @override
  BabyProfile build() {
    return BabyProfile(); // Initial empty state
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

// The provider we will call from any page to access the data
final profileProvider = NotifierProvider<ProfileNotifier, BabyProfile>(() {
  return ProfileNotifier();
});