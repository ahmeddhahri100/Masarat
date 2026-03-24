import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://wuugnobbycfpnceuysov.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind1dWdub2JieWNmcG5jZXV5c292Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MzM1MTAsImV4cCI6MjA4OTQwOTUxMH0.FHzJNuBgfXqMV664xtPLUZYjkgy5FXdTjk1ZVYlmYNY',
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
