import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const BmiAiApp());
}

class BmiAiApp extends StatelessWidget {
  const BmiAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF1A1F3A),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF6C63FF), secondary: Color(0xFF4ECDC4), surface: Color(0xFF1A1F3A)),
      ),
      home: const BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> with SingleTickerProviderStateMixin {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Unit toggles
  bool _isMetricHeight = true; // true = cm, false = ft/in
  bool _isMetricWeight = true; // true = kg, false = lb

  // For ft/in input
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchController = TextEditingController();

  double? _bmiResult;
  String _category = '';
  List<String> _aiInsights = [];
  bool _isCalculating = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _feetController.dispose();
    _inchController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    double height = 0;
    double weight = 0;

    // Calculate height in cm
    if (_isMetricHeight) {
      if (_heightController.text.isEmpty) {
        _showSnackBar('Please enter height');
        return;
      }
      height = double.tryParse(_heightController.text) ?? 0;
    } else {
      if (_feetController.text.isEmpty && _inchController.text.isEmpty) {
        _showSnackBar('Please enter height');
        return;
      }
      double feet = double.tryParse(_feetController.text) ?? 0;
      double inches = double.tryParse(_inchController.text) ?? 0;
      height = (feet * 30.48) + (inches * 2.54); // Convert to cm
    }

    // Calculate weight in kg
    if (_isMetricWeight) {
      if (_weightController.text.isEmpty) {
        _showSnackBar('Please enter weight');
        return;
      }
      weight = double.tryParse(_weightController.text) ?? 0;
    } else {
      if (_weightController.text.isEmpty) {
        _showSnackBar('Please enter weight');
        return;
      }
      double pounds = double.tryParse(_weightController.text) ?? 0;
      weight = pounds * 0.453592; // Convert to kg
    }

    if (height <= 0 || weight <= 0) {
      _showSnackBar('Please enter valid values');
      return;
    }

    setState(() => _isCalculating = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      double heightInMeters = height / 100;
      double bmi = weight / (heightInMeters * heightInMeters);

      setState(() {
        _bmiResult = bmi;
        _category = _getBMICategory(bmi);
        _aiInsights = _getAIInsights(bmi, weight, height);
        _isCalculating = false;
      });

      _animationController.reset();
      _animationController.forward();
    });
  }

  String _getBMICategory(double bmi) {
    if (bmi < 16.0) return 'Severely Underweight';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal Weight';
    if (bmi < 30.0) return 'Overweight';
    if (bmi < 35.0) return 'Obese Class I';
    if (bmi < 40.0) return 'Obese Class II';
    return 'Obese Class III';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Severely Underweight':
        return const Color(0xFFFF6B6B);
      case 'Underweight':
        return const Color(0xFFFFB347);
      case 'Normal Weight':
        return const Color(0xFF4ECDC4);
      case 'Overweight':
        return const Color(0xFFFFB347);
      case 'Obese Class I':
      case 'Obese Class II':
      case 'Obese Class III':
        return const Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  List<String> _getAIInsights(double bmi, double weight, double height) {
    List<String> insights = [];

    // BMI-specific insights
    if (bmi < 16.0) {
      insights.addAll([
        '⚠️ Your BMI indicates severe underweight. This may pose serious health risks.',
        '🏥 Consult a healthcare professional immediately for a comprehensive health assessment.',
        '🍽️ Focus on nutrient-dense foods with adequate calories to reach a healthy weight.',
        '💪 Consider working with a registered dietitian to develop a proper meal plan.',
      ]);
    } else if (bmi < 18.5) {
      insights.addAll([
        '📊 Your BMI suggests you may be underweight for your height.',
        '🥗 Increase calorie intake with nutritious, whole foods like nuts, avocados, and lean proteins.',
        '🏋️ Strength training can help build healthy muscle mass.',
        '💡 Small, frequent meals throughout the day can help increase overall calorie intake.',
      ]);
    } else if (bmi < 25.0) {
      insights.addAll([
        '✅ Excellent! Your BMI falls within the healthy weight range.',
        '🎯 Maintain your current lifestyle with balanced nutrition and regular exercise.',
        '🏃 Aim for at least 150 minutes of moderate aerobic activity per week.',
        '🧘 Don\'t forget mental health - stress management is key to overall wellness.',
        '💧 Stay hydrated with 8-10 glasses of water daily for optimal health.',
      ]);
    } else if (bmi < 30.0) {
      insights.addAll([
        '⚖️ Your BMI indicates you\'re in the overweight category.',
        '🥦 Focus on whole foods: vegetables, fruits, lean proteins, and whole grains.',
        '🚶 Start with 30 minutes of moderate activity daily - even walking counts!',
        '📉 A modest weight loss of 5-10% can significantly improve your health markers.',
        '😴 Ensure 7-9 hours of quality sleep - it affects metabolism and appetite.',
      ]);
    } else if (bmi < 35.0) {
      insights.addAll([
        '🔴 Your BMI falls in the obese category, which may increase health risks.',
        '👨‍⚕️ Schedule a checkup to monitor blood pressure, cholesterol, and blood sugar.',
        '🍎 Create a sustainable calorie deficit through portion control and healthier food choices.',
        '💪 Low-impact exercises like swimming or cycling are gentle on joints.',
        '📝 Keep a food journal to identify patterns and make mindful eating decisions.',
      ]);
    } else if (bmi < 40.0) {
      insights.addAll([
        '⚠️ Your BMI indicates Class II obesity with increased health risks.',
        '🏥 Medical supervision is strongly recommended for weight management.',
        '🍽️ Consider working with healthcare professionals for a structured weight loss plan.',
        '🚴 Start with gentle activities - consistency matters more than intensity.',
        '👥 Support groups can provide motivation and accountability on your journey.',
      ]);
    } else {
      insights.addAll([
        '🚨 Your BMI indicates Class III obesity with significant health concerns.',
        '👨‍⚕️ Immediate medical consultation is crucial - you may qualify for specialized programs.',
        '💊 Discuss all treatment options with your doctor, including medical interventions.',
        '🧑‍🤝‍🧑 Build a support team: doctor, dietitian, therapist, and support group.',
        '🎯 Focus on small, achievable goals - every positive step counts.',
      ]);
    }

    // Add personalized insights based on metrics
    double idealWeight = 22.0 * pow((height / 100), 2);
    double weightDiff = weight - idealWeight;

    if (weightDiff.abs() > 1) {
      String unit = _isMetricWeight ? 'kg' : 'lbs';
      double displayDiff = _isMetricWeight ? weightDiff : weightDiff * 2.20462;

      if (weightDiff > 0) {
        insights.add('📈 You\'re approximately ${displayDiff.toStringAsFixed(1)} $unit above the ideal weight range.');
      } else {
        insights.add('📉 You\'re approximately ${displayDiff.abs().toStringAsFixed(1)} $unit below the ideal weight range.');
      }
    }

    // Add general wellness tips
    insights.addAll([
      '🧬 Remember: BMI is a screening tool, not a diagnostic measure of body fatness or health.',
      '🎯 Set realistic goals and celebrate small victories along your wellness journey.',
    ]);

    return insights;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0).copyWith(top: 72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildInputCard(),
              const SizedBox(height: 30),
              _buildCalculateButton(),
              if (_bmiResult != null) ...[
                const SizedBox(height: 30),
                _buildResultCard(),
                const SizedBox(height: 20),
                TypewriterAIInsights(
                  key: ValueKey(_bmiResult),
                  insights: _aiInsights,
                  categoryColor: _getCategoryColor(_category),
                  scrollController: _scrollController,
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.psychology, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text('BMI Calculator', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 8),
        Text('AI-Powered Body Mass Index Calculator', style: TextStyle(fontSize: 14, color: Colors.grey[400], letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(children: [_buildHeightInput(), const SizedBox(height: 24), _buildWeightInput()]),
    );
  }

  Widget _buildHeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.height, color: Color(0xFF6C63FF), size: 20),
            const SizedBox(width: 8),
            Text(
              'Height',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[300]),
            ),
            const Spacer(),
            _buildUnitToggle(
              value: _isMetricHeight,
              option1: 'cm',
              option2: 'ft/in',
              onChanged: (val) {
                setState(() {
                  _isMetricHeight = val;
                  _heightController.clear();
                  _feetController.clear();
                  _inchController.clear();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isMetricHeight)
          TextField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Enter height in cm',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: const Color(0xFF0A0E21),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _feetController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Feet',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF0A0E21),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _inchController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Inches',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF0A0E21),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.monitor_weight, color: Color(0xFF4ECDC4), size: 20),
            const SizedBox(width: 8),
            Text(
              'Weight',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[300]),
            ),
            const Spacer(),
            _buildUnitToggle(
              value: _isMetricWeight,
              option1: 'kg',
              option2: 'lbs',
              onChanged: (val) {
                setState(() {
                  _isMetricWeight = val;
                  _weightController.clear();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: _isMetricWeight ? 'Enter weight in kg' : 'Enter weight in lbs',
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFF0A0E21),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4ECDC4), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitToggle({required bool value, required String option1, required String option2, required Function(bool) onChanged}) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: const Color(0xFF0A0E21), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_buildToggleOption(option1, value, () => onChanged(true)), _buildToggleOption(option2, !value, () => onChanged(false))],
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF6C63FF) : Colors.transparent, borderRadius: BorderRadius.circular(6)),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isCalculating ? null : _calculateBMI,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFF6C63FF).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isCalculating
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calculate, size: 24),
                  SizedBox(width: 12),
                  Text('Calculate BMI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
      ),
    );
  }

  Widget _buildResultCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_getCategoryColor(_category).withValues(alpha: 0.2), _getCategoryColor(_category).withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getCategoryColor(_category).withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Text(
              'Your BMI',
              style: TextStyle(fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              _bmiResult!.toStringAsFixed(1),
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: _getCategoryColor(_category), height: 1),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: _getCategoryColor(_category).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
              child: Text(
                _category,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _getCategoryColor(_category)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Typewriter effect widget for AI insights
class TypewriterAIInsights extends StatefulWidget {
  final List<String> insights;
  final Color categoryColor;
  final ScrollController scrollController;

  const TypewriterAIInsights({super.key, required this.insights, required this.categoryColor, required this.scrollController});

  @override
  State<TypewriterAIInsights> createState() => _TypewriterAIInsightsState();
}

class _TypewriterAIInsightsState extends State<TypewriterAIInsights> {
  final List<String> _displayedInsights = [];
  String _currentInsight = '';
  int _currentIndex = 0;
  int _currentCharIndex = 0;
  Timer? _timer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _isTyping = true;
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_currentIndex >= widget.insights.length) {
        timer.cancel();
        setState(() => _isTyping = false);
        return;
      }

      String fullText = widget.insights[_currentIndex];

      if (_currentCharIndex < fullText.length) {
        setState(() {
          _currentCharIndex++;
          _currentInsight = fullText.substring(0, _currentCharIndex);
        });

        // Scroll to bottom as text appears
        _scrollToBottom();
      } else {
        // Move to next insight
        setState(() {
          _displayedInsights.add(_currentInsight);
          _currentInsight = '';
          _currentIndex++;
          _currentCharIndex = 0;
        });

        // Scroll after completing an insight
        _scrollToBottom();

        // Small pause between insights
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _startTyping();
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text('AI Insights', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              if (_isTyping) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          // Display completed insights
          ...List.generate(_displayedInsights.length, (index) {
            return Padding(padding: const EdgeInsets.only(bottom: 16), child: _buildInsightRow(_displayedInsights[index]));
          }),
          // Display currently typing insight
          if (_currentInsight.isNotEmpty) _buildInsightRow(_currentInsight, showCursor: true),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String text, {bool showCursor = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: Color(0xFF4ECDC4), shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey[300]),
              children: [
                TextSpan(text: text),
                if (showCursor)
                  TextSpan(
                    text: '▋',
                    style: TextStyle(color: widget.categoryColor, fontWeight: FontWeight.w300),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
