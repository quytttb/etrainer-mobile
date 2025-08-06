import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/question.dart';

// Mock quiz provider
final currentQuizProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {
    'title': 'Quiz Toán học',
    'description': 'Kiểm tra kiến thức toán học cơ bản',
    'duration': 600, // 10 minutes in seconds
    'totalQuestions': 10,
  },
);

final quizQuestionsProvider = StateProvider<List<Question>>(
  (ref) => [
    Question(
      id: 'q1',
      text: 'Kết quả của phép tính 2 + 3 × 4 là?',
      options: ['14', '20', '10', '24'],
      correctAnswer: '14',
      explanation:
          'Thứ tự thực hiện phép tính: nhân trước, cộng sau. 3 × 4 = 12, sau đó 2 + 12 = 14',
      difficulty: 'easy',
    ),
    Question(
      id: 'q2',
      text: 'Căn bậc hai của 144 là?',
      options: ['11', '12', '13', '14'],
      correctAnswer: '12',
      explanation: '12 × 12 = 144, nên căn bậc hai của 144 là 12',
      difficulty: 'medium',
    ),
    Question(
      id: 'q3',
      text: 'Nếu x + 5 = 12, thì x bằng?',
      options: ['7', '8', '6', '9'],
      correctAnswer: '7',
      explanation: 'x = 12 - 5 = 7',
      difficulty: 'easy',
    ),
    Question(
      id: 'q4',
      text: 'Diện tích hình vuông có cạnh 8cm là?',
      options: ['16 cm²', '32 cm²', '64 cm²', '72 cm²'],
      correctAnswer: '64 cm²',
      explanation: 'Diện tích hình vuông = cạnh × cạnh = 8 × 8 = 64 cm²',
      difficulty: 'medium',
    ),
    Question(
      id: 'q5',
      text: 'Phân số 3/4 bằng bao nhiêu phần trăm?',
      options: ['70%', '75%', '80%', '85%'],
      correctAnswer: '75%',
      explanation: '3/4 = 0.75 = 75%',
      difficulty: 'medium',
    ),
  ],
);

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final selectedAnswersProvider = StateProvider<Map<int, String>>((ref) => {});
final timeRemainingProvider = StateProvider<int>((ref) => 600);
final isQuizStartedProvider = StateProvider<bool>((ref) => false);
final isQuizFinishedProvider = StateProvider<bool>((ref) => false);

class QuizScreen extends ConsumerStatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _timerAnimationController;
  late AnimationController _fadeAnimationController;
  late AnimationController _correctAnimationController;
  late Animation<double> _timerAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize animation controllers
    _timerAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _correctAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _timerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the quiz automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isQuizStartedProvider.notifier).state = true;
      _fadeAnimationController.forward();
      _startTimer();
    });
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted &&
          ref.read(isQuizStartedProvider) &&
          !ref.read(isQuizFinishedProvider)) {
        final timeRemaining = ref.read(timeRemainingProvider);
        if (timeRemaining > 0) {
          ref.read(timeRemainingProvider.notifier).state = timeRemaining - 1;
          _startTimer();
        } else {
          _finishQuiz();
        }
      }
    });
  }

  void _finishQuiz() {
    ref.read(isQuizFinishedProvider.notifier).state = true;
    ref.read(isQuizStartedProvider.notifier).state = false;

    // Calculate score
    final questions = ref.read(quizQuestionsProvider);
    final answers = ref.read(selectedAnswersProvider);
    int correct = 0;

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctAnswer) {
        correct++;
      }
    }

    // Show results
    _showResultsDialog(correct, questions.length);
  }

  void _showResultsDialog(int correct, int total) {
    final percentage = (correct / total * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Kết quả Quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 70 ? Icons.celebration : Icons.sentiment_neutral,
              size: 64,
              color: percentage >= 70 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn đã trả lời đúng $correct/$total câu',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Điểm số: $percentage%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: percentage >= 70 ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 70
                  ? 'Xuất sắc! Tiếp tục cố gắng!'
                  : 'Cần cố gắng thêm! Hãy thử lại nhé!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // Return to practice screen
            },
            child: const Text('Hoàn thành'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetQuiz();
            },
            child: const Text('Làm lại'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    ref.read(currentQuestionIndexProvider.notifier).state = 0;
    ref.read(selectedAnswersProvider.notifier).state = {};
    ref.read(timeRemainingProvider.notifier).state = 600;
    ref.read(isQuizStartedProvider.notifier).state = true;
    ref.read(isQuizFinishedProvider.notifier).state = false;
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timerAnimationController.dispose();
    _fadeAnimationController.dispose();
    _correctAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(currentQuizProvider);
    final questions = ref.watch(quizQuestionsProvider);
    final currentIndex = ref.watch(currentQuestionIndexProvider);
    final timeRemaining = ref.watch(timeRemainingProvider);
    final isFinished = ref.watch(isQuizFinishedProvider);

    if (isFinished) {
      return Scaffold(
        appBar: AppBar(title: Text(quiz['title'])),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz['title']),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: timeRemaining <= 60
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedBuilder(
              animation: _timerAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: timeRemaining <= 10
                      ? 1.0 + (_timerAnimation.value * 0.1)
                      : 1.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${(timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(timeRemaining % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Câu ${currentIndex + 1}/${questions.length}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${((currentIndex + 1) / questions.length * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

          // Questions with Fade Animation
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                onPageChanged: (index) {
                  ref.read(currentQuestionIndexProvider.notifier).state = index;
                  // Restart fade animation for new question
                  _fadeAnimationController.reset();
                  _fadeAnimationController.forward();
                },
                itemBuilder: (context, index) {
                  return _QuestionView(
                    question: questions[index],
                    questionNumber: index + 1,
                    onAnswerSelected: (answer) {
                      final answers = ref.read(
                        selectedAnswersProvider.notifier,
                      );
                      answers.state = {...answers.state, index: answer};
                    },
                    selectedAnswer: ref.watch(selectedAnswersProvider)[index],
                  );
                },
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (currentIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Câu trước'),
                    ),
                  ),
                if (currentIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex < questions.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Show confirmation dialog
                        _showFinishConfirmation();
                      }
                    },
                    child: Text(
                      currentIndex < questions.length - 1
                          ? 'Câu tiếp'
                          : 'Hoàn thành',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFinishConfirmation() {
    final answers = ref.read(selectedAnswersProvider);
    final questions = ref.read(quizQuestionsProvider);
    final unanswered = questions.length - answers.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hoàn thành Quiz?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn có chắc chắn muốn kết thúc quiz không?'),
            if (unanswered > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Còn $unanswered câu chưa trả lời.',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _finishQuiz();
            },
            child: const Text('Hoàn thành'),
          ),
        ],
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;

  const _QuestionView({
    required this.question,
    required this.questionNumber,
    required this.onAnswerSelected,
    this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                            question.difficulty,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getDifficultyText(question.difficulty),
                          style: TextStyle(
                            color: _getDifficultyColor(question.difficulty),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Câu $questionNumber',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.text,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Answer Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedAnswer == option;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onAnswerSelected(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.grey[50],
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'Dễ';
      case 'medium':
        return 'Trung bình';
      case 'hard':
        return 'Khó';
      default:
        return 'Không xác định';
    }
  }
}
