import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:masarat/core/constants/app_constants.dart';
import 'package:masarat/core/errors/exceptions.dart';

/// Supabase service for handling backend operations
/// Provides authentication, database, storage, and realtime functionality
class SupabaseService {
  SupabaseService._();
  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  /// Get the Supabase client
  SupabaseClient get client => Supabase.instance.client;

  /// Get the Supabase auth client
  GoTrueClient get auth => client.auth;

  /// Get the current user
  User? get currentUser => auth.currentUser;

  /// Get the current session
  Session? get currentSession => auth.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Initialize Supabase
  Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      debug: true,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
    );
  }

  // ============================================================
  // Authentication Methods
  // ============================================================

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await auth.signUp(
        email: email,
        password: password,
        data: data,
      );

      if (response.user == null) {
        throw const AuthException(
          message: 'Failed to create account',
          type: AuthExceptionType.unknown,
        );
      }

      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Sign in with OTP (magic link)
  Future<void> signInWithOtp({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await auth.signInWithOtp(
        email: email,
        emailRedirectTo: redirectTo,
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Sign in with phone and password
  Future<AuthResponse> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await auth.signInWithPassword(
        phone: phone,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Sign in with OAuth provider (Google, Apple, Facebook, etc.)
  Future<bool> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
  }) async {
    try {
      final response = await auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Verify OTP code
  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
    OtpType type = OtpType.email,
  }) async {
    try {
      final response = await auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Send password reset email
  Future<void> resetPassword({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Update password
  Future<UserResponse> updatePassword({
    required String newPassword,
  }) async {
    try {
      final response = await auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Update user metadata
  Future<UserResponse> updateUser({
    String? email,
    String? phone,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await auth.updateUser(
        UserAttributes(
          email: email,
          phone: phone,
          data: data,
        ),
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Refresh session
  Future<AuthResponse> refreshSession() async {
    try {
      final response = await auth.refreshSession();
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: e.toString(),
        type: AuthExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// Get auth state changes stream
  Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ============================================================
  // Database Methods (PostgreSQL)
  // ============================================================

  /// Query data from a table
  Future<List<Map<String, dynamic>>> query({
    required String table,
    List<String>? columns,
    Map<String, dynamic>? filter,
    String? order,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = client.from(table).select(columns ?? '*');

      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      if (order != null) {
        query = query.order(order, ascending: ascending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        code: e.code,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  /// Insert data into a table
  Future<Map<String, dynamic>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await client
          .from(table)
          .insert(data)
          .select()
          .single();
      return Map<String, dynamic>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        code: e.code,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  /// Update data in a table
  Future<List<Map<String, dynamic>>> update({
    required String table,
    required Map<String, dynamic> data,
    required String idColumn,
    required dynamic id,
  }) async {
    try {
      final response = await client
          .from(table)
          .update(data)
          .eq(idColumn, id)
          .select();
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        code: e.code,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  /// Delete data from a table
  Future<void> delete({
    required String table,
    required String idColumn,
    required dynamic id,
  }) async {
    try {
      await client.from(table).delete().eq(idColumn, id);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        code: e.code,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  /// Get a single record by ID
  Future<Map<String, dynamic>?> getById({
    required String table,
    required String idColumn,
    required dynamic id,
    List<String>? columns,
  }) async {
    try {
      final response = await client
          .from(table)
          .select(columns ?? '*')
          .eq(idColumn, id)
          .maybeSingle();
      return response != null ? Map<String, dynamic>.from(response) : null;
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        code: e.code,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  /// Count records in a table
  Future<int> count({
    required String table,
    Map<String, dynamic>? filter,
  }) async {
    try {
      var query = client.from(table).select('*', const FetchOptions(count: CountOption.exact));

      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query;
      return response.count ?? 0;
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        code: e.code,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  // ============================================================
  // Storage Methods
  // ============================================================

  /// Upload a file to storage
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required List<int> bytes,
    String? contentType,
    bool upsert = false,
  }) async {
    try {
      final response = await client.storage
          .from(bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: upsert,
            ),
          );
      return response;
    } on StorageException catch (e) {
      throw FileException(
        message: e.message,
        type: FileExceptionType.uploadFailed,
        originalError: e,
      );
    } catch (e) {
      throw FileException(
        message: e.toString(),
        type: FileExceptionType.uploadFailed,
        originalError: e,
      );
    }
  }

  /// Download a file from storage
  Future<List<int>> downloadFile({
    required String bucket,
    required String path,
  }) async {
    try {
      final response = await client.storage.from(bucket).download(path);
      return response;
    } on StorageException catch (e) {
      throw FileException(
        message: e.message,
        type: FileExceptionType.downloadFailed,
        originalError: e,
      );
    } catch (e) {
      throw FileException(
        message: e.toString(),
        type: FileExceptionType.downloadFailed,
        originalError: e,
      );
    }
  }

  /// Delete a file from storage
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await client.storage.from(bucket).remove([path]);
    } on StorageException catch (e) {
      throw FileException(
        message: e.message,
        type: FileExceptionType.deleteFailed,
        originalError: e,
      );
    } catch (e) {
      throw FileException(
        message: e.toString(),
        type: FileExceptionType.deleteFailed,
        originalError: e,
      );
    }
  }

  /// Get public URL for a file
  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return client.storage.from(bucket).getPublicUrl(path);
  }

  /// Get signed URL for a private file
  Future<String> getSignedUrl({
    required String bucket,
    required String path,
    int expiresIn = 3600,
  }) async {
    try {
      final response = await client.storage
          .from(bucket)
          .createSignedUrl(path, expiresIn);
      return response;
    } on StorageException catch (e) {
      throw FileException(
        message: e.message,
        type: FileExceptionType.unknown,
        originalError: e,
      );
    } catch (e) {
      throw FileException(
        message: e.toString(),
        type: FileExceptionType.unknown,
        originalError: e,
      );
    }
  }

  /// List files in a storage bucket
  Future<List<FileObject>> listFiles({
    required String bucket,
    String? path,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await client.storage.from(bucket).list(
        path: path,
        searchOptions: search != null
            ? SearchOptions(search: search)
            : null,
        limit: limit,
        offset: offset,
      );
      return response;
    } on StorageException catch (e) {
      throw FileException(
        message: e.message,
        type: FileExceptionType.unknown,
        originalError: e,
      );
    } catch (e) {
      throw FileException(
        message: e.toString(),
        type: FileExceptionType.unknown,
        originalError: e,
      );
    }
  }

  // ============================================================
  // Realtime Methods
  // ============================================================

  /// Subscribe to realtime changes on a table
  RealtimeChannel subscribeToTable({
    required String table,
    required void Function(PostgresChangePayload) callback,
    String? schema,
    String? filter,
  }) {
    return client
        .channel('public:$table')
        .onPostgresChange(
          PostgresChangeEvent.all,
          callback: callback,
          schema: schema ?? 'public',
          table: table,
          filter: filter,
        )
        .subscribe();
  }

  /// Subscribe to inserts on a table
  RealtimeChannel subscribeToInserts({
    required String table,
    required void Function(PostgresChangePayload) callback,
    String? schema,
    String? filter,
  }) {
    return client
        .channel('public:$table:insert')
        .onPostgresChange(
          PostgresChangeEvent.insert,
          callback: callback,
          schema: schema ?? 'public',
          table: table,
          filter: filter,
        )
        .subscribe();
  }

  /// Subscribe to updates on a table
  RealtimeChannel subscribeToUpdates({
    required String table,
    required void Function(PostgresChangePayload) callback,
    String? schema,
    String? filter,
  }) {
    return client
        .channel('public:$table:update')
        .onPostgresChange(
          PostgresChangeEvent.update,
          callback: callback,
          schema: schema ?? 'public',
          table: table,
          filter: filter,
        )
        .subscribe();
  }

  /// Subscribe to deletes on a table
  RealtimeChannel subscribeToDeletes({
    required String table,
    required void Function(PostgresChangePayload) callback,
    String? schema,
    String? filter,
  }) {
    return client
        .channel('public:$table:delete')
        .onPostgresChange(
          PostgresChangeEvent.delete,
          callback: callback,
          schema: schema ?? 'public',
          table: table,
          filter: filter,
        )
        .subscribe();
  }

  /// Unsubscribe from a channel
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await client.removeChannel(channel);
  }

  // ============================================================
  // RPC (Remote Procedure Calls)
  // ============================================================

  /// Call a PostgreSQL function
  Future<T> callFunction<T>({
    required String function,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await client.rpc(function, params: params);
      return response as T;
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        code: e.code,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  // ============================================================
  // Error Handling
  // ============================================================

  /// Handle Supabase AuthException and convert to custom AuthException
  AuthException _handleAuthException(AuthException error) {
    switch (error.message) {
      case 'Invalid login credentials':
        return const AuthException(
          message: 'Invalid email or password',
          type: AuthExceptionType.invalidCredentials,
          originalError: error,
        );
      case 'Email not confirmed':
        return const AuthException(
          message: 'Please verify your email address',
          type: AuthExceptionType.emailNotConfirmed,
          originalError: error,
        );
      case 'User already registered':
        return const AuthException(
          message: 'An account with this email already exists',
          type: AuthExceptionType.userAlreadyExists,
          originalError: error,
        );
      case 'Password should be at least 6 characters':
        return const AuthException(
          message: 'Password is too weak',
          type: AuthExceptionType.weakPassword,
          originalError: error,
        );
      case 'Signups not allowed':
        return const AuthException(
          message: 'Registration is currently disabled',
          type: AuthExceptionType.unknown,
          originalError: error,
        );
      case 'Token has expired or is invalid':
        return const AuthException(
          message: 'Your session has expired. Please log in again',
          type: AuthExceptionType.sessionExpired,
          originalError: error,
        );
      case 'Email rate limit exceeded':
        return const AuthException(
          message: 'Too many attempts. Please try again later',
          type: AuthExceptionType.tooManyRequests,
          originalError: error,
        );
      default:
        return AuthException(
          message: error.message,
          code: error.statusCode,
          type: AuthExceptionType.unknown,
          originalError: error,
        );
    }
  }
}
