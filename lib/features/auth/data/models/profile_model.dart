enum UserRole { doctor, patient }

class Profile {
  Profile({required this.id, required this.role, this.fullName});

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'].toString(),
      fullName: map['full_name'].toString(),
      role: map['role'] == 'doctor' ? UserRole.doctor : UserRole.patient,
    );
  }
  final String id;
  final String? fullName;
  final UserRole role;
}
