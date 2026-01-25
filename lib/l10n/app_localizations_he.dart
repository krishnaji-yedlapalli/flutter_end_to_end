// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get localization => 'לוקליזציה';

  @override
  String get lightTheme => 'נושא קליל';

  @override
  String get darkTheme => 'ערכת נושא כהה';

  @override
  String get selectLanguage => 'בחר שפה :';

  @override
  String get overridingTheLanguage => 'עקיפה של השפה במקום/יישומון ספציפי';

  @override
  String get selectOverrideLanguage => 'בחר ביטול שפה';

  @override
  String get simplifiedStrings => 'פשט את המיתרים באמצעות החבילה';

  @override
  String get passingDynamicValue => 'העברת ערך דינמי למחרוזת';

  @override
  String get pluralOrSingular => 'הצגת רבים או יחיד על סמך הספירה';

  @override
  String get selectMessageBasedOnString =>
      'הצג את ההודעה על סמך המחרוזת שעברה באמצעות select';

  @override
  String get typeBasedOnCount => 'מציג את הסוג על סמך הספירה';

  @override
  String get escapeInterpolation => 'בריחה מהאינטרפולציה במחרוזת';

  @override
  String get passingDynamicValueDes =>
      'העברת Hello and Brother כערך דינמי למחרוזת מקומית, למטה הייתה הפלט';

  @override
  String get pluralOrSingularDes =>
      'מראה בריבוי המילה, כאן בהתבסס על הספירה ריבוי יוצגו אנשים/אנשים..';

  @override
  String get selectMessageBasedOnStringDes =>
      'בדומה לרבים אנו יכולים להציג את ההודעה על סמך הערך שעבר, להלן על סמך שם העצם מגדר יוצג';

  @override
  String get escapeInterpolationDes =>
      'כברירת מחדל, יש לשקול את האינטרפולציה כמחזיק מקום, במחרוזת למטה אנו בורחים ממנה באמצעות ציטוט בודד';

  @override
  String get representingCurrencies =>
      'ייצוג המטבעות עם סמל המטבע על סמך המקום';

  @override
  String get compact => 'קומפקטי:';

  @override
  String get compactCurrency => 'מטבע קומפקטי:';

  @override
  String get compactSimpleCurrency => 'מטבע קומפקטי פשוט:';

  @override
  String get compactLong => 'קומפקטי ארוך:';

  @override
  String get currency => 'מטבע:';

  @override
  String get decimalPercent => 'אחוז עשרוני:';

  @override
  String get description => 'של ה ';

  @override
  String greetings(String firstName, String lastName) {
    return 'שלום $firstName $lastName';
  }

  @override
  String pluralMessage(num peoplesCount, Object count) {
    String _temp0 = intl.Intl.pluralLogic(
      peoplesCount,
      locale: localeName,
      other: '$count עמים',
      two: '2 אֲנָשִׁים',
      one: '1 אדם',
      zero: '0 אֲנָשִׁים',
    );
    return 'יש סך הכל $_temp0 במאורה';
  }

  @override
  String pluralSampleOne(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students',
      many: 'many persons',
      few: 'few persons',
      two: 'sampleNameThree',
      one: 'sampleNameTwo',
      zero: 'sampleNameOne',
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
        'he': 'זָכָר',
        'she': 'נְקֵבָה',
        'other': 'הוא/היא אין מידע',
      },
    );
    return 'אדם הוא $_temp0';
  }

  @override
  String get escapingTheInterpolation => 'שלום זה גון קרטר {is n\'t}';

  @override
  String amountWithCompact(Object amount) {
    return 'תקציב יישום נוכחי: $amount';
  }

  @override
  String amountWithCompactCurrency(Object amount) {
    return 'תקציב יישום נוכחי: $amount';
  }

  @override
  String amountWithCompactSimpleCurrency(Object amount) {
    return 'תקציב יישום נוכחי: $amount';
  }

  @override
  String amountWithCompactLong(Object amount) {
    return 'תקציב יישום נוכחי: $amount';
  }

  @override
  String amountWithCurrency(Object amount) {
    return 'תקציב יישום נוכחי: $amount';
  }

  @override
  String amountWithDecimalPercentPattern(Object amount) {
    return 'תקציב יישום נוכחי: $amount';
  }

  @override
  String get dateFormat => 'פורמט תאריך';

  @override
  String currentDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'תאריך היום : $dateString';
  }

  @override
  String get sampleText1 =>
      'Lorem Ipsum הוא פשוט טקסט דמה של תעשיית הדפוס והקביעה. Lorem Ipsum היה טקסט הדמה הסטנדרטי של התעשייה מאז שנות ה-1500, כאשר מדפסת לא ידועה לקחה גלריה של סוג וערבכה אותה כדי ליצור ספר דגימות סוג.';

  @override
  String get sampleText2 =>
      'הוא פשוט טקסט גולמי של תעשיית ההדפסה וההקלדה. Lorem Ipsum היה טקסט סטנדרטי עוד במאה ה-16, כאשר הדפסה לא ידועה לקחה מגש של דפוס ועירבלה אותו כדי ליצור סוג של ספר דגימה. ספר זה שרד לא רק חמש מאות שנים אלא גם את הקפיצה לתוך ההדפסה האלקטרונית, ונותר כמו שהוא ביסודו. ספר זה הפך פופולרי יותר בשנות ה-60 ';

  @override
  String get sampleText3 =>
      ' וחלקים מתוך הספרות הלטינית הקלאסית מאז 45 לפני הספירה. מה שהופך אותו לעתיק מעל 2000 שנה. ריצרד מקלינטוק, פרופסור לטיני בקול של המפדן-סידני בורגיניה, חיפש את אחת המילים המעורפלות ביותר בלטינית - consectetur - מתוך פסקאות של Lorem Ipsum ודרך ציטוטים של המילה מתוך הספרות הקלאסית, הוא גילה מקור בלתי ניתן לערעור.';
}
