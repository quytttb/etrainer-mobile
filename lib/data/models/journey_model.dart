// ignore_for_file: must_be_immutable

import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/hive_constants.dart';

part 'journey_model.g.dart';

@HiveType(typeId: HiveConstants.journeyModelTypeId)
class JourneyModel extends Equatable with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String level; // beginner, intermediate, advanced

  @HiveField(5)
  final List<StageModel> stages;

  @HiveField(6)
  final int totalDays;

  @HiveField(7)
  final int estimatedDuration; // in minutes

  @HiveField(8)
  final bool isCompleted;

  @HiveField(9)
  final int completedStages;

  @HiveField(10)
  final DateTime? lastAccessedAt;

  @HiveField(11)
  final DateTime? createdAt;

  @HiveField(12)
  final DateTime? updatedAt;

  JourneyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.stages,
    required this.totalDays,
    required this.estimatedDuration,
    required this.isCompleted,
    this.completedStages = 0,
    this.lastAccessedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory JourneyModel.fromJson(Map<String, dynamic> json) {
    return JourneyModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      level: json['level'],
      stages: (json['stages'] as List)
          .map((stage) => StageModel.fromJson(stage))
          .toList(),
      totalDays: json['totalDays'],
      estimatedDuration: json['estimatedDuration'],
      isCompleted: json['isCompleted'] ?? false,
      completedStages: json['completedStages'] ?? 0,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'level': level,
      'stages': stages.map((stage) => stage.toJson()).toList(),
      'totalDays': totalDays,
      'estimatedDuration': estimatedDuration,
      'isCompleted': isCompleted,
      'completedStages': completedStages,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    level,
    stages,
    totalDays,
    estimatedDuration,
    isCompleted,
    completedStages,
    lastAccessedAt,
    createdAt,
    updatedAt,
  ];

  JourneyModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? level,
    List<StageModel>? stages,
    int? totalDays,
    int? estimatedDuration,
    bool? isCompleted,
    int? completedStages,
    DateTime? lastAccessedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JourneyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
      stages: stages ?? this.stages,
      totalDays: totalDays ?? this.totalDays,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
      completedStages: completedStages ?? this.completedStages,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@HiveType(typeId: HiveConstants.stageModelTypeId)
class StageModel extends Equatable with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<DayModel> days;

  @HiveField(4)
  final int totalDays;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final int completedDays;

  @HiveField(7)
  final DateTime? lastAccessedAt;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  StageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.days,
    required this.totalDays,
    required this.isCompleted,
    this.completedDays = 0,
    this.lastAccessedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      days: (json['days'] as List)
          .map((day) => DayModel.fromJson(day))
          .toList(),
      totalDays: json['totalDays'],
      isCompleted: json['isCompleted'] ?? false,
      completedDays: json['completedDays'] ?? 0,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'days': days.map((day) => day.toJson()).toList(),
      'totalDays': totalDays,
      'isCompleted': isCompleted,
      'completedDays': completedDays,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    days,
    totalDays,
    isCompleted,
    completedDays,
    lastAccessedAt,
    createdAt,
    updatedAt,
  ];

  StageModel copyWith({
    String? id,
    String? title,
    String? description,
    List<DayModel>? days,
    int? totalDays,
    bool? isCompleted,
    int? completedDays,
    DateTime? lastAccessedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StageModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      days: days ?? this.days,
      totalDays: totalDays ?? this.totalDays,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDays: completedDays ?? this.completedDays,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@HiveType(typeId: HiveConstants.dayModelTypeId)
class DayModel extends Equatable with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final Map<String, dynamic> content; // Lessons, exercises, etc.

  @HiveField(4)
  final List<String> questions; // Question IDs

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final int completedQuestions;

  @HiveField(7)
  final int score;

  @HiveField(8)
  final DateTime? lastAccessedAt;

  @HiveField(9)
  final DateTime? completedAt;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  DayModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.questions,
    required this.isCompleted,
    this.completedQuestions = 0,
    this.score = 0,
    this.lastAccessedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'] ?? {},
      questions: List<String>.from(json['questions'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
      completedQuestions: json['completedQuestions'] ?? 0,
      score: json['score'] ?? 0,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'questions': questions,
      'isCompleted': isCompleted,
      'completedQuestions': completedQuestions,
      'score': score,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    content,
    questions,
    isCompleted,
    completedQuestions,
    score,
    lastAccessedAt,
    completedAt,
    createdAt,
    updatedAt,
  ];

  DayModel copyWith({
    String? id,
    String? title,
    String? description,
    Map<String, dynamic>? content,
    List<String>? questions,
    bool? isCompleted,
    int? completedQuestions,
    int? score,
    DateTime? lastAccessedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DayModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      questions: questions ?? this.questions,
      isCompleted: isCompleted ?? this.isCompleted,
      completedQuestions: completedQuestions ?? this.completedQuestions,
      score: score ?? this.score,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
