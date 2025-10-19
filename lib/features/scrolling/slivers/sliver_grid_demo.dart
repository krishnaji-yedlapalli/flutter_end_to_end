import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';

class SliverGridDemo extends StatelessWidget {
  const SliverGridDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('SliverGrid Demo'),
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
                            Icons.grid_view,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'SliverGrid',
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
                        'SliverGrid creates a scrollable grid of widgets. '
                        'It supports different grid delegates for various layout patterns.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Fixed Cross Axis Count
          _buildSectionHeader('SliverGridDelegateWithFixedCrossAxisCount'),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConfiguration.isMobileResolution ? 16 : 24,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: DeviceConfiguration.isMobileResolution ? 2 : 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.purple.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grid_4x4,
                            size: 30,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fixed ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${DeviceConfiguration.isMobileResolution ? 2 : 4} columns',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: 8,
              ),
            ),
          ),

          // Max Cross Axis Extent
          _buildSectionHeader('SliverGridDelegateWithMaxCrossAxisExtent'),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConfiguration.isMobileResolution ? 16 : 24,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent:
                    DeviceConfiguration.isMobileResolution ? 150 : 200,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final colors = [
                    Colors.green,
                    Colors.orange,
                    Colors.red,
                    Colors.teal,
                    Colors.pink,
                    Colors.indigo,
                  ];
                  final color = colors[index % colors.length];

                  return Card(
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: color.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(25),
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
                          const SizedBox(height: 8),
                          Text(
                            'Max Extent',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${DeviceConfiguration.isMobileResolution ? 150 : 200}px max',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: 12,
              ),
            ),
          ),

          // Staggered Grid Effect (using different aspect ratios)
          _buildSectionHeader('Variable Aspect Ratios'),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConfiguration.isMobileResolution ? 16 : 24,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: DeviceConfiguration.isMobileResolution ? 2 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final aspectRatios = [1.0, 1.5, 0.8, 1.2, 0.9];
                  final heights = [120.0, 180.0, 100.0, 150.0, 110.0];
                  final height = heights[index % heights.length];

                  return Card(
                    elevation: 4,
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.purple.withOpacity(0.3),
                            Colors.pink.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.photo,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Item ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Variable height: ${height.toInt()}px',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.grey[600],
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: 10,
              ),
            ),
          ),

          // Grid Delegate Comparison
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
                      Row(
                        children: [
                          Icon(
                            Icons.compare,
                            color: Colors.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Grid Delegate Comparison',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildComparisonTable(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Code examples
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
                          Text(
                            'Code Examples',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildCodeExample(
                        'Fixed Cross Axis Count',
                        'SliverGrid(\n'
                            '  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(\n'
                            '    crossAxisCount: 2,\n'
                            '    crossAxisSpacing: 10,\n'
                            '    mainAxisSpacing: 10,\n'
                            '    childAspectRatio: 1.0,\n'
                            '  ),\n'
                            '  delegate: SliverChildBuilderDelegate(...),\n'
                            ')',
                      ),
                      const SizedBox(height: 16),
                      _buildCodeExample(
                        'Max Cross Axis Extent',
                        'SliverGrid(\n'
                            '  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(\n'
                            '    maxCrossAxisExtent: 200,\n'
                            '    crossAxisSpacing: 10,\n'
                            '    mainAxisSpacing: 10,\n'
                            '    childAspectRatio: 0.8,\n'
                            '  ),\n'
                            '  delegate: SliverChildBuilderDelegate(...),\n'
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
        margin: EdgeInsets.fromLTRB(
          DeviceConfiguration.isMobileResolution ? 16 : 24,
          16,
          DeviceConfiguration.isMobileResolution ? 16 : 24,
          8,
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

  Widget _buildComparisonTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
          children: [
            _buildTableCell('Delegate Type', isHeader: true),
            _buildTableCell('Use Case', isHeader: true),
            _buildTableCell('Responsive', isHeader: true),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('FixedCrossAxisCount'),
            _buildTableCell('Fixed columns'),
            _buildTableCell('Manual'),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('MaxCrossAxisExtent'),
            _buildTableCell('Responsive width'),
            _buildTableCell('Automatic'),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
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
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
