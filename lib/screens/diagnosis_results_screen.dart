import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../services/diagnosis_service.dart';

class DiagnosisResultsScreen extends StatefulWidget {
  const DiagnosisResultsScreen({super.key});

  @override
  State<DiagnosisResultsScreen> createState() => _DiagnosisResultsScreenState();
}

class _DiagnosisResultsScreenState extends State<DiagnosisResultsScreen> {
  final DiagnosisService _diagnosisService = DiagnosisService();

  Map<String, dynamic>? _diagnosisData;
  String _inputQuery = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_diagnosisData == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _diagnosisData = args;
        _inputQuery = (args['rawQuery'] as String?) ?? "";
      } else if (args is String) {
        _inputQuery = args;
      }
    }
  }

  void _shareResults(BuildContext context, String diseaseName, String rootCause, List<String> products, String dosage) {
    final text = '''
🌾 Agronomist Diagnosis Report
🔍 Disease / Status: $diseaseName
🔬 Description: $rootCause
💊 Recommended Treatment: ${products.isEmpty ? 'N/A' : products.join(', ')}
📋 Dosage & Method: $dosage
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMarathi = Localizations.localeOf(context).languageCode == 'mr';

    final cropName = _diagnosisData?['cropName'] as String? ?? 'Unavailable';
    final diseaseName = isMarathi
        ? (_diagnosisData?['diseaseNameMr'] as String? ?? 'पीक किंवा रोगाची माहिती उपलब्ध नाही')
        : (_diagnosisData?['diseaseNameEn'] as String? ?? 'Crop / Disease Data Unavailable');
    final rootCause = isMarathi
        ? (_diagnosisData?['reasonMr'] as String? ??
            'स्कॅन केलेले पीक किंवा टाकलेला रोग सध्या आमच्या ३३ खरीप आणि बागायती पिकांच्या यादीत उपलब्ध नाही.')
        : (_diagnosisData?['reasonEn'] as String? ??
            'The scanned plant or entered condition is not currently covered in our 33 Kharif & Cash crop database.');
    final dosageGuide = isMarathi
        ? (_diagnosisData?['dosageMr'] as String? ?? 'अनोळखी पिकाच्या स्थितीसाठी विशिष्ट बायो-एफ डोस उपलब्ध नाही.')
        : (_diagnosisData?['dosageEn'] as String? ?? 'No specific BIO-F dosage available for unrecognized crop conditions.');
    final double confidence = (_diagnosisData?['confidence'] as num?)?.toDouble() ?? 0.0;
    final String severity = _diagnosisData?['severity'] as String? ?? 'N/A';

    final bool isUnavailable = cropName.toLowerCase() == 'unavailable' ||
        diseaseName.toLowerCase().contains('unavailable') ||
        diseaseName.contains('उपलब्ध नाही');

    final List<String> targetProductNames = isUnavailable
        ? []
        : List<String>.from(
            (_diagnosisData?['recommendedProducts'] ?? []).toSet(),
          );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(loc.diagnosisResults),
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(
              context,
              diseaseName,
              rootCause,
              targetProductNames,
              dosageGuide,
            ),
          ),
          if (!isUnavailable)
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              onPressed: () async {
                await _diagnosisService.saveDiagnosisResult(
                  diseaseName: diseaseName,
                  severity: severity,
                  confidence: confidence,
                  rootCause: rootCause,
                  queryInput: _inputQuery,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.saveSuccess)),
                  );
                }
              },
            ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // 1. Disease / Status Banner Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: isUnavailable
                        ? [const Color(0xFF374151), const Color(0xFF4B5563)]
                        : [const Color(0xFF1B4332), const Color(0xFF2D6A4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                isUnavailable
                                    ? (isMarathi ? "स्थिती" : "STATUS")
                                    : (isMarathi ? "आढळलेला रोग" : "DISEASE DETECTED"),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: isUnavailable ? const Color(0xFFE5E7EB) : const Color(0xFF95D5B2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isUnavailable
                                      ? Colors.white24
                                      : const Color(0xFF52B788).withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isUnavailable ? (isMarathi ? "माहिती उपलब्ध नाही" : "Not Found") : cropName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            diseaseName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (!isUnavailable) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: severity == 'High' ? const Color(0xFFFFD1D1) : const Color(0xFFFFF3CD),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    severity == 'High'
                                        ? (isMarathi ? "गंभीर" : "High")
                                        : (isMarathi ? "मध्यम" : "Moderate"),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: severity == 'High' ? const Color(0xFF900C3F) : const Color(0xFF856404),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "${loc.confidence}: ${(confidence * 100).toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: confidence,
                                minHeight: 6,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(Color(0xFF52B788)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isUnavailable
                          ? "❓"
                          : (cropName.toLowerCase().contains("sugarcane")
                              ? "🎋"
                              : (cropName.toLowerCase().contains("cotton") ? "☁️️" : "🌾")),
                      style: const TextStyle(fontSize: 34),
                    ),
                  ],
                ),
              ),

              // 2. Details / Root Cause Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD8F3DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(isUnavailable ? "ℹ️" : "🔬", style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          isUnavailable ? (isMarathi ? "तपशील" : "Information") : loc.rootCause,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B4332),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rootCause,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Unavailable Alert Notice OR Recommended Products & Guide
              if (isUnavailable)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("⚠️", style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isMarathi
                              ? "सध्या हे पीक किंवा रोग आमच्या डेटाबेसमध्ये उपलब्ध नाही. आम्ही लवकरच नवीन पिकांची माहिती समाविष्ट करू. कृपया योग्य सल्ल्यासाठी स्थानिक कृषी तज्ज्ञांशी संपर्क साधा."
                              : "This crop or disease is currently not in our database. We are actively expanding to more crops. Please consult a local agricultural officer for unlisted crops.",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF92400E),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                // Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text("🌱", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        isMarathi ? "शिफारस केलेली BIO-F खते व उपचार" : "Recommended BIO-F Treatments",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B4332),
                        ),
                      ),
                    ],
                  ),
                ),

                // Products Stream (Deduplicated)
                StreamBuilder<List<ProductModel>>(
                  stream: _diagnosisService.getProducts(),
                  builder: (context, snapshot) {
                    final Map<String, _DisplayProduct> uniqueProductsMap = {};

                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      for (final targetName in targetProductNames) {
                        final targetKey = targetName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
                        for (final p in snapshot.data!) {
                          final productKey = p.nameEn.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
                          if (productKey.contains(targetKey) || targetKey.contains(productKey)) {
                            if (!uniqueProductsMap.containsKey(productKey)) {
                              uniqueProductsMap[productKey] = _DisplayProduct(
                                name: isMarathi ? p.nameMr : p.nameEn,
                                type: isMarathi ? p.typeMr : p.typeEn,
                                price: p.price.startsWith('₹') ? p.price : '₹${p.price}',
                                unit: isMarathi ? p.unitMr : p.unitEn,
                                dosage: isMarathi ? p.dosageMr : p.dosageEn,
                              );
                            }
                          }
                        }
                      }
                    }

                    if (uniqueProductsMap.isEmpty) {
                      for (final name in targetProductNames) {
                        final isFish = name.contains("Fishmeal");
                        final isPhos = name.contains("Phosphate");
                        final key = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

                        uniqueProductsMap[key] = _DisplayProduct(
                          name: isMarathi
                              ? (isFish ? "बायो-एफ फिशमील" : (isPhos ? "बायो-एफ फॉस्फेट" : "बायो-एफ सुपर"))
                              : name,
                          type: isFish
                              ? (isMarathi ? "सेंद्रिय खत व जमीन सुधारक" : "Organic Fertilizer")
                              : (isPhos
                                  ? (isMarathi ? "फॉस्फेटिक बायो-खत" : "Phosphatic Bio-Fertilizer")
                                  : (isMarathi ? "जमीन संजीवनी आणि वाढ प्रवर्तक" : "Growth Booster")),
                          price: isFish ? "₹950" : (isPhos ? "₹750" : "₹850"),
                          unit: isMarathi ? "प्रति ५० किलो" : "per 50 kg",
                          dosage: isFish
                              ? (isMarathi ? "१००-१५० किलो प्रति एकर" : "100-150 kg/acre")
                              : (isPhos
                                  ? (isMarathi ? "५० किलो प्रति एकर" : "50 kg/acre")
                                  : (isMarathi ? "५०-१०० किलो प्रति एकर" : "50-100 kg/acre")),
                        );
                      }
                    }

                    final displayList = uniqueProductsMap.values.toList();

                    return Column(
                      children: List.generate(displayList.length, (index) {
                        final p = displayList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildProductCard(
                            badge: "${index + 1}",
                            name: p.name,
                            type: p.type,
                            price: p.price,
                            unit: p.unit,
                            dosage: p.dosage,
                            dosageLabel: loc.dosage,
                          ),
                        );
                      }),
                    );
                  },
                ),

                const SizedBox(height: 6),

                // Application & Dosage Guide
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFB7E4C7)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("📋", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMarathi ? "वापरण्याची पद्धत व डोस" : "Application & Dosage Guide",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B4332),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dosageGuide,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2D6A4F),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Bottom Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Text("🌱", style: TextStyle(fontSize: 18)),
                  label: Text(
                    loc.checkAnotherCrop,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String badge,
    required String name,
    required String type,
    required String price,
    required String unit,
    required String dosage,
    required String dosageLabel,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8F3DC), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8F3DC),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  badge,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B4332),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE76F51),
                    ),
                  ),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.eco_outlined, size: 14, color: Color(0xFF2D6A4F)),
                const SizedBox(width: 6),
                Text(
                  "$dosageLabel: ",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D6A4F)),
                ),
                Expanded(
                  child: Text(
                    dosage,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayProduct {
  final String name;
  final String type;
  final String price;
  final String unit;
  final String dosage;

  _DisplayProduct({
    required this.name,
    required this.type,
    required this.price,
    required this.unit,
    required this.dosage,
  });
}