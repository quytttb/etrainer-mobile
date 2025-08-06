// ignore_for_file: must_be_immutable

import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/hive_constants.dart';

part 'question_model.g.dart';

enum QuestionType {
  multipleChoice,
  trueFalse,
  fillInBlank,
  listening,
  speaking,
  reading,
  matching,
}

enum QuestionDifficulty { easy, medium, hard }

@HiveType(typeId: HiveConstants.questionModelTypeId)
class QuestionModel extends Equatable with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final QuestionType type;

  @HiveField(2)
  final String question;

  @HiveField(3)
  final List<AnswerOptionModel> options;

  @HiveField(4)
  final String correctAnswer;

  @HiveField(5)
  final String? explanation;

  @HiveField(6)
  final String? audioUrl;

  @HiveField(7)
  final String? imageUrl;

  @HiveField(8)
  final QuestionDifficulty difficulty;

  @HiveField(9)
  final int timeLimit; // in seconds

  @HiveField(10)
  final int points;

  @HiveField(11)
  final String? category;

  @HiveField(12)
  final List<String> tags;

  @HiveField(13)
  final DateTime? createdAt;

  @HiveField(14)
  final DateTime? updatedAt;

  QuestionModel({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.audioUrl,
    this.imageUrl,
    this.difficulty = QuestionDifficulty.medium,
    this.timeLimit = 30,
    this.points = 10,
    this.category,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${json['type']}',
        orElse: () => QuestionType.multipleChoice,
      ),
      question: json['question'],
      options: (json['options'] as List)
          .map((option) => AnswerOptionModel.fromJson(option))
          .toList(),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      difficulty: QuestionDifficulty.values.firstWhere(
        (e) => e.toString() == 'QuestionDifficulty.${json['difficulty']}',
        orElse: () => QuestionDifficulty.medium,
      ),
      timeLimit: json['timeLimit'] ?? 30,
      points: json['points'] ?? 10,
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
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
      'type': type.toString().split('.').last,
      'question': question,
      'options': options.map((option) => option.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'difficulty': difficulty.toString().split('.').last,
      'timeLimit': timeLimit,
      'points': points,
      'category': category,
      'tags': tags,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    type,
    question,
    options,
    correctAnswer,
    explanation,
    audioUrl,
    imageUrl,
    difficulty,
    timeLimit,
    points,
    category,
    tags,
    createdAt,
    updatedAt,
  ];

  QuestionModel copyWith({
    String? id,
    QuestionType? type,
    String? question,
    List<AnswerOptionModel>? options,
    String? correctAnswer,
    String? explanation,
    String? audioUrl,
    String? imageUrl,
    QuestionDifficulty? difficulty,
    int? timeLimit,
    int? points,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
      timeLimit: timeLimit ?? this.timeLimit,
      points: points ?? this.points,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@HiveType(typeId: HiveConstants.answerOptionModelTypeId)
class AnswerOptionModel extends Equatable with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isCorrect;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String? audioUrl;

  AnswerOptionModel({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.imageUrl,
    this.audioUrl,
  });

  factory AnswerOptionModel.fromJson(Map<String, dynamic> json) {
    return AnswerOptionModel(
      id: json['id'],
      text: json['text'],
      isCorrect: json['isCorrect'] ?? false,
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }

  @override
  List<Object?> get props => [id, text, isCorrect, imageUrl, audioUrl];

  AnswerOptionModel copyWith({
    String? id,
    String? text,
    bool? isCorrect,
    String? imageUrl,
    String? audioUrl,
  }) {
    return AnswerOptionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }
}
