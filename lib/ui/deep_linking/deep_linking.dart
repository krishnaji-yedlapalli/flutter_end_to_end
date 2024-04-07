import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/validators.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';
import 'package:sample_latest/widgets/text_field.dart';

class DeepLinkingTesting extends StatelessWidget with Validators {
  DeepLinkingTesting({Key? key}) : super(key: key);

  final urlCtrl = TextEditingController(text: '');

  static const String baseUrl = 'https://flutter-end-to-end.web.app/home/';

  final textListener = ValueNotifier<String>(baseUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: const Text('Deep Linking Testing'),
        ),
        body: Wrap(
          runSpacing: 20,
          children: [
            const Text(
              'Install the application and paste the copied URL into the browser/notes/messages app on the same device.\nUpon tapping the URL, it will automatically open the application instead of the device browser',
              textAlign: TextAlign.center,
            ),
            CustomTextField(controller: urlCtrl, label: 'Enter path', prefix: '/home/', suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () => urlCtrl.clear()), onChange: (val) => textListener.value = baseUrl + (val ?? '').trim(), maxLines: 2),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder(
                  builder: (context, value, child) {
                    return Text(value);
                  },
                  valueListenable: textListener,
                ),
                IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: textListener.value.trim()));
                      var snack = const SnackBar(content: Text('Path Copied'));
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    },
                    icon: const Icon(Icons.copy))
              ],
            )
          ],
        ).screenPadding());
  }
}
