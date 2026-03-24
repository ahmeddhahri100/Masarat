class UserModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final int tripsCount;
  final int reviewsCount;
  final bool isPremium;

  UserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.rating = 5.0,
    this.tripsCount = 0,
    this.reviewsCount = 0,
    this.isPremium = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      tripsCount: json['trips_count'] as int? ?? 0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      isPremium: json['is_premium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'rating': rating,
      'trips_count': tripsCount,
      'reviews_count': reviewsCount,
      'is_premium': isPremium,
    };
  }
}
