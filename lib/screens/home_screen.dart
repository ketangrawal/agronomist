import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/camera_input.dart';
import '../widgets/mic_input.dart';
import 'diagnosis_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleLocale;
  const HomeScreen({super.key, required this.onToggleLocale});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1b4332), // deep forest green
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF52b788),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text("🌱", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.appTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  isEnglish ? "Smart Crop Doctor" : "स्मार्ट पीक डॉक्टर",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF95d5b2),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF4A261),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: onToggleLocale,
            child: Text(
              isEnglish ? "मराठी" : "English",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1b4332),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Hero Banner
          Container(
            height: 176,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2d6a4f), Color(0xFF40916c)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/farm_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("🌾", style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text(
                        loc.homeTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ Input Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOptionCard(
                  context,
                  emoji: "📷",
                  gradient: const [Color(0xFF2d6a4f), Color(0xFF52b788)],
                  label: loc.homeTakePhoto,
                  sublabel: loc.takePhotoSubtitle,
                  borderColor: const Color(0xFFD8F3DC),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CameraInput()),
                  ),
                ),
                _buildOptionCard(
                  context,
                  emoji: "🎤",
                  gradient: const [Color(0xFFE76F51), Color(0xFFF4A261)],
                  label: loc.homeSpeak,
                  sublabel: loc.speakSubtitle,
                  borderColor: const Color(0xFFFDE8D4),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MicInput()),
                  ),
                ),
                _buildOptionCard(
                  context,
                  emoji: "✏️",
                  gradient: const [Color(0xFF8B5E3C), Color(0xFFE9C46A)],
                  label: loc.homeType,
                  sublabel: loc.typeSubtitle,
                  borderColor: const Color(0xFFE9E4C8),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DiagnosisScreen()),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Tip Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD8F3DC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("💡", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    loc.homeNote,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1b4332),
                      height: 1.3,
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

  Widget _buildOptionCard(
    BuildContext context, {
    required String emoji,
    required List<Color> gradient,
    required String label,
    required String sublabel,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1b4332))),
                  Text(sublabel,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF6b7280))),
                ],
              ),
            ),
            const Text("›", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
