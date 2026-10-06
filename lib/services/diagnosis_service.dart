import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'crop_disease_repository.dart';

class ProductModel {
  final String id;
  final String nameEn;
  final String nameMr;
  final String typeEn;
  final String typeMr;
  final String price;
  final String unitEn;
  final String unitMr;
  final String dosageEn;
  final String dosageMr;

  ProductModel({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.typeEn,
    required this.typeMr,
    required this.price,
    required this.unitEn,
    required this.unitMr,
    required this.dosageEn,
    required this.dosageMr,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      nameEn: data['name_en'] ?? '',
      nameMr: data['name_mr'] ?? '',
      typeEn: data['type_en'] ?? '',
      typeMr: data['type_mr'] ?? '',
      price: data['price'] ?? '',
      unitEn: data['unit_en'] ?? '',
      unitMr: data['unit_mr'] ?? '',
      dosageEn: data['dosage_en'] ?? '',
      dosageMr: data['dosage_mr'] ?? '',
    );
  }
}

class DiagnosisService {
  // Use getters to prevent early initialization before Firebase.initializeApp()
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  // Upload leaf photo to Firebase Storage
  Future<String?> uploadCropImage(File imageFile) async {
    try {
      final fileName = 'crop_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('crop_images/$fileName');
      
      final uploadTask = await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  // Save report to Firestore
  Future<void> saveDiagnosisResult({
    required String diseaseName,
    required String severity,
    required double confidence,
    required String rootCause,
    required String queryInput,
    String? imageUrl,
  }) async {
    try {
      await _firestore.collection('diagnosis_history').add({
        'diseaseName': diseaseName,
        'severity': severity,
        'confidence': confidence,
        'rootCause': rootCause,
        'queryInput': queryInput,
        'imageUrl': imageUrl ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving diagnosis result: $e');
    }
  }

  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> seedFirestoreDatabase() async {
    try {
      final batch = _firestore.batch();

      // 1. Seed Products Catalog
      CropDiseaseRepository.products.forEach((key, p) {
        final docRef = _firestore.collection('products').doc(p.id);
        batch.set(docRef, {
          'id': p.id,
          'name_en': p.nameEn,
          'name_mr': p.nameMr,
          'type_en': p.typeEn,
          'type_mr': p.typeMr,
          'dosage_en': p.dosageEn,
          'dosage_mr': p.dosageMr,
          'price': p.price,
          'unit_en': p.unitEn,
          'unit_mr': p.unitMr,
        });
      });

      // 2. Seed Disease Treatments
      for (var t in CropDiseaseRepository.treatments) {
        final docId = '${t.crop.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}_${t.diseaseNameEn.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
        final docRef = _firestore.collection('disease_treatments').doc(docId);
        batch.set(docRef, {
          'crop': t.crop,
          'disease_id': docId,
          'disease_name_en': t.diseaseNameEn,
          'disease_name_mr': t.diseaseNameMr,
          'reason_en': t.reasonEn,
          'reason_mr': t.reasonMr,
          'product_ids': t.productKeys.map((k) => CropDiseaseRepository.products[k]?.id ?? k).toList(),
        });
      }

      await batch.commit();
      debugPrint("✅ Firestore successfully seeded from Flutter app!");
    } catch (e) {
      debugPrint("Seeding skipped or failed: $e");
    }
  }
}