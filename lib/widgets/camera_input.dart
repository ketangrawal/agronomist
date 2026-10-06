import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../screens/analysis_screen.dart'; // ✅ ensure path is correct

class CameraInput extends StatefulWidget {
  const CameraInput({super.key});

  @override
  State<CameraInput> createState() => _CameraInputState();
}

class _CameraInputState extends State<CameraInput> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _capturePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.homeTakePhoto)),
      body: Column(
        children: [
          // ✅ Viewfinder
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Show captured image OR camera icon
                  if (_imageFile != null)
                    Image.file(_imageFile!, fit: BoxFit.cover)
                  else
                    const Center(
                      child: Icon(Icons.camera_alt,
                          size: 80, color: Colors.white),
                    ),

                  // Hint pill (before capture)
                  if (_imageFile == null)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            loc.cameraHint,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Photo Ready badge (after capture)
                  if (_imageFile != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              loc.photoReady,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ✅ Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: _imageFile != null
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _imageFile = null),
                          child: Text(loc.retakePhoto),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AnalysisScreen(), // parameterless
                              ),
                            );
                          },
                          child: Text(loc.usePhoto),
                        ),
                      ),
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: _capturePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(loc.capturePhoto),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _cornerGuide(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}
