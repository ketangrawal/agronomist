# 🌱 Agronomist: Smart Crop Doctor & Advisory System

An intelligent, on-device agricultural diagnostic and advisory application built with **Flutter**, **TensorFlow Lite**, and **Firebase Firestore**, designed to support Indian farmers with real-time disease identification and localized bio-fertilizer recommendations.

---

## 🚀 Key Features

- **Multi-Modal Diagnostic Input**:
  - **Visual Diagnosis**: Real-time camera capture & gallery image processing via an on-device CNN.
  - **Speech & Text Search**: Integrated speech-to-text supporting Marathi and English agricultural terminology.
  - **Fuzzy Matching**: Automated spelling correction and graceful fallbacks to nutrient management advice.
- **On-Device Machine Learning**:
  - Quantized **MobileNetV2** (224x224x3) running locally via `tflite_flutter` without cloud latency.
  - Detects **33 crop-disease categories** across major cash crops, cereals, millets, pulses, and oilseeds.
- **Targeted Product Recommendation Engine**:
  - Automatic rule-based pairing of diagnosed conditions with specific **BIO-F** inputs (BIO-F Fishmeal, Phosphate, Super).
  - Real-time cloud sync with Firebase Firestore for updated pricing and regional package details.
- **Bilingual Support (English & Marathi)**:
  - Complete `.arb` localization for UI strings, crop names, pathogens, and remedies.
- **Native Sharing & History**:
  - Export diagnostic summaries over WhatsApp/SMS using `share_plus`.
  - Save diagnosis reports to Firebase Firestore history.

---

## 🌾 Supported Crops & Diseases (33 Classes)

| Category | Crops | Pathologies & Disorders |
| :--- | :--- | :--- |
| **Cash Crops** | Sugarcane (*ऊस*), Cotton (*कापूस*) | Red Rot, Smut, Wilt, Bacterial Blight, Root Rot, Leaf Curl Virus |
| **Cereals & Millets** | Rice (*भात*), Maize (*मका*), Jowar (*ज्वारी*), Bajra (*बाजरी*) | Blast, Brown Spot, Sheath Blight, Turcicum Leaf Blight, Common Rust, Maydis Leaf Blight, Grain Mold, Downy Mildew, Anthracnose, Ergot |
| **Pulses** | Tur Dal (*तूर*), Moong (*मूग*), Urad Dal (*उडीद*) | Fusarium Wilt, Sterility Mosaic, Phytophthora Blight, Yellow Mosaic Virus, Powdery Mildew, Cercospora Leaf Spot, Leaf Crinkle |
| **Oilseeds** | Soybean (*सोयाबीन*), Groundnut (*भुईमूग*) | Rust, Bacterial Blight, Frogeye Leaf Spot, Tikka Leaf Spot, Collar/Crown Rot |

---

## 🛠️️ Architecture & Hardware Compatibility

- **Framework**: Flutter (Dart)
- **AI/ML Runtime**: TensorFlow Lite (`tflite_flutter`)
- **Backend / Cloud**: Firebase Firestore (`cloud_firestore`, `firebase_core`)
- **Graphics Pipeline**: Configured with `RenderMode.texture` (`FlutterTextureView`) in `MainActivity.kt` to eliminate GPU surface deadlocks and ensure seamless rendering across OEM Android distributions.

---

## 📦 Getting Started

### Prerequisites
- Flutter SDK (3.x+)
- Android SDK (API 34+)
- Connected physical device or Android Emulator

### Run Locally
```bash
# Clone the repository
git clone [https://github.com/ketangrawal/agronomist.git](https://github.com/ketangrawal/agronomist.git)
cd agronomist

# Install Flutter dependencies
flutter pub get

# Run on connected target
flutter run