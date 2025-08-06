// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 4;

  @override
  QuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionModel(
      id: fields[0] as String,
      type: fields[1] as QuestionType,
      question: fields[2] as String,
      options: (fields[3] as List).cast<AnswerOptionModel>(),
      correctAnswer: fields[4] as String,
      explanation: fields[5] as String?,
      audioUrl: fields[6] as String?,
      imageUrl: fields[7] as String?,
      difficulty: fields[8] as QuestionDifficulty,
      timeLimit: fields[9] as int,
      points: fields[10] as int,
      category: fields[11] as String?,
      tags: (fields[12] as List).cast<String>(),
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.question)
      ..writeByte(3)
      ..write(obj.options)
      ..writeByte(4)
      ..write(obj.correctAnswer)
      ..writeByte(5)
      ..write(obj.explanation)
      ..writeByte(6)
      ..write(obj.audioUrl)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.difficulty)
      ..writeByte(9)
      ..write(obj.timeLimit)
      ..writeByte(10)
      ..write(obj.points)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.tags)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnswerOptionModelAdapter extends TypeAdapter<AnswerOptionModel> {
  @override
  final int typeId = 16;

  @override
  AnswerOptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswerOptionModel(
      id: fields[0] as String,
      text: fields[1] as String,
      isCorrect: fields[2] as bool,
      imageUrl: fields[3] as String?,
      audioUrl: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AnswerOptionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isCorrect)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.audioUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerOptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
