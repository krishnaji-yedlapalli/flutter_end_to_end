import 'package:flutter/material.dart';

class CardsLayout extends StatefulWidget {
  const CardsLayout({Key? key}) : super(key: key);

  @override
  State<CardsLayout> createState() => _CardsLayoutState();
}

class _CardsLayoutState extends State<CardsLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _cardsLayout()),
        Expanded(child: _cardsWithGridViewBuilderLayout())
      ],
    );
  }

  Widget _cardsLayout() {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: 5,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemBuilder: (_, index) => Card(
          child: GridTile(
              header : Title(color: Colors.red, child: Text('Friday'), ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Fun Day'),
          ),
            footer: Text('End of the Week'),
          ),
        )
    );
  }

  Widget _cardsWithGridViewBuilderLayout() {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: 5,
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 250),
        itemBuilder: (_, index) => Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Friday', style: Theme.of(context).textTheme.headlineSmall),
                Text('Fun Day, Chill with the People', style: Theme.of(context).textTheme.bodyMedium),
                Icon(Icons.access_alarm),
                Text('End of the week !!', style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        )
    );
  }
}
