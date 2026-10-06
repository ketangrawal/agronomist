import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../screens/analysis_screen.dart'; // ✅ make sure this path is correct


class MicInput extends StatefulWidget {
  const MicInput({super.key});

  @override
  State<MicInput> createState() => _MicInputState();
}

class _MicInputState extends State<MicInput> with TickerProviderStateMixin {
  bool isRecording = false;
  String transcript = "";

  late AnimationController _pulseController1;
  late AnimationController _pulseController2;
  late List<AnimationController> _waveControllers;

  final List<int> baseHeights = [8, 16, 24, 32, 40, 32, 24, 16, 8];

  @override
  void initState() {
    super.initState();

    // Pulse rings
    _pulseController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _pulseController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(period: const Duration(milliseconds: 300));

    // Waveform bars
    _waveControllers = List.generate(baseHeights.length, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      )..repeat(reverse: true, period: Duration(milliseconds: 800 + i * 80));
    });
  }

  @override
  void dispose() {
    _pulseController1.dispose();
    _pulseController2.dispose();
    for (var c in _waveControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.homeSpeak)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // ✅ Mic button with animated pulse rings
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isRecording = !isRecording;
                    transcript = isRecording
                        ? (loc.localeName == 'mr'
                            ? "पानांवर पांढरी पावडर येत आहे आणि पाने पिवळी होत आहेत..."
                            : "The leaves are turning yellow with white powder on them...")
                        : "";
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isRecording) ...[
                      _buildPulseRing(_pulseController1, 0.3),
                      _buildPulseRing(_pulseController2, 0.2),
                    ],
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isRecording
                              ? [const Color(0xFFE76F51), const Color(0xFFF4A261)]
                              : [const Color(0xFF2d6a4f), const Color(0xFF52b788)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          )
                        ],
                      ),
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status text
            Text(
              isRecording ? loc.listening : loc.tapToSpeak,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1b4332),
              ),
            ),
            const SizedBox(height: 8),

            // Sub-text
            Text(
              isRecording
                  ? (loc.localeName == 'mr' ? "थांबण्यासाठी दाबा" : "Tap to stop")
                  : loc.supportedLanguages,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // ✅ Animated Waveform (recording only)
            if (isRecording)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(baseHeights.length, (i) {
                  return AnimatedBuilder(
                    animation: _waveControllers[i],
                    builder: (context, child) {
                      final scaleY = 0.4 + _waveControllers[i].value * 0.6;
                      return Container(
                        width: 8,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Center(
                          child: Transform.scale(
                            scaleY: scaleY,
                            alignment: Alignment.center,
                            child: Container(
                              width: 8,
                              height: baseHeights[i].toDouble(),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE76F51),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

            const SizedBox(height: 24),

            // Transcript box (recording only)
            if (isRecording)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  transcript,
                  style: const TextStyle(
                    color: Color(0xFF6b7280),
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
              ),

            // ✅ Analyze Crop Button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: transcript.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnalysisScreen(),
                          ),
                        );
                      },
                icon: const Icon(Icons.search, color: Colors.white),
                label: Text(
                  loc.analyzeCrop, // EN: "Analyze Crop", MR: "पीक तपासा"
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: const Color(0xFF2d6a4f),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF2d6a4f).withOpacity(0.5),
                  disabledForegroundColor: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseRing(AnimationController controller, double opacity) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + controller.value * 0.6,
          child: Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(opacity * (1 - controller.value)),
            ),
          ),
        );
      },
    );
  }
}
