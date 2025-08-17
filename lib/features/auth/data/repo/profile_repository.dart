import 'dart:developer';

import 'package:doctor_app/core/constants.dart';
import 'package:doctor_app/features/auth/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile(String userId);
  Future<Profile?> getDoctor();
}

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return Profile.fromMap(response);
    } catch (e) {
      log('Error getting profile: $e');
      return null;
    }
  }

  @override
  Future<Profile?> getDoctor() async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('role', 'doctor')
          .limit(1)
          .single();
      return Profile.fromMap(response);
    } catch (e) {
      log('Error getting doctor: $e');
      return null;
    }
  }
}
