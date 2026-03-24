import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class SupabaseService {
  static Future<void> initialize() async {
    print('Initializing Supabase...');
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

  static Future<void> createTrip(TripModel trip) async {
    await client.from('trips').insert(trip.toJson());
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

  // Messages & Conversations
  static Stream<List<MessageModel>> getMessagesStream(String tripId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('trip_id', tripId)
        .order('created_at', ascending: true)
        .map((data) => data.map((json) => MessageModel.fromJson(json)).toList());
  }

  static Future<void> sendMessage(MessageModel message) async {
    await client.from('messages').insert(message.toJson());
  }

  static Future<List<ConversationModel>> getUserConversations(
      String userId) async {
    // In a real scenario, this would be a more complex query or a RPC call.
    // For now, let's fetch all messages involving the user and group them.
    final response = await client
        .from('messages')
        .select('*, profiles:sender_id(name, avatar_url)')
        .or('sender_id.eq.$userId,receiver_id.eq.$userId')
        .order('created_at', ascending: false);

    final messages = (response as List).map((json) => MessageModel.fromJson(json)).toList();
    
    // Simple grouping logic
    final Map<String, ConversationModel> conversations = {};
    for (var msg in messages) {
      final otherId = msg.senderId == userId ? msg.receiverId : msg.senderId;
      if (!conversations.containsKey(otherId)) {
        conversations[otherId] = ConversationModel(
          otherUserId: otherId,
          otherUserName: 'User $otherId', // In real, join with profiles
          lastMessage: msg.content,
          lastMessageTime: msg.timestamp,
          isUnread: false, 
          tripRoute: 'Trip Details', 
        );
      }
    }
    return conversations.values.toList();
  }
}
