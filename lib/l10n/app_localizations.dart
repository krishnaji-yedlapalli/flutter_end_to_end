import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('he'),
    Locale('hi')
  ];

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language : '**
  String get selectLanguage;

  /// No description provided for @overridingTheLanguage.
  ///
  /// In en, this message translates to:
  /// **'Overriding the Language in a specific place/widget'**
  String get overridingTheLanguage;

  /// No description provided for @selectOverrideLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Override Language'**
  String get selectOverrideLanguage;

  /// No description provided for @simplifiedStrings.
  ///
  /// In en, this message translates to:
  /// **'Simplified the below strings using Intl package : '**
  String get simplifiedStrings;

  /// No description provided for @passingDynamicValue.
  ///
  /// In en, this message translates to:
  /// **'Passing dynamic value to a String'**
  String get passingDynamicValue;

  /// No description provided for @pluralOrSingular.
  ///
  /// In en, this message translates to:
  /// **'Showing the plural or singular based on the count'**
  String get pluralOrSingular;

  /// No description provided for @selectMessageBasedOnString.
  ///
  /// In en, this message translates to:
  /// **'Show the message based on the passed string using select'**
  String get selectMessageBasedOnString;

  /// No description provided for @typeBasedOnCount.
  ///
  /// In en, this message translates to:
  /// **'Showing the type based on the count'**
  String get typeBasedOnCount;

  /// No description provided for @escapeInterpolation.
  ///
  /// In en, this message translates to:
  /// **'Escaping the Interpolation in a string'**
  String get escapeInterpolation;

  /// No description provided for @passingDynamicValueDes.
  ///
  /// In en, this message translates to:
  /// **'Passing Hello and Brother as dynamic value to localized string, below was the output'**
  String get passingDynamicValueDes;

  /// No description provided for @pluralOrSingularDes.
  ///
  /// In en, this message translates to:
  /// **'Showing the pluralizing the word, here based on the count pluralize will be displayed people/peoples.. '**
  String get pluralOrSingularDes;

  /// No description provided for @selectMessageBasedOnStringDes.
  ///
  /// In en, this message translates to:
  /// **'Similar to Plural we can shown the message based on the passed value, below based on the noun gender will be shown'**
  String get selectMessageBasedOnStringDes;

  /// No description provided for @escapeInterpolationDes.
  ///
  /// In en, this message translates to:
  /// **'By default dart consider interpolation as a place holder, In below string we are escaping it using single quotation'**
  String get escapeInterpolationDes;

  /// No description provided for @representingCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Representing the Currencies with currency symbol based on the locale'**
  String get representingCurrencies;

  /// No description provided for @compact.
  ///
  /// In en, this message translates to:
  /// **'Compact :'**
  String get compact;

  /// No description provided for @compactCurrency.
  ///
  /// In en, this message translates to:
  /// **'Compact currency :'**
  String get compactCurrency;

  /// No description provided for @compactSimpleCurrency.
  ///
  /// In en, this message translates to:
  /// **'Compact Simple currency :'**
  String get compactSimpleCurrency;

  /// No description provided for @compactLong.
  ///
  /// In en, this message translates to:
  /// **'Compact Long :'**
  String get compactLong;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency :'**
  String get currency;

  /// No description provided for @decimalPercent.
  ///
  /// In en, this message translates to:
  /// **'Decimal Percent :'**
  String get decimalPercent;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Des :'**
  String get description;

  /// Greetings to the user
  ///
  /// In en, this message translates to:
  /// **'Hello {firstName} {lastName}'**
  String greetings(String firstName, String lastName);

  /// Showing the peoples based on the count
  ///
  /// In en, this message translates to:
  /// **'There are total {peoplesCount, plural, =0{0 people} =1{1 person} =2{2 people} other{{count} peoples}} in den'**
  String pluralMessage(num peoplesCount, Object count);

  /// No description provided for @pluralSampleOne.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{ramesh} =1{raza} =2{krishna} few{few persons} many{many persons} other{{count} students}}'**
  String pluralSampleOne(num count);

  /// No description provided for @countDetails.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 persons} =1{1 persons} other{{count} peoples}}'**
  String countDetails(num count);

  /// Shows the personal nouns based on the input
  ///
  /// In en, this message translates to:
  /// **'Person is{gender, select, he{Male} she{Female} other{He/She not info}}'**
  String selectSample(String gender);

  /// No description provided for @escapingTheInterpolation.
  ///
  /// In en, this message translates to:
  /// **'Hello this is John carter \'{is n\'\'t}\''**
  String get escapingTheInterpolation;

  /// No description provided for @amountWithCompact.
  ///
  /// In en, this message translates to:
  /// **'Current Budget of application : {amount}'**
  String amountWithCompact(Object amount);

  /// No description provided for @amountWithCompactCurrency.
  ///
  /// In en, this message translates to:
  /// **'Current Budget of application : {amount}'**
  String amountWithCompactCurrency(Object amount);

  /// No description provided for @amountWithCompactSimpleCurrency.
  ///
  /// In en, this message translates to:
  /// **'Current Budget of application : {amount}'**
  String amountWithCompactSimpleCurrency(Object amount);

  /// No description provided for @amountWithCompactLong.
  ///
  /// In en, this message translates to:
  /// **'Current Budget of application : {amount}'**
  String amountWithCompactLong(Object amount);

  /// No description provided for @amountWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'Current Budget of application : {amount}'**
  String amountWithCurrency(Object amount);

  /// No description provided for @amountWithDecimalPercentPattern.
  ///
  /// In en, this message translates to:
  /// **'Current Budget of application : {amount}'**
  String amountWithDecimalPercentPattern(Object amount);

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// Showing current date by formatting
  ///
  /// In en, this message translates to:
  /// **'Today Date : {date}'**
  String currentDate(DateTime date);

  /// No description provided for @sampleText1.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the \'{industry\'\'s}\' standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'**
  String get sampleText1;

  /// No description provided for @sampleText2.
  ///
  /// In en, this message translates to:
  /// **'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary'**
  String get sampleText2;

  /// No description provided for @sampleText3.
  ///
  /// In en, this message translates to:
  /// **'It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable'**
  String get sampleText3;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'he', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
