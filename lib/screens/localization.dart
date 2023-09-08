
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationDatePicker extends StatefulWidget {
  const LocalizationDatePicker({Key? key}) : super(key: key);

  @override
  State<LocalizationDatePicker> createState() => _LocalizationDatePickerState();
}

class _LocalizationDatePickerState extends State<LocalizationDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add the following code
            Expanded(child:
            Wrap(
              direction: Axis.vertical,
              spacing: 20,
              children: [
                Text(AppLocalizations.of(context)!.helloWorld('yedlapalli', 'krishnaji')),
                ///
                Text(AppLocalizations.of(context)!.countDetails(7)),

                Text(AppLocalizations.of(context)!.pluralSampleOne(3)),

                Text(AppLocalizations.of(context)!.selectSample('other')),

                Text(AppLocalizations.of(context)!.selectSampleOne('completed')),

                Text(AppLocalizations.of(context)!.escapingTheInterpolation),
              ],
            )
            ),
            Expanded(

              child: Localizations.override(
                context: context,
                locale: const Locale('es'),
                // Using a Builder to get the correct BuildContext.
                // Alternatively, you can create a new widget and Localizations.override
                // will pass the updated BuildContext to the new widget.
                child: Builder(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
