import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/constants/hive_constants.dart';
import 'data/models/user_model.dart';
import 'data/models/journey_model.dart';
import 'data/models/question_model.dart';
import 'core/providers/app_provider.dart';
import 'core/themes/app_theme.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(HiveConstants.userModelTypeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveConstants.journeyModelTypeId)) {
    Hive.registerAdapter(JourneyModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveConstants.stageModelTypeId)) {
    Hive.registerAdapter(StageModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveConstants.dayModelTypeId)) {
    Hive.registerAdapter(DayModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveConstants.questionModelTypeId)) {
    Hive.registerAdapter(QuestionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveConstants.answerOptionModelTypeId)) {
    Hive.registerAdapter(AnswerOptionModelAdapter());
  }
  
  // Open Hive boxes
  await Hive.openBox<UserModel>(HiveConstants.userBox);
  await Hive.openBox<JourneyModel>(HiveConstants.journeyBox);
  await Hive.openBox(HiveConstants.settingsBox);
  
  runApp(const ProviderScope(child: ETrainerApp()));
}

class ETrainerApp extends ConsumerWidget {
  const ETrainerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'ETrainer Mobile',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
