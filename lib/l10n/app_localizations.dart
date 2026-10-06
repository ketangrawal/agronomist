import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Agronomist'**
  String get appTitle;

  /// No description provided for @homeTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get homeTakePhoto;

  /// No description provided for @homeSpeak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get homeSpeak;

  /// No description provided for @homeType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get homeType;

  /// No description provided for @homeBestResults.
  ///
  /// In en, this message translates to:
  /// **'Best results when photo is clear and well-lit'**
  String get homeBestResults;

  /// No description provided for @tapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak'**
  String get tapToSpeak;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get listening;

  /// No description provided for @supportedLanguages.
  ///
  /// In en, this message translates to:
  /// **'Marathi & English supported'**
  String get supportedLanguages;

  /// No description provided for @analyzeCrop.
  ///
  /// In en, this message translates to:
  /// **'Analyze Crop'**
  String get analyzeCrop;

  /// No description provided for @orTypeBelow.
  ///
  /// In en, this message translates to:
  /// **'Or type below ↓'**
  String get orTypeBelow;

  /// No description provided for @describeProblem.
  ///
  /// In en, this message translates to:
  /// **'Describe your crop problem here…'**
  String get describeProblem;

  /// No description provided for @analysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your crop…'**
  String get analysisTitle;

  /// No description provided for @analysisSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our AI is checking for diseases.'**
  String get analysisSubtitle;

  /// No description provided for @stepScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning image…'**
  String get stepScanning;

  /// No description provided for @stepIdentifying.
  ///
  /// In en, this message translates to:
  /// **'Identifying disease…'**
  String get stepIdentifying;

  /// No description provided for @stepPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing recommendations…'**
  String get stepPreparing;

  /// No description provided for @diagnosisResults.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis Results'**
  String get diagnosisResults;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @rootCause.
  ///
  /// In en, this message translates to:
  /// **'Root Cause'**
  String get rootCause;

  /// No description provided for @rootCauseDescription.
  ///
  /// In en, this message translates to:
  /// **'Fungal infection caused by Erysiphe cichoracearum. Spreads in humid conditions with poor air circulation. Common during monsoon season when day temperatures are warm and nights are cool.'**
  String get rootCauseDescription;

  /// No description provided for @recommendedTreatment.
  ///
  /// In en, this message translates to:
  /// **'Recommended Treatment'**
  String get recommendedTreatment;

  /// No description provided for @checkAnotherCrop.
  ///
  /// In en, this message translates to:
  /// **'🌱 Check Another Crop'**
  String get checkAnotherCrop;

  /// No description provided for @diseaseNamePowderyMildewModerate.
  ///
  /// In en, this message translates to:
  /// **'Powdery Mildew (Moderate)'**
  String get diseaseNamePowderyMildewModerate;

  /// No description provided for @sulphurName.
  ///
  /// In en, this message translates to:
  /// **'Sulphur 80% WG'**
  String get sulphurName;

  /// No description provided for @sulphurType.
  ///
  /// In en, this message translates to:
  /// **'Fungicide'**
  String get sulphurType;

  /// No description provided for @sulphurPrice.
  ///
  /// In en, this message translates to:
  /// **'₹180 per kg'**
  String get sulphurPrice;

  /// No description provided for @sulphurDosage.
  ///
  /// In en, this message translates to:
  /// **'3g per liter of water'**
  String get sulphurDosage;

  /// No description provided for @hexaconazoleName.
  ///
  /// In en, this message translates to:
  /// **'Hexaconazole 5% EC'**
  String get hexaconazoleName;

  /// No description provided for @hexaconazoleType.
  ///
  /// In en, this message translates to:
  /// **'Systemic Fungicide'**
  String get hexaconazoleType;

  /// No description provided for @hexaconazolePrice.
  ///
  /// In en, this message translates to:
  /// **'₹320 per liter'**
  String get hexaconazolePrice;

  /// No description provided for @hexaconazoleDosage.
  ///
  /// In en, this message translates to:
  /// **'2ml per liter of water'**
  String get hexaconazoleDosage;

  /// No description provided for @neemName.
  ///
  /// In en, this message translates to:
  /// **'Neem Oil (Organic)'**
  String get neemName;

  /// No description provided for @neemType.
  ///
  /// In en, this message translates to:
  /// **'Bio-Pesticide'**
  String get neemType;

  /// No description provided for @neemPrice.
  ///
  /// In en, this message translates to:
  /// **'₹240 per liter'**
  String get neemPrice;

  /// No description provided for @neemDosage.
  ///
  /// In en, this message translates to:
  /// **'5ml per liter of water'**
  String get neemDosage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @savedProductCards.
  ///
  /// In en, this message translates to:
  /// **'Saved Product Cards'**
  String get savedProductCards;

  /// No description provided for @noCards.
  ///
  /// In en, this message translates to:
  /// **'No product cards saved yet.'**
  String get noCards;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved to Product Cards ✅'**
  String get saveSuccess;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted product card ❌'**
  String get deleteSuccess;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving product card'**
  String get saveError;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @productRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Product Recommendations'**
  String get productRecommendations;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to check your crop?'**
  String get homeTitle;

  /// No description provided for @takePhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Click a photo of your crop'**
  String get takePhotoSubtitle;

  /// No description provided for @speakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem in your words'**
  String get speakSubtitle;

  /// No description provided for @typeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write about your crop issue'**
  String get typeSubtitle;

  /// No description provided for @homeNote.
  ///
  /// In en, this message translates to:
  /// **'Best results: Take photos in daylight showing affected leaves or stems clearly.'**
  String get homeNote;

  /// No description provided for @cameraHint.
  ///
  /// In en, this message translates to:
  /// **'Point camera at affected leaves or stems'**
  String get cameraHint;

  /// No description provided for @photoReady.
  ///
  /// In en, this message translates to:
  /// **'Photo Ready'**
  String get photoReady;

  /// No description provided for @capturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Capture Photo'**
  String get capturePhoto;

  /// No description provided for @retakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakePhoto;

  /// No description provided for @usePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use This Photo'**
  String get usePhoto;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
