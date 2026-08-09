import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';
import 'package:flutter/material.dart';

class ListViewDemo extends StatelessWidget {
  const ListViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('ListView Examples'),
          appBar: AppBar(),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic ListView'),
              Tab(text: 'ListView.builder'),
              Tab(text: 'ListView.separated'),
              Tab(text: 'ListView.custom'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BasicListView(),
            _ListViewBuilder(),
            _ListViewSeparated(),
            _ListViewCustom(),
          ],
        ),
      ),
    );
  }
}

class _BasicListView extends StatelessWidget {
  const _BasicListView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Basic ListView',
            'Creates a scrollable list of widgets. All children are built at once.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: List.generate(
                20,
                (index) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Basic ListView Item ${index + 1}'),
                    subtitle: Text('This is item number ${index + 1}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped item ${index + 1}')),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _ListViewBuilder extends StatelessWidget {
  const _ListViewBuilder();

  final List<String> items = const [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Kiwi',
    'Lemon',
    'Mango',
    'Nectarine',
    'Orange',
    'Papaya',
    'Quince',
    'Raspberry',
    'Strawberry',
    'Tangerine',
    'Ugli fruit',
    'Vanilla bean'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'ListView.builder',
            'Efficiently builds list items on demand. Perfect for large lists.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.local_grocery_store,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(items[index]),
                    subtitle: Text('Fruit #${index + 1}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Added ${items[index]} to favorites')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _ListViewSeparated extends StatelessWidget {
  const _ListViewSeparated();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'ListView.separated',
            'Builds list items with separators between them.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: 15,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withOpacity(0.3),
                          Colors.blue.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.purple,
                    ),
                  ),
                  title: Text('Contact ${index + 1}'),
                  subtitle: Text('contact${index + 1}@example.com'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _ListViewCustom extends StatelessWidget {
  const _ListViewCustom();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'ListView.custom',
            'Uses a custom SliverChildDelegate for advanced list building.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.custom(
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index % 5 == 0) {
                    return Container(
                      height: 60,
                      color: Colors.orange.withOpacity(0.1),
                      child: Center(
                        child: Text(
                          'Section ${(index ~/ 5) + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    );
                  }
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      title: Text('Custom Item ${index + 1}'),
                      subtitle: const Text('Built with ListView.custom'),
                      trailing: Chip(
                        label: Text('${index + 1}'),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  );
                },
                childCount: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
