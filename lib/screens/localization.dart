
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text('Localization'),
      ),
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Text('Select Language : ', style: Theme.of(context).textTheme.titleSmall?.apply(color: Colors.blue)),
              DropdownButton(
                  value:  context.read<CommonProvider>().selectedLocale,
                  items: AppLocalizations.supportedLocales.map((e) => DropdownMenuItem(value: e, child: Text(getLanguageBasedOnLocaleCode(e)))).toList(), onChanged: context.read<CommonProvider>().onChangeOfLanguage)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Simplified the below strings using Intl package : ', style: Theme.of(context).textTheme.bodyMedium?.apply(fontWeightDelta: 900, fontSizeDelta: 1, color: Colors.purpleAccent)),
          ),
          Expanded(child: _buildSimplifiedStrings()),
          Builder(
            builder: (context) {
              // A toy example for an internationalized Material widget.
              return CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                onDateChanged: (value) {},
              );
            },
          ),
        ],
      ).screenPadding(),
    );
  }


  Widget _buildSimplifiedStrings() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: Wrap(
          direction: Axis.vertical,
          spacing: 16,
          runSpacing: DeviceConfiguration.isMobileResolution ? 0 : 50,
          children: [
            buildLabelWithValue(
                'Passing dynamic value to a String',
                AppLocalizations.of(context)!.helloWorld('yedlapalli', 'krishnaji'),
              des: 'Here we are passing yedlapalli and krishnaji as dynamic value to localized string, below was the output'
            ),
            buildLabelWithValue(
             'Passing dynamic value to a String',
            AppLocalizations.of(context)!.helloWorld('yedlapalli', 'krishnaji')
            ),
            buildLabelWithValue(
                'Showing the type based on the count',
                AppLocalizations.of(context)!.countDetails(7)
            ),
        
            Text(AppLocalizations.of(context)!.pluralSampleOne(3)),
        
            Text(AppLocalizations.of(context)!.selectSample('other')),
        
            Text(AppLocalizations.of(context)!.selectSampleOne('completed')),
          ],
        ),
      ),
    );
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
}
