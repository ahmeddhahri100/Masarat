import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

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

  // Messages & Conversations
  static Stream<List<MessageModel>> getMessagesStream(String tripId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('trip_id', tripId)
        .order('created_at', ascending: true)
        .map((data) => data.map((json) => MessageModel.fromJson(json)).toList());
  }

  static Future<List<ConversationModel>> getUserConversations(
      String userId) async {
    // This would typically involve a complex query or a database view.
    // For now, let's mock it with some real-looking data but fetch what we can.
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ConversationModel(
        otherUserId: '1',
        otherUserName: 'Sami Rebai',
        lastMessage: 'I will be at the TGM station at 8.',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        isUnread: true,
        tripRoute: 'Tunis → Hammamet',
      ),
      ConversationModel(
        otherUserId: '2',
        otherUserName: 'Fatma B.',
        lastMessage: 'Request accepted! See you tomorrow.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        isUnread: false,
        tripRoute: 'Ariana → Sousse',
      ),
    ];
  }

  static Future<List<TripModel>> searchTrips(String query) async {
    final response = await client
        .from('trips')
        .select('*, profiles(name, avatar_url)')
        .or('departure.ilike.%$query%,destination.ilike.%$query%')
        .order('date', ascending: false);
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
