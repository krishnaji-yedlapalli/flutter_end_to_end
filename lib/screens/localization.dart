
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

class _LocalizationDatePickerState extends State<LocalizationDatePicker> with HelperWidget {

  Locale? locale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Text(AppLocalizations.of(context)!.localization),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                Text('Select Language : ', style: Theme.of(context).textTheme.titleSmall?.apply(color: Colors.blue)),
                DropdownButton<Locale>(
                    value:  context.read<CommonProvider>().locale,
                    items: AppLocalizations.supportedLocales.map((e) => DropdownMenuItem(value: e, child: Text(getLanguageBasedOnLocaleCode(e)))).toList(), onChanged: context.read<CommonProvider>().onChangeOfLanguage)
              ],
            ),
            buildLabel('Simplified the below strings using Intl package : '),
            _buildSimplifiedStrings(),
            Divider(),
            _buildLanguageOverride()
          ],
        ).screenPadding(),
      ),
    );
  }

  Widget _buildLanguageOverride() {
    return Column(
      children: [
        buildLabel('Overriding the Language in a specific place/widget : '),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text('Select Override Language : ', style: Theme.of(context).textTheme.titleSmall?.apply(color: Colors.blue)),
            DropdownButton(
                value:  context.read<CommonProvider>().locale,
                items: AppLocalizations.supportedLocales.map((e) => DropdownMenuItem(value: e, child: Text(getLanguageBasedOnLocaleCode(e)))).toList(), onChanged: context.read<CommonProvider>().onChangeOfLanguage)
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(AppLocalizations.of(context)!.sampleText),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: DeviceConfiguration.isMobileResolution ? null : constraints.maxWidth/2,
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                onDateChanged: (value) {},
              ),
            );
          }
        ),
      ]
    );
  }


  Widget _buildSimplifiedStrings() {
    var size = MediaQuery.of(context).size;
    var list = getLocalizationData();
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => list.elementAt(index), separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ), itemCount: list.length);
      }
    );
  }

  List<Widget> getLocalizationData() {
    const amount = 800000;
    return  [
      buildLabelWithValue(
          'Passing dynamic value to a String',
          AppLocalizations.of(context)!.greetings('John', "Carter"),
          des: 'Passing Hello and Brother as dynamic value to localized string, below was the output'
      ),
      buildLabelWithValue(
          'Showing the plural or singular based on the count',
          AppLocalizations.of(context)!.countDetails(7),
          des: 'Showing the pluralizing the word, here based on the count pluralize will be displayed people/peoples.. '
      ),
      buildLabelWithValue(
          'Show the message based on the passed string using select',
          AppLocalizations.of(context)!.selectSample('he'),
          des: "Similar to Plural we can shown the message based on the passed value, below based on the noun gender will be shown"
      ),
      buildLabelWithValue(
          'Showing the type based on the count',
          AppLocalizations.of(context)!.countDetails(7)
      ),
      buildLabelWithValue(
          'Escaping the Interpolation in a string',
          AppLocalizations.of(context)!.escapingTheInterpolation,
          des: 'By default dart consider interpolation as a place holder, In below string we are escaping it using single quotation'
      ),
      buildLabelWithValue(
          'Representing the Currencies with currency symbol based on the locale',
          'Compact : ${AppLocalizations.of(context)!.amountWithCompact(amount)} \n\n'
              'Compact currency : ${AppLocalizations.of(context)!.amountWithCompactCurrency(amount)} \n\n'
              'Compact Simple currency : ${AppLocalizations.of(context)!.amountWithCompactSimpleCurrency(amount)} \n'
              'Compact Long : ${AppLocalizations.of(context)!.amountWithCompactLong(amount)} \n'
              'Currency : ${AppLocalizations.of(context)!.amountWithCurrency(amount)} \n'
              'Decimal Percent : ${AppLocalizations.of(context)!.amountWithDecimalPercentPattern(amount)}',
          des: ''
      ),
      buildLabelWithValue(
          'Escaping the Intepolation',
          AppLocalizations.of(context)!.escapingTheInterpolation,
          des: 'By default dart consider interpolation as a place holder, In below string we are escaping it using single quotation'
      ),
      buildLabelWithValue(
          'Date Format',
          AppLocalizations.of(context)!.currentDate(DateTime.now()),
          des: 'By default dart consider interpolation as a place holder, In below string we are escaping it using single quotation'
      ),
      // Text(AppLocalizations.of(context)!.pluralSampleOne(3)),
      //
      // Text(AppLocalizations.of(context)!.selectSample('other')),
    ];
  }

  String getLanguageBasedOnLocaleCode(Locale locale) {
    switch(locale.languageCode) {
      case 'en' :
        return 'English';
      case 'es' :
        return 'Spanish';
      case 'hi' :
        return 'Hindi';
      default :
        return locale.languageCode;
    }
  }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.apply(fontWeightDelta: 900, fontSizeDelta: 1, color: Colors.purpleAccent)),
    );
  }
}
