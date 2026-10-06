class ProductItem {
  final String id;
  final String nameEn;
  final String nameMr;
  final String typeEn;
  final String typeMr;
  final String dosageEn;
  final String dosageMr;
  final String price;
  final String unitEn;
  final String unitMr;

  const ProductItem({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.typeEn,
    required this.typeMr,
    required this.dosageEn,
    required this.dosageMr,
    required this.price,
    required this.unitEn,
    required this.unitMr,
  });
}

class CropTreatmentRule {
  final String cropName;
  final String diseaseNameEn;
  final String diseaseNameMr;
  final String reasonEn;
  final String reasonMr;
  final List<String> recommendedProducts;
  final List<String> productKeys;
  final String dosageGuideEn;
  final String dosageGuideMr;

  const CropTreatmentRule({
    required this.cropName,
    required this.diseaseNameEn,
    required this.diseaseNameMr,
    required this.reasonEn,
    required this.reasonMr,
    required this.recommendedProducts,
    this.productKeys = const [],
    required this.dosageGuideEn,
    required this.dosageGuideMr,
  });

  // Backward compatibility alias for legacy code
  String get crop => cropName;
}

class CropDiseaseRepository {
  static const Map<String, ProductItem> products = {
    'bio_f_fishmeal': ProductItem(
      id: 'bio_f_fishmeal',
      nameEn: 'BIO-F Fishmeal',
      nameMr: 'बायो-एफ फिशमील',
      typeEn: 'Organic Fertilizer & Soil Conditioner',
      typeMr: 'सेंद्रिय खत व जमीन सुधारक',
      dosageEn: '100-150 kg per acre',
      dosageMr: '१००-१५० किलो प्रति एकर',
      price: '₹950',
      unitEn: 'per 50 kg bag',
      unitMr: 'प्रति ५० किलो बॅग',
    ),
    'bio_f_super': ProductItem(
      id: 'bio_f_super',
      nameEn: 'BIO-F Super',
      nameMr: 'बायो-एफ सुपर',
      typeEn: 'Soil Revitalizer & Growth Booster',
      typeMr: 'जमीन संजीवनी आणि वाढ प्रवर्तक',
      dosageEn: '50-100 kg per acre',
      dosageMr: '५०-१०० किलो प्रति एकर',
      price: '₹850',
      unitEn: 'per 50 kg bag',
      unitMr: 'प्रति ५० किलो बॅग',
    ),
    'bio_f_phosphate': ProductItem(
      id: 'bio_f_phosphate',
      nameEn: 'BIO-F Phosphate',
      nameMr: 'बायो-एफ फॉस्फेट',
      typeEn: 'Phosphatic Bio-Fertilizer',
      typeMr: 'फॉस्फेटिक बायो-खत',
      dosageEn: '50 kg per acre at sowing',
      dosageMr: '५० किलो प्रति एकर पेरणीच्या वेळी',
      price: '₹750',
      unitEn: 'per 50 kg bag',
      unitMr: 'प्रति ५० किलो बॅग',
    ),
  };

  static final Map<String, CropTreatmentRule> _treatments = {
    // CASH CROPS
    'sugarcane_red_rot': const CropTreatmentRule(
      cropName: 'Sugarcane',
      diseaseNameEn: 'Sugarcane Red Rot',
      diseaseNameMr: 'ऊसाचा तांबडे कूज रोग',
      reasonEn: 'Fungal pathogen Colletotrichum falcatum infecting the vascular bundles.',
      reasonMr: 'कॉलेटोट्रायकम फालकॅटम बुरशीमुळे खोडातील ऊतींचे नुकसान होते.',
      recommendedProducts: ['BIO-F Fishmeal', 'BIO-F Super'],
      productKeys: ['bio_f_fishmeal', 'bio_f_super'],
      dosageGuideEn: 'Apply BIO-F Fishmeal (100 kg/acre) + BIO-F Super at root zone.',
      dosageGuideMr: 'मुळांजवळ बायो-एफ फिशमील (१०० किलो/एकर) + बायो-एफ सुपर वापरा.',
    ),
    'sugarcane_smut': const CropTreatmentRule(
      cropName: 'Sugarcane',
      diseaseNameEn: 'Sugarcane Smut (Whip Smut)',
      diseaseNameMr: 'ऊसावरील काणी रोग (चाबूक काणी)',
      reasonEn: 'Sporisorium scitamineum causing black whip-like structures at shoot apex.',
      reasonMr: 'स्पोरिसोरियम सायटामिनियम बुरशीमुळे शेंड्यावर काळे चाबकासारखे आवरण तयार होते.',
      recommendedProducts: ['BIO-F Fishmeal', 'BIO-F Super'],
      productKeys: ['bio_f_fishmeal', 'bio_f_super'],
      dosageGuideEn: 'Root dip setts and soil drenching with BIO-F Super (50 kg/acre) + Fishmeal.',
      dosageGuideMr: 'बेणे प्रक्रिया आणि मातीमध्ये बायो-एफ सुपर (५० किलो/एकर) व फिशमील मिसळा.',
    ),
    'sugarcane_wilt': const CropTreatmentRule(
      cropName: 'Sugarcane',
      diseaseNameEn: 'Sugarcane Wilt',
      diseaseNameMr: 'ऊसाचा उबाळणी/मर रोग',
      reasonEn: 'Fusarium sacchari infection causing pith hollowing and crown drying.',
      reasonMr: 'फ्युजॅरियम बुरशीमुळे उसाचे आतील भाग पोकळ होऊन वाढ खुंटते.',
      recommendedProducts: ['BIO-F Fishmeal', 'BIO-F Super'],
      productKeys: ['bio_f_fishmeal', 'bio_f_super'],
      dosageGuideEn: 'Soil conditioning with BIO-F Fishmeal (150 kg/acre) to restore root health.',
      dosageGuideMr: 'मातीची सुपिकता वाढवण्यासाठी बायो-एफ फिशमील (१५० किलो/एकर) वापरा.',
    ),
    'cotton_bacterial_blight': const CropTreatmentRule(
      cropName: 'Cotton',
      diseaseNameEn: 'Cotton Bacterial Blight',
      diseaseNameMr: 'कापसावरील जिवाणू करपा',
      reasonEn: 'Xanthomonas citri pv. malvacearum causing angular water-soaked leaf spots.',
      reasonMr: 'झँथोमोनास जिवाणूमुळे पानांवर कोनीय व काळे ठिपके तयार होतात.',
      recommendedProducts: ['BIO-F Super', 'BIO-F Phosphate'],
      productKeys: ['bio_f_super', 'bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate at sowing, followed by BIO-F Super drenching.',
      dosageGuideMr: 'पेरणीवेळी बायो-एफ फॉस्फेट आणि वाढीच्या अवस्थेत बायो-एफ सुपर वापरा.',
    ),
    'cotton_root_rot': const CropTreatmentRule(
      cropName: 'Cotton',
      diseaseNameEn: 'Cotton Root Rot',
      diseaseNameMr: 'कापसावरील मूळकूज',
      reasonEn: 'Rhizoctonia bataticola attacking root cortex in warm, moist soil.',
      reasonMr: 'रायझोक्टोनिया बुरशीमुळे मुळांची साल कुजते आणि झाड सुकून जाते.',
      recommendedProducts: ['BIO-F Super', 'BIO-F Phosphate'],
      productKeys: ['bio_f_super', 'bio_f_phosphate'],
      dosageGuideEn: 'Soil drench with BIO-F Super and broadcast BIO-F Phosphate around root zone.',
      dosageGuideMr: 'बायो-एफ सुपरचे द्रावण मुळांशी घाला व बायो-एफ फॉस्फेट पसरवून द्या.',
    ),
    'cotton_leaf_curl': const CropTreatmentRule(
      cropName: 'Cotton',
      diseaseNameEn: 'Cotton Leaf Curl Virus',
      diseaseNameMr: 'कापसावरील चुरडा-मुरडा (लीफ कर्ल)',
      reasonEn: 'Begomovirus transmitted by whiteflies leading to upward/downward curling.',
      reasonMr: 'पांढऱ्या माशीमार्फत पसरणारा विषाणू ज्यामुळे पाने वर किंवा खाली मुरडतात.',
      recommendedProducts: ['BIO-F Super'],
      productKeys: ['bio_f_super'],
      dosageGuideEn: 'Soil revitalization with BIO-F Super to build systemic crop resistance.',
      dosageGuideMr: 'झाडाची रोगप्रतिकारशक्ती वाढवण्यासाठी बायो-एफ सुपरचा वापर करा.',
    ),

    // KHARIF CEREALS & GRAINS
    'rice_blast': const CropTreatmentRule(
      cropName: 'Rice',
      diseaseNameEn: 'Rice Blast',
      diseaseNameMr: 'भातावरील करपा (ब्लास्ट)',
      reasonEn: 'Magnaporthe oryzae producing diamond shaped lesions on leaves.',
      reasonMr: 'मॅग्नापोर्थे बुरशीमुळे पानांवर डोळ्याच्या आकाराचे करड्या रंगाचे ठिपके पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate (50 kg/acre) at early tillering stage.',
      dosageGuideMr: 'फुटवे येण्याच्या सुरुवातीच्या काळात बायो-एफ फॉस्फेट (५० किलो/एकर) द्या.',
    ),
    'rice_brown_spot': const CropTreatmentRule(
      cropName: 'Rice',
      diseaseNameEn: 'Rice Brown Spot',
      diseaseNameMr: 'भातावरील तपकिरी ठिपके',
      reasonEn: 'Bipolaris oryzae causing circular brown lesions.',
      reasonMr: 'बायपोलारिस बुरशीमुळे तपकिरी ठिपके पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Broadcast BIO-F Phosphate at 50 kg/acre to replenish phosphorus and root vigor.',
      dosageGuideMr: 'पांढऱ्या मुळांच्या वाढीसाठी बायो-एफ फॉस्फेट ५० किलो/एकर जमिनीत मिसळा.',
    ),
    'rice_sheath_blight': const CropTreatmentRule(
      cropName: 'Rice',
      diseaseNameEn: 'Rice Sheath Blight',
      diseaseNameMr: 'भातावरील खोड करपा (शीथ ब्लाइट)',
      reasonEn: 'Rhizoctonia solani spreading upward from water line to leaves.',
      reasonMr: 'पाण्याच्या पातळीजवळ पानांच्या आवरणावर सर्पाकार करडे डाग पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate at panicle initiation stage to fortify plant walls.',
      dosageGuideMr: 'पिकाची ताकद वाढवण्यासाठी पोटरीच्या अवस्थेत बायो-एफ फॉस्फेट वापरा.',
    ),
    'maize_turcicum_leaf_blight': const CropTreatmentRule(
      cropName: 'Maize',
      diseaseNameEn: 'Turcicum Leaf Blight',
      diseaseNameMr: 'मक्यावरील तुर्सिकम करपा',
      reasonEn: 'Exserohilum turcicum producing long elliptical lesions.',
      reasonMr: 'पानांवर लांबट बोट किंवा सिगारच्या आकाराचे तपकिरी पट्टे तयार होतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate (50 kg/acre) during knee-high vegetative stage.',
      dosageGuideMr: 'गुडघा-उंची अवस्थेत बायो-एफ फॉस्फेट (५० किलो/एकर) द्या.',
    ),
    'maize_common_rust': const CropTreatmentRule(
      cropName: 'Maize',
      diseaseNameEn: 'Maize Common Rust',
      diseaseNameMr: 'मक्यावरील तांबेरा',
      reasonEn: 'Puccinia sorghi forming powdery cinnamon-brown pustules.',
      reasonMr: 'पानांच्या दोन्ही बाजूंना तांबूस-तपकिरी रंगाच्या पुटकुळ्या तयार होतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Basal application of BIO-F Phosphate (50 kg/acre) to build stem resistance.',
      dosageGuideMr: 'पेरणीच्या वेळी बायो-एफ फॉस्फेट (५० किलो/एकर) चा बेसल डोस द्या.',
    ),
    'maize_maydis_leaf_blight': const CropTreatmentRule(
      cropName: 'Maize',
      diseaseNameEn: 'Maydis Leaf Blight',
      diseaseNameMr: 'मक्यावरील मायडिस करपा',
      reasonEn: 'Bipolaris maydis creating rectangular brown lesions constrained between veins.',
      reasonMr: 'शिरांमधील भागात लहान चौकोनी करड्या-तपकिरी रंगाचे डाग पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Soil application of BIO-F Phosphate to boost root biomass and immunity.',
      dosageGuideMr: 'जमिनीची सुपीकता व मुळांची क्षमता वाढवण्यासाठी बायो-एफ फॉस्फेट द्या.',
    ),
    'jowar_grain_mold': const CropTreatmentRule(
      cropName: 'Jowar',
      diseaseNameEn: 'Jowar Grain Mold',
      diseaseNameMr: 'ज्वारीवरील दाणे बुरशी',
      reasonEn: 'Fusarium and Curvularia complex spoiling grains during humid maturation.',
      reasonMr: 'पावसाळी हवेत दाणे भरताना बुरशीमुळे दाण्यांचा रंग काळा किंवा गुलाबी होतो.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Soil application of BIO-F Phosphate (50 kg/acre) at boot leaf stage.',
      dosageGuideMr: 'पोटरी अवस्थेत बायो-एफ फॉस्फेट (५० किलो/एकर) जमिनीत मिसळा.',
    ),
    'jowar_downy_mildew': const CropTreatmentRule(
      cropName: 'Jowar',
      diseaseNameEn: 'Jowar Downy Mildew',
      diseaseNameMr: 'ज्वारीवरील केवडा/डाउनी मिल्ड्यू',
      reasonEn: 'Peronosclerospora sorghi resulting in vivid chlorotic leaf striping.',
      reasonMr: 'पानांवर पिवळे व पांढरे लांबट पट्टे पडतात आणि पानांच्या मागे पांढरी बुरशी दिसते.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Basal soil incorporation of BIO-F Phosphate (50 kg/acre).',
      dosageGuideMr: 'पेरणीच्या वेळी बायो-एफ फॉस्फेट (५० किलो/एकर) मातीमध्ये मिसळा.',
    ),
    'jowar_anthracnose': const CropTreatmentRule(
      cropName: 'Jowar',
      diseaseNameEn: 'Jowar Anthracnose',
      diseaseNameMr: 'ज्वारीवरील तांबडे ठिपके (अँथ्रॅकनोज)',
      reasonEn: 'Colletotrichum sublineolum causing circular to elliptical reddish lesions.',
      reasonMr: 'पानांवर व खोडावर मध्यभागी फिकट आणि कडेला तांबूस असलेले डाग पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Soil application of BIO-F Phosphate (50 kg/acre) to enhance vigor.',
      dosageGuideMr: 'रोगास प्रतिबंध करण्यासाठी बायो-एफ फॉस्फेटचा वापर करा.',
    ),
    'bajra_downy_mildew': const CropTreatmentRule(
      cropName: 'Bajra',
      diseaseNameEn: 'Bajra Downy Mildew (Green Ear)',
      diseaseNameMr: 'बाजरीवरील गोसावी/केवडा रोग',
      reasonEn: 'Sclerospora graminicola transforming floral heads into twisted leafy shoots.',
      reasonMr: 'कणीस तयार न होता त्यावर पालेभाज्यांसारखी पाने (हिरवे आवरण) तयार होतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Basal placement of BIO-F Phosphate (50 kg/acre) at field preparation.',
      dosageGuideMr: 'जमीन तयार करताना बायो-एफ फॉस्फेट (५० किलो/एकर) जमिनीत मिसळा.',
    ),
    'bajra_ergot': const CropTreatmentRule(
      cropName: 'Bajra',
      diseaseNameEn: 'Bajra Ergot',
      diseaseNameMr: 'बाजरीवरील अरगट (चिकटा)',
      reasonEn: 'Claviceps fusiformis oozing honeydew fluid that hardens into dark sclerotia.',
      reasonMr: 'फुलोऱ्याच्या वेळी मधासारखा चिकट द्रव पाझरतो आणि नंतर काळे खडे तयार होतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate to speed up uniform flowering.',
      dosageGuideMr: 'पिकाची एकसारखी वाढ होण्यासाठी बायो-एफ फॉस्फेटचा वापर करा.',
    ),
    'bajra_rust': const CropTreatmentRule(
      cropName: 'Bajra',
      diseaseNameEn: 'Bajra Rust',
      diseaseNameMr: 'बाजरीवरील तांबेरा',
      reasonEn: 'Puccinia substriata forming reddish-orange pustules on foliage.',
      reasonMr: 'पानांवर नारंगी-तांबूस रंगाचे लहान ठिपके आणि पावडर तयार होते.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Soil application of BIO-F Phosphate (50 kg/acre).',
      dosageGuideMr: 'बायो-एफ फॉस्फेट (५० किलो/एकर) मातीत टाका.',
    ),

    // KHARIF PULSES
    'tur_fusarium_wilt': const CropTreatmentRule(
      cropName: 'Tur Dal',
      diseaseNameEn: 'Tur Fusarium Wilt',
      diseaseNameMr: 'तुरीवरील मर रोग',
      reasonEn: 'Fusarium udum clogging xylem vessels, causing sudden plant wilting.',
      reasonMr: 'जमिनीतील बुरशी खोडातील पाणी पुरवठा बंद करते.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate (50 kg/acre) at sowing; promotes deep root penetration.',
      dosageGuideMr: 'पेरणीच्या वेळी बायो-एफ फॉस्फेट द्या; मुळांची वाढ खोलवर होण्यास मदत होते.',
    ),
    'tur_sterility_mosaic': const CropTreatmentRule(
      cropName: 'Tur Dal',
      diseaseNameEn: 'Tur Sterility Mosaic Disease',
      diseaseNameMr: 'तुरीवरील वांझ रोग',
      reasonEn: 'Pigeonpea sterility mosaic virus transmitted by eriophyid mites.',
      reasonMr: 'कोळी किडीमार्फत विषाणू पसरतो; झाडाला फुले लागत नाहीत.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Broadcast BIO-F Phosphate at early vegetative stage.',
      dosageGuideMr: 'सुरुवातीच्या वाढीच्या टप्प्यात बायो-एफ फॉस्फेट वापरा.',
    ),
    'tur_phytophthora_blight': const CropTreatmentRule(
      cropName: 'Tur Dal',
      diseaseNameEn: 'Tur Phytophthora Blight',
      diseaseNameMr: 'तुरीवरील फायटोफ्थोरा करपा',
      reasonEn: 'Phytophthora drechsleri f. sp. cajani attacking stems after waterlogging.',
      reasonMr: 'पाणी साचल्यामुळे खोडावर तपकिरी ते काळे चट्टे पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Improve drainage and apply BIO-F Phosphate to stimulate secondary roots.',
      dosageGuideMr: 'पाण्याचा निचरा करा व मुळांच्या पुनर्वाढीसाठी बायो-एफ फॉस्फेट द्या.',
    ),
    'moong_yellow_mosaic': const CropTreatmentRule(
      cropName: 'Moong',
      diseaseNameEn: 'Moong Yellow Mosaic Virus',
      diseaseNameMr: 'मुगावरील पिवळा मोझॅक (केवडा)',
      reasonEn: 'Mungbean yellow mosaic virus spread by whitefly.',
      reasonMr: 'पांढऱ्या माशीमुळे पसरतो; पानांवर पिवळे आणि हिरवे चट्टे पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Basal dressing of BIO-F Phosphate (50 kg/acre) to build cellular vigor.',
      dosageGuideMr: 'झाडाची मजबुती वाढवण्यासाठी पेरणीच्या वेळी बायो-एफ फॉस्फेट द्या.',
    ),
    'moong_powdery_mildew': const CropTreatmentRule(
      cropName: 'Moong',
      diseaseNameEn: 'Moong Powdery Mildew',
      diseaseNameMr: 'मुगावरील भुरी रोग',
      reasonEn: 'Erysiphe polygoni blanketing leaves in white talc-like powdery fungal growth.',
      reasonMr: 'पानांवर पांढऱ्या पावडरसारखी बुरशी पसरते.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Soil application of BIO-F Phosphate (50 kg/acre) prior to flowering.',
      dosageGuideMr: 'फुलोऱ्यापूर्वी बायो-एफ फॉस्फेट मातीत मिसळा.',
    ),
    'moong_cercospora_leaf_spot': const CropTreatmentRule(
      cropName: 'Moong',
      diseaseNameEn: 'Moong Cercospora Leaf Spot',
      diseaseNameMr: 'मुगावरील टिक्या ठिपके',
      reasonEn: 'Cercospora canescens producing reddish-brown spots with grey centers.',
      reasonMr: 'पानांवर मध्यभागी करडे आणि कडेने लालसर-तपकिरी ठिपके तयार होतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate to boost phosphate assimilation and root nodules.',
      dosageGuideMr: 'गाठींच्या वाढीसाठी बायो-एफ फॉस्फेट (५० किलो/एकर) वापरा.',
    ),
    'urad_yellow_mosaic': const CropTreatmentRule(
      cropName: 'Urad Dal',
      diseaseNameEn: 'Urad Yellow Mosaic Virus',
      diseaseNameMr: 'उडदावरील पिवळा मोझॅक',
      reasonEn: 'Begomovirus causing bright yellow patches on leaves.',
      reasonMr: 'विषाणूजन्य रोग ज्यामुळे संपूर्ण पान पिवळे पडते.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Basal application of BIO-F Phosphate (50 kg/acre) at sowing.',
      dosageGuideMr: 'पेरणीच्या वेळी ५० किलो बायो-एफ फॉस्फेट प्रति एकर द्या.',
    ),
    'urad_leaf_crinkle': const CropTreatmentRule(
      cropName: 'Urad Dal',
      diseaseNameEn: 'Urad Leaf Crinkle Disease',
      diseaseNameMr: 'उडदावरील लीफ क्रिंकल (पाने आक्रसणे)',
      reasonEn: 'Urdbean leaf crinkle virus causing puckered foliage.',
      reasonMr: 'पाने जाड, आक्रसलेली आणि कुरळी होतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate to foster rapid early plant development.',
      dosageGuideMr: 'सुरुवातीच्या टप्प्यात बायो-एफ फॉस्फेट जमिनीत द्या.',
    ),
    'urad_anthracnose': const CropTreatmentRule(
      cropName: 'Urad Dal',
      diseaseNameEn: 'Urad Anthracnose',
      diseaseNameMr: 'उडदावरील करपा/अँथ्रॅकनोज',
      reasonEn: 'Colletotrichum lindemuthianum forming dark circular cankers.',
      reasonMr: 'शेंगांवर व पानांवर खोलगट काळे ठिपके पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate (50 kg/acre) before pod formation.',
      dosageGuideMr: 'शेंगा भरण्यापूर्वी बायो-एफ फॉस्फेट जमिनीत टाका.',
    ),

    // KHARIF OILSEEDS
    'soybean_rust': const CropTreatmentRule(
      cropName: 'Soybean',
      diseaseNameEn: 'Soybean Rust',
      diseaseNameMr: 'सोयाबीन तांबेरा रोग',
      reasonEn: 'Phakopsora pachyrhizi forming tan to dark brown lesions.',
      reasonMr: 'पानांच्या मागच्या बाजूला तपकिरी रंगाचे पुटकुळे येतात व पाने गळतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Soil application of BIO-F Phosphate (50 kg/acre) prior to flowering stage.',
      dosageGuideMr: 'फुलोऱ्यापूर्वी बायो-एफ फॉस्फेट (५० किलो/एकर) मातीत टाका.',
    ),
    'soybean_bacterial_blight': const CropTreatmentRule(
      cropName: 'Soybean',
      diseaseNameEn: 'Soybean Bacterial Blight',
      diseaseNameMr: 'सोयाबीन जिवाणू करपा',
      reasonEn: 'Pseudomonas savastanoi pv. glycinea causing water-soaked angular leaf spots.',
      reasonMr: 'पानांवर पिवळ्या कड असलेले लहान काळे डाग पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate at early vegetative stage.',
      dosageGuideMr: 'पेरणीनंतर २०-२५ दिवसांनी बायो-एफ फॉस्फेटचा वापर करा.',
    ),
    'soybean_frogeye_leaf_spot': const CropTreatmentRule(
      cropName: 'Soybean',
      diseaseNameEn: 'Soybean Frogeye Leaf Spot',
      diseaseNameMr: 'सोयाबीन फ्रॉग-आय ठिपके',
      reasonEn: 'Cercospora sojina causing circular eye-like lesions.',
      reasonMr: 'पानांवर बेडकाच्या डोळ्यासारखे मध्यभागी पांढरे ठिपके पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate (50 kg/acre) to restore soil mineral balance.',
      dosageGuideMr: 'मातीचे पोषण सुधारण्यासाठी बायो-एफ फॉस्फेट वापरा.',
    ),
    'groundnut_tikka_leaf_spot': const CropTreatmentRule(
      cropName: 'Groundnut',
      diseaseNameEn: 'Groundnut Tikka Leaf Spot',
      diseaseNameMr: 'भुईमुगावरील टिक्का रोग',
      reasonEn: 'Cercospora arachidicola causing dark brown spots.',
      reasonMr: 'पानांवर गर्द तपकिरी व काळे गोलाकार ठिपके पडतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Basal soil incorporation of BIO-F Phosphate (50 kg/acre) to enhance pegging.',
      dosageGuideMr: 'आऱ्या सुटण्याच्या वेळेस बायो-एफ फॉस्फेट (५० किलो/एकर) जमिनीत मिसळा.',
    ),
    'groundnut_rust': const CropTreatmentRule(
      cropName: 'Groundnut',
      diseaseNameEn: 'Groundnut Rust',
      diseaseNameMr: 'भुईमुगावरील तांबेरा रोग',
      reasonEn: 'Puccinia arachidis creating orange-red pustules on the lower leaf surface.',
      reasonMr: 'पानांच्या खालच्या बाजूला नारंगी-तपकिरी पुटकुळ्या तयार होतात.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Apply BIO-F Phosphate at 30-35 days after sowing.',
      dosageGuideMr: 'पेरणीनंतर ३०-३५ दिवसांनी बायो-एफ फॉस्फेट जमिनीत द्या.',
    ),
    'groundnut_collar_rot': const CropTreatmentRule(
      cropName: 'Groundnut',
      diseaseNameEn: 'Groundnut Collar Rot / Crown Rot',
      diseaseNameMr: 'भुईमुगावरील कॉलर रॉट (बुंधा कूज)',
      reasonEn: 'Aspergillus niger causing black fungal growth at collar region.',
      reasonMr: 'जमिनीलगतच्या खोडावर काळी बुरशी वाढते व रोपटे कोसळते.',
      recommendedProducts: ['BIO-F Phosphate'],
      productKeys: ['bio_f_phosphate'],
      dosageGuideEn: 'Seed line application of BIO-F Phosphate (50 kg/acre) at sowing.',
      dosageGuideMr: 'पेरणी करताना ओळीत बायो-एफ फॉस्फेट (५० किलो/एकर) टाका.',
    ),
  };

  // Getters for legacy diagnosis services
  static List<CropTreatmentRule> get treatments => _treatments.values.toList();
  static Map<String, CropTreatmentRule> get treatmentsMap => _treatments;

  static String normalizeKey(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  static CropTreatmentRule findTreatment(String rawQuery) {
    if (rawQuery.trim().isEmpty) return _defaultTreatment;
    final normalized = normalizeKey(rawQuery);

    if (_treatments.containsKey(normalized)) {
      return _treatments[normalized]!;
    }

    for (final entry in _treatments.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return entry.value;
      }
    }

    final lower = rawQuery.toLowerCase();
    for (final rule in _treatments.values) {
      if (lower.contains(rule.cropName.toLowerCase()) ||
          lower.contains(rule.diseaseNameEn.toLowerCase()) ||
          lower.contains(rule.diseaseNameMr.toLowerCase())) {
        return rule;
      }
    }

    return _defaultTreatment;
  }

  static const CropTreatmentRule _defaultTreatment = CropTreatmentRule(
    cropName: 'Unavailable',
    diseaseNameEn: 'Crop / Disease Data Unavailable',
    diseaseNameMr: 'पीक किंवा रोगाची माहिती उपलब्ध नाही',
    reasonEn: 'The scanned plant or entered condition is not currently covered in our 33 Kharif & Cash crop database. Please verify the crop or consult an agronomist.',
    reasonMr: 'स्कॅन केलेले पीक किंवा टाकलेला रोग सध्या आमच्या ३३ खरीप आणि बागायती पिकांच्या यादीत उपलब्ध नाही. कृपया पिकाची खात्री करा किंवा तज्ज्ञांशी संपर्क साधा.',
    recommendedProducts: [], // No products recommended when unrecognized
    productKeys: [],
    dosageGuideEn: 'No specific BIO-F dosage available for unrecognized crop conditions.',
    dosageGuideMr: 'अनोळखी पिकाच्या स्थितीसाठी विशिष्ट बायो-एफ डोस उपलब्ध नाही.',
  );
}