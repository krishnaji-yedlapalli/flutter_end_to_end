// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localization => 'Localization';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get selectLanguage => 'Select Language : ';

  @override
  String get overridingTheLanguage =>
      'Overriding the Language in a specific place/widget';

  @override
  String get selectOverrideLanguage => 'Select Override Language';

  @override
  String get simplifiedStrings =>
      'Simplified the below strings using Intl package : ';

  @override
  String get passingDynamicValue => 'Passing dynamic value to a String';

  @override
  String get pluralOrSingular =>
      'Showing the plural or singular based on the count';

  @override
  String get selectMessageBasedOnString =>
      'Show the message based on the passed string using select';

  @override
  String get typeBasedOnCount => 'Showing the type based on the count';

  @override
  String get escapeInterpolation => 'Escaping the Interpolation in a string';

  @override
  String get passingDynamicValueDes =>
      'Passing Hello and Brother as dynamic value to localized string, below was the output';

  @override
  String get pluralOrSingularDes =>
      'Showing the pluralizing the word, here based on the count pluralize will be displayed people/peoples.. ';

  @override
  String get selectMessageBasedOnStringDes =>
      'Similar to Plural we can shown the message based on the passed value, below based on the noun gender will be shown';

  @override
  String get escapeInterpolationDes =>
      'By default dart consider interpolation as a place holder, In below string we are escaping it using single quotation';

  @override
  String get representingCurrencies =>
      'Representing the Currencies with currency symbol based on the locale';

  @override
  String get compact => 'Compact :';

  @override
  String get compactCurrency => 'Compact currency :';

  @override
  String get compactSimpleCurrency => 'Compact Simple currency :';

  @override
  String get compactLong => 'Compact Long :';

  @override
  String get currency => 'Currency :';

  @override
  String get decimalPercent => 'Decimal Percent :';

  @override
  String get description => 'Des :';

  @override
  String greetings(String firstName, String lastName) {
    return 'Hello $firstName $lastName';
  }

  @override
  String pluralMessage(num peoplesCount, Object count) {
    String _temp0 = intl.Intl.pluralLogic(
      peoplesCount,
      locale: localeName,
      other: '$count peoples',
      two: '2 people',
      one: '1 person',
      zero: '0 people',
    );
    return 'There are total $_temp0 in den';
  }

  @override
  String pluralSampleOne(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students',
      many: 'many persons',
      few: 'few persons',
      two: 'krishna',
      one: 'raza',
      zero: 'ramesh',
    );
    return '$_temp0';
  }

  @override
  String countDetails(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString peoples',
      one: '1 persons',
      zero: '0 persons',
    );
    return '$_temp0';
  }

  @override
  String selectSample(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'he': 'Male',
        'she': 'Female',
        'other': 'He/She not info',
      },
    );
    return 'Person is$_temp0';
  }

  @override
  String get escapingTheInterpolation => 'Hello this is John carter {is n\'t}';

  @override
  String amountWithCompact(Object amount) {
    return 'Current Budget of application : $amount';
  }

  @override
  String amountWithCompactCurrency(Object amount) {
    return 'Current Budget of application : $amount';
  }

  @override
  String amountWithCompactSimpleCurrency(Object amount) {
    return 'Current Budget of application : $amount';
  }

  @override
  String amountWithCompactLong(Object amount) {
    return 'Current Budget of application : $amount';
  }

  @override
  String amountWithCurrency(Object amount) {
    return 'Current Budget of application : $amount';
  }

  @override
  String amountWithDecimalPercentPattern(Object amount) {
    return 'Current Budget of application : $amount';
  }

  @override
  String get dateFormat => 'Date Format';

  @override
  String currentDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Today Date : $dateString';
  }

  @override
  String get sampleText1 =>
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the {industry\'s} standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.';

  @override
  String get sampleText2 =>
      'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which dont look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isnt anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary';

  @override
  String get sampleText3 =>
      'It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable';
}
