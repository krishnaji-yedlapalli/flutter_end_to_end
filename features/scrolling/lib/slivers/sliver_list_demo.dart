import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';
import 'package:flutter/material.dart';

class SliverListDemo extends StatelessWidget {
  const SliverListDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('SliverList Demo'),
        appBar: AppBar(),
      ),
      body: CustomScrollView(
        slivers: [
          // Info header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.list,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'SliverList',
                            style: TextStyle(
                              fontSize: DeviceConfiguration.isMobileResolution
                                  ? 20
                                  : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'SliverList creates a scrollable list of widgets. '
                        'It\'s the sliver equivalent of ListView and is highly efficient for large lists.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // SliverList with SliverChildBuilderDelegate
          _buildSectionHeader('SliverChildBuilderDelegate'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal:
                        DeviceConfiguration.isMobileResolution ? 16 : 24,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Builder Item ${index + 1}'),
                    subtitle: const Text('Built on demand for efficiency'),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Builder item ${index + 1} tapped')),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: 10,
            ),
          ),

          // SliverList with SliverChildListDelegate
          _buildSectionHeader('SliverChildListDelegate'),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildListItem(
                  'Fixed Item 1', 'Pre-built widget', Colors.green, Icons.star),
              _buildListItem('Fixed Item 2', 'All widgets created upfront',
                  Colors.orange, Icons.favorite),
              _buildListItem('Fixed Item 3', 'Good for small lists',
                  Colors.purple, Icons.thumb_up),
              _buildListItem('Fixed Item 4', 'Less memory efficient',
                  Colors.red, Icons.warning),
              _buildListItem('Fixed Item 5', 'Simple to implement', Colors.teal,
                  Icons.check_circle),
            ]),
          ),

          // SliverPrototypeExtentList
          _buildSectionHeader('SliverPrototypeExtentList'),
          SliverPrototypeExtentList(
            prototypeItem: const ListTile(
              title: Text('Prototype'),
              subtitle: Text('All items same height'),
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal:
                        DeviceConfiguration.isMobileResolution ? 16 : 24,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Prototype Item ${index + 1}'),
                    subtitle: const Text('Same height as prototype item'),
                    trailing: const Icon(Icons.height),
                  ),
                );
              },
              childCount: 8,
            ),
          ),

          // Performance comparison section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
              child: Card(
                color: Colors.blue.withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.speed,
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Performance Comparison',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildComparisonRow('SliverChildBuilderDelegate',
                          'Lazy loading', 'High', Colors.green),
                      _buildComparisonRow('SliverChildListDelegate',
                          'Pre-built widgets', 'Medium', Colors.orange),
                      _buildComparisonRow('SliverPrototypeExtentList',
                          'Optimized heights', 'High', Colors.green),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Code examples section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.code,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Usage Examples',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildCodeExample(
                        'SliverChildBuilderDelegate',
                        'SliverList(\n'
                            '  delegate: SliverChildBuilderDelegate(\n'
                            '    (context, index) => ListTile(...),\n'
                            '    childCount: 100,\n'
                            '  ),\n'
                            ')',
                      ),
                      const SizedBox(height: 12),
                      _buildCodeExample(
                        'SliverChildListDelegate',
                        'SliverList(\n'
                            '  delegate: SliverChildListDelegate([\n'
                            '    ListTile(...),\n'
                            '    ListTile(...),\n'
                            '  ]),\n'
                            ')',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: DeviceConfiguration.isMobileResolution ? 16 : 24,
          vertical: 8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
      String title, String subtitle, Color color, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: DeviceConfiguration.isMobileResolution ? 16 : 24,
        vertical: 4,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: color,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
      String delegate, String description, String performance, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              delegate,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                performance,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Text(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
