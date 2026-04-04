import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class SupabaseService {
  static const String _supabaseUrl =
      'https://YOUR_PROJECT.supabase.co';
  static const String _anonKey =
      'YOUR_SUPABASE_ANON_KEY';

  static bool _isInitialized = false;
  static String? _initializationError;
  static SupabaseClient? _client;

  static bool get isInitialized => _isInitialized;
  static String? get initializationError => _initializationError;

  static Future<void> initialize() async {
    try {
      debugPrint('[Supabase] Initializing with URL: $_supabaseUrl');

      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _anonKey,
        debug: true,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );

      _client = Supabase.instance.client;
      _isInitialized = true;
      _initializationError = null;
      debugPrint('[Supabase] Initialized successfully');
    } catch (e, stackTrace) {
      _isInitialized = false;
      _initializationError = e.toString();
      debugPrint('[Supabase] Initialization failed: $e');
      debugPrint('[Supabase] Stack trace: $stackTrace');
      rethrow;
    }
  }

  static SupabaseClient get client {
    if (!_isInitialized) {
      throw StateError(
        'Supabase client accessed before initialization. '
        'Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  static SupabaseClient getAuthenticatedClient() {
    if (client.auth.currentSession == null) {
      throw StateError('User is not signed in.');
    }
    return client;
  }

  static Future<SupabaseClient> getAuthenticatedClientAsync() async {
    if (client.auth.currentSession == null) {
      throw StateError('User is not signed in.');
    }
    return client;
  }

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
    final authClient = await getAuthenticatedClientAsync();
    await authClient.from('trips').insert(trip.toJson());
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
    final authClient = await getAuthenticatedClientAsync();
    await authClient.from('messages').insert(message.toJson());
  }

  static Future<List<ConversationModel>> getUserConversations(
      String userId) async {
    final response = await client
        .from('messages')
        .select('*, profiles:sender_id(name, avatar_url)')
        .or('sender_id.eq.$userId,receiver_id.eq.$userId')
        .order('created_at', ascending: false);

    final messages = (response as List).map((json) => MessageModel.fromJson(json)).toList();
    
    final Map<String, ConversationModel> conversations = {};
    for (var msg in messages) {
      final otherId = msg.senderId == userId ? msg.receiverId : msg.senderId;
      if (!conversations.containsKey(otherId)) {
        conversations[otherId] = ConversationModel(
          otherUserId: otherId,
          otherUserName: 'User $otherId',
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
