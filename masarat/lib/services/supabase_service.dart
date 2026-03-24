import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://YOUR_PROJECT.supabase.co',
      anonKey:
          'YOUR_SUPABASE_ANON_KEY',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  // Trips
  static Stream<List<TripModel>> get tripsStream => client
      .from('trips')
      .stream(primaryKey: ['id'])
      .order('date', ascending: false)
      .map((data) => data.map((json) => TripModel.fromJson(json)).toList());

  static Future<List<TripModel>> getBoostedTrips() async {
    final response = await client
        .from('trips')
        .select('*, profiles(name, avatar_url)')
        .eq('is_boosted', true)
        .limit(5);
    return (response as List).map((json) => TripModel.fromJson(json)).toList();
  }

  static Future<List<TripModel>> getRecentTrips() async {
    final response = await client
        .from('trips')
        .select('*, profiles(name, avatar_url)')
        .order('date', ascending: false)
        .limit(10);
    return (response as List).map((json) => TripModel.fromJson(json)).toList();
  }

  // User Profiles
  static Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
