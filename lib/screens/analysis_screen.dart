import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/classifier_service.dart';
import '../services/crop_disease_repository.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  int _currentStep = 0;

  String? _inputText;
  String? _imagePath;
  bool _analysisStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_analysisStarted) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _inputText = args;
      } else if (args is Map<String, dynamic>) {
        _inputText = args['query'] as String?;
        _imagePath = args['imagePath'] as String?;
      }

      _analysisStarted = true;
      _executeAnalysis();
    }
  }

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _executeAnalysis() async {
    // Step 1: Scanning input / preprocessing image
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _currentStep = 1);

    String predictedLabel = _inputText ?? '';
    double confidenceScore = 0.92;

    // Run TFLite inference if an image file was supplied
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      final imageFile = File(_imagePath!);
      if (await imageFile.exists()) {
        try {
          final classifier = CropClassifier();
          await classifier.initialize();
          if (classifier.isReady) {
            final predictions = await classifier.runInference(imageFile);
            if (predictions.isNotEmpty) {
              predictedLabel = predictions.first.label;
              confidenceScore = predictions.first.confidence;
            }
          }
        } catch (e) {
          debugPrint('TFLite inference fallback (using text query): $e');
        }
      }
    }

    // Step 2: Identifying condition
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _currentStep = 2);

    // Resolve disease & recommended BIO-F product mapping
    final treatment = CropDiseaseRepository.findTreatment(predictedLabel);

    // Step 3: Preparing recommendations
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _currentStep = 3);

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/results',
        arguments: {
          'cropName': treatment.cropName,
          'diseaseNameEn': treatment.diseaseNameEn,
          'diseaseNameMr': treatment.diseaseNameMr,
          'reasonEn': treatment.reasonEn,
          'reasonMr': treatment.reasonMr,
          'recommendedProducts': treatment.recommendedProducts,
          'dosageEn': treatment.dosageGuideEn,
          'dosageMr': treatment.dosageGuideMr,
          'confidence': confidenceScore,
          'severity': confidenceScore > 0.85 ? 'High' : 'Moderate',
          'imagePath': _imagePath,
          'rawQuery': _inputText ?? '',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFAE0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating & Pulsing Spinner
            Stack(
              alignment: Alignment.center,
              children: [
                ScaleTransition(
                  scale: _pulseController,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD8F3DC),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text("🌿", style: TextStyle(fontSize: 32)),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: RotationTransition(
                    turns: _rotationController,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border(
                          top: BorderSide(color: Color(0xFF2D6A4F), width: 4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              loc.analysisTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4332),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              loc.analysisSubtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Bounce Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBounceDot(0),
                _buildBounceDot(200),
                _buildBounceDot(400),
              ],
            ),

            const SizedBox(height: 32),

            // Step Progress Cards
            Column(
              children: [
                _buildStepCard(text: loc.stepScanning, done: _currentStep >= 1),
                _buildStepCard(text: loc.stepIdentifying, done: _currentStep >= 2),
                _buildStepCard(text: loc.stepPreparing, done: _currentStep >= 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBounceDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: -6),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, value),
        child: child,
      ),
      child: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          color: Color(0xFF2D6A4F),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildStepCard({required String text, required bool done}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: done ? const Color(0xFFD8F3DC) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(done ? "✅" : "⏳", style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: done ? const Color(0xFF2D6A4F) : const Color(0xFF6B7280),
              fontWeight: done ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}