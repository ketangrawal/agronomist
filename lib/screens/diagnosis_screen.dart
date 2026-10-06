import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../l10n/app_localizations.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  late AnimationController _pulseController;
  String _lastRecognizedWords = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.85,
      upperBound: 1.15,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    final isMarathi = Localizations.localeOf(context).languageCode == 'mr';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF2D6A4F)),
              title: Text(isMarathi ? 'कॅमेरा उघडा' : 'Take a photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF2D6A4F)),
              title: Text(isMarathi ? 'गॅलरीतून निवडा' : 'Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleListening() async {
    final currentLanguageCode = Localizations.localeOf(context).languageCode;
    final localeId = currentLanguageCode == 'mr' ? 'mr_IN' : 'en_IN';

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if ((status == 'done' || status == 'notListening') && mounted) {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          if (mounted) setState(() => _isListening = false);
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _lastRecognizedWords = _controller.text.trim();

        _speech.listen(
          localeId: localeId,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 4),
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.dictation,
          onResult: (result) {
            setState(() {
              final base =
                  _lastRecognizedWords.isEmpty ? '' : '$_lastRecognizedWords ';
              _controller.text = '$base${result.recognizedWords}';
            });
          },
        );
      }
    } else {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
    }
  }

  bool get _canAnalyze =>
      _controller.text.trim().isNotEmpty || _selectedImage != null;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMarathi = Localizations.localeOf(context).languageCode == 'mr';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Upload Section
            Text(
              isMarathi ? 'पिकाचा / पानाचा फोटो जोडा' : 'Leaf / Crop Photo',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B4332),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: _selectedImage == null
                  ? InkWell(
                      onTap: _showImageSourceDialog,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFD8F3DC),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo_outlined,
                              size: 40,
                              color: Color(0xFF2D6A4F),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isMarathi
                                  ? 'फोटो काढण्यासाठी किंवा निवडण्यासाठी टॅप करा'
                                  : 'Tap to take photo or choose leaf image',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _selectedImage!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  size: 18, color: Colors.white),
                              onPressed: () =>
                                  setState(() => _selectedImage = null),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 20),

            // Text Description
            Text(
              loc.describeProblem,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B4332),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD8F3DC),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: isMarathi
                      ? 'उदा. ऊसाची पाने पिवळी पडत आहेत किंवा तांबूस करपा...'
                      : 'e.g. Sugarcane leaves turning yellow with red spots...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Voice Dictation Button
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _toggleListening,
                    child: ScaleTransition(
                      scale: _isListening
                          ? _pulseController
                          : const AlwaysStoppedAnimation(1.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening
                              ? const Color(0xFFE76F51)
                              : const Color(0xFF2D6A4F),
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening
                                      ? const Color(0xFFE76F51)
                                      : const Color(0xFF2D6A4F))
                                  .withOpacity(0.35),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isListening
                        ? (isMarathi
                            ? 'ऐकत आहे... बोला'
                            : 'Listening... Speak now')
                        : (isMarathi
                            ? 'माईक चालू करण्यासाठी टॅप करा'
                            : 'Tap mic to speak'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isListening
                          ? const Color(0xFFE76F51)
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Analyze Crop Button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: !_canAnalyze
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
                      ),
                color: !_canAnalyze ? Colors.grey.shade300 : null,
              ),
              child: ElevatedButton(
                onPressed: !_canAnalyze
                    ? null
                    : () {
                        Navigator.pushNamed(
                          context,
                          '/analysis',
                          arguments: {
                            'query': _controller.text.trim(),
                            'imageFile': _selectedImage,
                          },
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  loc.analyzeCrop,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}