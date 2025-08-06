// ignore_for_file: must_be_immutable

import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/hive_constants.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveConstants.userModelTypeId)
class UserModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String fullName;

  @HiveField(3)
  final String? avatarUrl;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime lastLoginAt;

  @HiveField(7)
  final String? currentJourneyId;

  @HiveField(8)
  final int totalPoints;

  @HiveField(9)
  final int currentStreak;

  @HiveField(10)
  final int longestStreak;

  @HiveField(11)
  final String level; // beginner, intermediate, advanced

  @HiveField(12)
  final bool isEmailVerified;

  @HiveField(13)
  final bool isActive;

  @HiveField(14)
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    required this.createdAt,
    required this.lastLoginAt,
    this.currentJourneyId,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.level = 'beginner',
    this.isEmailVerified = false,
    this.isActive = true,
    this.preferences,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    avatarUrl,
    phoneNumber,
    createdAt,
    lastLoginAt,
    currentJourneyId,
    totalPoints,
    currentStreak,
    longestStreak,
    level,
    isEmailVerified,
    isActive,
    preferences,
  ];

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? currentJourneyId,
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    String? level,
    bool? isEmailVerified,
    bool? isActive,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      currentJourneyId: currentJourneyId ?? this.currentJourneyId,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      level: level ?? this.level,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      currentJourneyId: json['currentJourneyId'] as String?,
      totalPoints: json['totalPoints'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      level: json['level'] as String? ?? 'beginner',
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'currentJourneyId': currentJourneyId,
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'level': level,
      'isEmailVerified': isEmailVerified,
      'isActive': isActive,
      'preferences': preferences,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, fullName: $fullName}';
  }
}
