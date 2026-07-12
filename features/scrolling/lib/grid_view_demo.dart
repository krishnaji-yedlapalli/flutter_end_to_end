import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';

class GridViewDemo extends StatelessWidget {
  const GridViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('GridView Examples'),
          appBar: AppBar(),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Fixed Count'),
              Tab(text: 'Max Extent'),
              Tab(text: 'GridView.builder'),
              Tab(text: 'Staggered Grid'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FixedCountGrid(),
            _MaxExtentGrid(),
            _GridViewBuilder(),
            _StaggeredGrid(),
          ],
        ),
      ),
    );
  }
}

class _FixedCountGrid extends StatelessWidget {
  const _FixedCountGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'GridView with Fixed Cross Axis Count',
            'Creates a grid with a fixed number of columns.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: DeviceConfiguration.isMobileResolution ? 2 : 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                20,
                (index) => Card(
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.withOpacity(0.3),
                          Colors.purple.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.grid_view,
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Item ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Grid Cell',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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

class _MaxExtentGrid extends StatelessWidget {
  const _MaxExtentGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'GridView with Max Cross Axis Extent',
            'Creates a grid where each cell has a maximum width.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent:
                  DeviceConfiguration.isMobileResolution ? 150 : 200,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                25,
                (index) => Card(
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
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
                          'Product ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${(index + 1) * 10}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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

class _GridViewBuilder extends StatelessWidget {
  const _GridViewBuilder();

  final List<Color> colors = const [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
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
            'GridView.builder',
            'Efficiently builds grid items on demand for large datasets.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: DeviceConfiguration.isMobileResolution ? 2 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: 50,
              itemBuilder: (context, index) {
                final color = colors[index % colors.length];
                return Card(
                  elevation: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: color.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Photo ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gallery Item',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.favorite_border, size: 20, color: color),
                            Icon(Icons.share, size: 20, color: color),
                            Icon(Icons.download, size: 20, color: color),
                          ],
                        ),
                      ],
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

class _StaggeredGrid extends StatelessWidget {
  const _StaggeredGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Staggered Grid Layout',
            'A custom grid layout with varying item heights.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.custom(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: DeviceConfiguration.isMobileResolution ? 2 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  final heights = [120.0, 180.0, 150.0, 200.0, 130.0];
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
                            Colors.orange.withOpacity(0.3),
                            Colors.red.withOpacity(0.3),
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
                                const Icon(
                                  Icons.article,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Card ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This is a staggered grid item with varying height. Item ${index + 1} has different content length.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text('Tag ${index + 1}'),
                                  backgroundColor:
                                      Colors.orange.withOpacity(0.2),
                                ),
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: 20,
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
