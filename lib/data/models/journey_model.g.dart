// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JourneyModelAdapter extends TypeAdapter<JourneyModel> {
  @override
  final int typeId = 1;

  @override
  JourneyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JourneyModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      imageUrl: fields[3] as String,
      level: fields[4] as String,
      stages: (fields[5] as List).cast<StageModel>(),
      totalDays: fields[6] as int,
      estimatedDuration: fields[7] as int,
      isCompleted: fields[8] as bool,
      completedStages: fields[9] as int,
      lastAccessedAt: fields[10] as DateTime?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JourneyModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.stages)
      ..writeByte(6)
      ..write(obj.totalDays)
      ..writeByte(7)
      ..write(obj.estimatedDuration)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.completedStages)
      ..writeByte(10)
      ..write(obj.lastAccessedAt)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JourneyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StageModelAdapter extends TypeAdapter<StageModel> {
  @override
  final int typeId = 2;

  @override
  StageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StageModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      days: (fields[3] as List).cast<DayModel>(),
      totalDays: fields[4] as int,
      isCompleted: fields[5] as bool,
      completedDays: fields[6] as int,
      lastAccessedAt: fields[7] as DateTime?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StageModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.totalDays)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.completedDays)
      ..writeByte(7)
      ..write(obj.lastAccessedAt)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayModelAdapter extends TypeAdapter<DayModel> {
  @override
  final int typeId = 3;

  @override
  DayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      content: (fields[3] as Map).cast<String, dynamic>(),
      questions: (fields[4] as List).cast<String>(),
      isCompleted: fields[5] as bool,
      completedQuestions: fields[6] as int,
      score: fields[7] as int,
      lastAccessedAt: fields[8] as DateTime?,
      completedAt: fields[9] as DateTime?,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DayModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.questions)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.completedQuestions)
      ..writeByte(7)
      ..write(obj.score)
      ..writeByte(8)
      ..write(obj.lastAccessedAt)
      ..writeByte(9)
      ..write(obj.completedAt)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
