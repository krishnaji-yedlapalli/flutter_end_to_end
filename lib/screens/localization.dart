import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/provider/common_provider.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class LocalizationDatePicker extends StatefulWidget {
  const LocalizationDatePicker({Key? key}) : super(key: key);

  @override
  State<LocalizationDatePicker> createState() => _LocalizationDatePickerState();
}

class _LocalizationDatePickerState extends State<LocalizationDatePicker>
    with HelperWidget {
  Locale? locale;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: Text(AppLocalizations.of(context)!.localization),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                children: [
                  Text('${AppLocalizations.of(context)!.selectLanguage}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.apply(color: Colors.blue)),
                  DropdownButton<Locale>(
                      value: context.read<CommonProvider>().locale,
                      items: AppLocalizations.supportedLocales
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(getLanguageBasedOnLocaleCode(e))))
                          .toList(),
                      onChanged:
                          context.read<CommonProvider>().onChangeOfLanguage)
                ],
              ),
              buildLabel(AppLocalizations.of(context)!.simplifiedStrings),
              _buildSimplifiedStrings(),
              _buildMaterialOrCupertinoComponents(),
              Divider(),
              _buildLanguageOverride()
            ],
          ).screenPadding(),
        ),
      ),
    );
  }

  Widget _buildMaterialOrCupertinoComponents() {
    return Row(
      children: [
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            width: DeviceConfiguration.isMobileResolution
                ? null
                : constraints.maxWidth / 2,
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              onDateChanged: (value) {},
            ),
          );
        })),
        Expanded(
            child: TimePickerDialog(
          initialTime: TimeOfDay.now(),
        ))
      ],
    );
  }

  Widget _buildLanguageOverride() {
    return Localizations.override(
      locale: context.watch<CommonProvider>().overrideLocale,
      context: context,
      child: Builder(builder: (context) {
        return Column(children: [
          buildLabel(
              '${AppLocalizations.of(context)!.overridingTheLanguage} :'),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Text('${AppLocalizations.of(context)!.selectOverrideLanguage} :',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.apply(color: Colors.blue)),
              DropdownButton(
                  value: context.read<CommonProvider>().overrideLocale,
                  items: AppLocalizations.supportedLocales
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(getLanguageBasedOnLocaleCode(e))))
                      .toList(),
                  onChanged:
                      context.read<CommonProvider>().onChangeOfOverrideLanguage)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(AppLocalizations.of(context)!.sampleText1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(AppLocalizations.of(context)!.sampleText2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(AppLocalizations.of(context)!.sampleText3),
          ),
        ]);
      }),
    );
  }

  Widget _buildSimplifiedStrings() {
    var size = MediaQuery.of(context).size;
    var list = getLocalizationData();
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => list.elementAt(index),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
          itemCount: list.length);
    });
  }

  List<Widget> getLocalizationData() {
    const amount = 800000;
    return [
      buildLabelWithValue(AppLocalizations.of(context)!.passingDynamicValue,
          AppLocalizations.of(context)!.greetings('John', "Carter"),
          des: AppLocalizations.of(context)!.passingDynamicValueDes),
      buildLabelWithValue(AppLocalizations.of(context)!.pluralOrSingular,
          AppLocalizations.of(context)!.countDetails(7),
          des: AppLocalizations.of(context)!.pluralOrSingularDes),
      buildLabelWithValue(
          AppLocalizations.of(context)!.selectMessageBasedOnString,
          AppLocalizations.of(context)!.selectSample('he'),
          des: AppLocalizations.of(context)!.selectMessageBasedOnStringDes),
      buildLabelWithValue(AppLocalizations.of(context)!.typeBasedOnCount,
          AppLocalizations.of(context)!.countDetails(7)),
      buildLabelWithValue(AppLocalizations.of(context)!.escapeInterpolation,
          AppLocalizations.of(context)!.escapingTheInterpolation,
          des: AppLocalizations.of(context)!.escapeInterpolationDes),
      buildLabelWithValue(
          AppLocalizations.of(context)!.representingCurrencies,
          '${AppLocalizations.of(context)!.compact} ${AppLocalizations.of(context)!.amountWithCompact(amount)} \n\n'
          '${AppLocalizations.of(context)!.compactCurrency} ${AppLocalizations.of(context)!.amountWithCompactCurrency(amount)} \n\n'
          '${AppLocalizations.of(context)!.compactSimpleCurrency} ${AppLocalizations.of(context)!.amountWithCompactSimpleCurrency(amount)} \n'
          '${AppLocalizations.of(context)!.compactLong} ${AppLocalizations.of(context)!.amountWithCompactLong(amount)} \n'
          '${AppLocalizations.of(context)!.currency} ${AppLocalizations.of(context)!.amountWithCurrency(amount)} \n'
          '${AppLocalizations.of(context)!.decimalPercent} ${AppLocalizations.of(context)!.amountWithDecimalPercentPattern(amount)}',
          des: ''),
      buildLabelWithValue(AppLocalizations.of(context)!.dateFormat,
          AppLocalizations.of(context)!.currentDate(DateTime.now()),
          des:
              'By default dart consider interpolation as a place holder, In below string we are escaping it using single quotation'),
      Text(AppLocalizations.of(context)!.pluralSampleOne(3)),

      Text(AppLocalizations.of(context)!.selectSample('other')),
    ];
  }

  String getLanguageBasedOnLocaleCode(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'hi':
        return 'Hindi';
      default:
        return locale.languageCode;
    }
  }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label,
          style: Theme.of(context).textTheme.bodyMedium?.apply(
              fontWeightDelta: 900,
              fontSizeDelta: 1,
              color: Colors.purpleAccent)),
    );
  }
}
