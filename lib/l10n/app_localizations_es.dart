// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get localization => 'Localización';

  @override
  String get lightTheme => 'Tema ligero';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get selectLanguage => 'Seleccione el idioma :';

  @override
  String get overridingTheLanguage =>
      'Anular el idioma en un lugar/widget específico';

  @override
  String get selectOverrideLanguage => 'Seleccionar idioma de anulación';

  @override
  String get simplifiedStrings =>
      'Simplificó las siguientes cadenas usando el paquete Intl:';

  @override
  String get passingDynamicValue => 'Pasar valor dinámico a una cadena';

  @override
  String get pluralOrSingular =>
      'Mostrando la plural o singular basada en el conc.t';

  @override
  String get selectMessageBasedOnString =>
      'Muestre el mensaje según la cadena pasada usando select';

  @override
  String get typeBasedOnCount => 'Mostrando el tipo según el recuento';

  @override
  String get escapeInterpolation => 'Escapar de la interpolación en una cadena';

  @override
  String get passingDynamicValueDes =>
      'Pasando Hola y Hermano como valor dinámico a una cadena localizada, a continuación se muestra el resultado';

  @override
  String get pluralOrSingularDes =>
      'Mostrando la pluralización de la palabra, aquí, según el recuento de pluralización, se mostrará personas/pueblos.';

  @override
  String get selectMessageBasedOnStringDes =>
      'De manera similar a Plural, podemos mostrar el mensaje según el valor pasado; a continuación, se mostrará según el género del sustantivo.';

  @override
  String get escapeInterpolationDes =>
      'De forma predeterminada, Dart considera la interpolación como un marcador de posición. En la siguiente cadena, la escapamos usando comillas simples.n';

  @override
  String get representingCurrencies =>
      'Representar las monedas con el símbolo de moneda según la ubicación';

  @override
  String get compact => 'Compacto :';

  @override
  String get compactCurrency => 'Moneda compacta:';

  @override
  String get compactSimpleCurrency => 'Moneda simple compacta:';

  @override
  String get compactLong => 'Compacta larga:';

  @override
  String get currency => 'Divisa :';

  @override
  String get decimalPercent => 'Porcentaje decimal:';

  @override
  String get description => 'Des:';

  @override
  String greetings(String firstName, String lastName) {
    return 'Hola $firstName $lastName';
  }

  @override
  String pluralMessage(num peoplesCount, Object count) {
    String _temp0 = intl.Intl.pluralLogic(
      peoplesCount,
      locale: localeName,
      other: '$count pueblos',
      two: '2 gente',
      one: '1 persona',
      zero: '0 gente',
    );
    return 'hay totales $_temp0 in den';
  }

  @override
  String pluralSampleOne(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estudiantes',
      many: 'Muchas personas',
      few: 'Pocas personas',
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
      other: '$countString pueblos',
      one: '1 personas',
      zero: '0 personas',
    );
    return '$_temp0';
  }

  @override
  String selectSample(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'he': 'Masculina',
        'she': 'Femenina',
        'other': 'Él/Ella no tiene información',
      },
    );
    return 'La persona es $_temp0';
  }

  @override
  String get escapingTheInterpolation => 'Hola, soy John Carter. {is n\'t}';

  @override
  String amountWithCompact(Object amount) {
    return 'Current Budget of application : $amount';
  }

  @override
  String amountWithCompactCurrency(Object amount) {
    return 'Presupuesto actual de aplicación : $amount';
  }

  @override
  String amountWithCompactSimpleCurrency(Object amount) {
    return 'Presupuesto actual de aplicación : $amount';
  }

  @override
  String amountWithCompactLong(Object amount) {
    return 'Presupuesto actual de aplicación : $amount';
  }

  @override
  String amountWithCurrency(Object amount) {
    return 'Presupuesto actual de aplicación : $amount';
  }

  @override
  String amountWithDecimalPercentPattern(Object amount) {
    return 'Presupuesto actual de aplicación : $amount';
  }

  @override
  String get dateFormat => 'Formato de fecha';

  @override
  String currentDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Fecha de hoy : $dateString';
  }

  @override
  String get sampleText1 =>
      'Lorem Ipsum es simplemente un texto de relleno de la industria de la impresión y la tipografía. Lorem Ipsum ha sido el texto de relleno estándar de la industria desde el siglo XVI, cuando un impresor desconocido tomó una galería de tipos y los mezcló para hacer un libro de muestra de tipos.';

  @override
  String get sampleText2 =>
      'Hay muchas variaciones de pasajes de Lorem Ipsum disponibles, pero la mayoría ha sufrido alguna alteración, mediante humor inyectado o palabras aleatorias que no parecen ni un poco creíbles. Si vas a utilizar un pasaje de Lorem Ipsum, debes asegurarte de que no haya nada vergonzoso escondido en medio del texto. Todos los generadores de Lorem Ipsum en Internet tienden a repetir fragmentos predefinidos según sea necesario.';

  @override
  String get sampleText3 =>
      'Utiliza un diccionario de más de 200 palabras latinas, combinado con un puñado de estructuras de oraciones modelo, para generar Lorem Ipsum, que parece razonable.';
}
