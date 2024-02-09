import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_latest/extensions/widget_extension.dart';

class SelectableTextSample extends StatefulWidget {
  const SelectableTextSample({Key? key}) : super(key: key);

  @override
  State<SelectableTextSample> createState() => _SelectableTextSampleState();
}

class _SelectableTextSampleState extends State<SelectableTextSample> {

  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
            children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Title(color: Colors.green, child: Text('Selectable Text Widget', style: Theme.of(context).textTheme.titleMedium)),
      ),
      SelectableText("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
      Divider(),
      SelectableText("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
       cursorColor: Colors.blue,
        magnifierConfiguration: TextMagnifierConfiguration(
          shouldDisplayHandlesInMagnifier: true
        ),
        // selectionControls: ,
        onSelectionChanged: (val, selection){
        if(val.isCollapsed){
          if (kIsWeb) {
            BrowserContextMenu.enableContextMenu();
          }
        }else{
          if (kIsWeb) {
            BrowserContextMenu.disableContextMenu();
          }
        }
        },
        enableInteractiveSelection: true,
        contextMenuBuilder: (context, editableTextState) {
           return AdaptiveTextSelectionToolbar(
             anchors: editableTextState.contextMenuAnchors,
             children: editableTextState.contextMenuButtonItems
                 .map((ContextMenuButtonItem buttonItem) {
               return CupertinoButton(
                 borderRadius: null,
                 color: const Color(0xffaaaa00),
                 disabledColor: const Color(0xffaaaaff),
                 onPressed: buttonItem.onPressed,
                 padding: const EdgeInsets.all(10.0),
                 pressedOpacity: 0.7,
                 child: SizedBox(
                   width: 200.0,
                   child: Text(
                     CupertinoTextSelectionToolbarButton.getButtonLabel(
                         context, buttonItem),
                   ),
                 ),
               );
             }).toList(),
           );
        },
      ),
      Divider(),
      _buildSelectableArea(),
      Divider(),
      _buildSelectableRegion()
       ],
          ).screenPadding(),
    );
  }

  Widget _buildSelectableArea() {
    return SelectionArea(
      onSelectionChanged: (selection){
      if(selection != null && selection.plainText.trim().isNotEmpty){
        if (kIsWeb) {
          BrowserContextMenu.enableContextMenu();
        }
      }else if(selection != null){
        if (kIsWeb) {
          BrowserContextMenu.disableContextMenu();
        }
      }
    },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Title(color: Colors.green, child: Text('Selectable Area Widget', style: Theme.of(context).textTheme.titleMedium)),
          ),
          Text('Below is sample text, we selectable area widget we can select all the text'),
          Text("There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable."),
         Divider(),
          FlutterLogo(size: 100,),
          Divider(),
          Text('The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.')
        ],
      ),
    );
  }

  Widget _buildSelectableRegion() {
    return SelectableRegion(
      focusNode: focusNode,
      selectionControls: materialTextSelectionControls,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Title(color: Colors.green, child: Text('Selectable Region Widget', style: Theme.of(context).textTheme.titleMedium)),
          ),
          Text('Below is sample text, we selectable area widget we can select all the text'),
          Text("There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable."),
          Divider(),
          FlutterLogo(size: 100,),
          Divider(),
          Text('The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.')
        ],
      ),
    );
  }
}
