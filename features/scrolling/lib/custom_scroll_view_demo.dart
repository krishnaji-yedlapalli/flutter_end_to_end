import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomScrollViewDemo extends StatelessWidget {
  const CustomScrollViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sliverDemos = [
      SliverDemoItem(
        title: 'SliverAppBar',
        description: 'Expandable, collapsible app bar with flexible space',
        icon: Icons.expand_less,
        color: Colors.purple,
        routePath: 'sliverAppBar',
      ),
      SliverDemoItem(
        title: 'SliverList',
        description: 'Scrollable list with different delegate types',
        icon: Icons.list,
        color: Colors.blue,
        routePath: 'sliverList',
      ),
      SliverDemoItem(
        title: 'SliverGrid',
        description: 'Grid layouts with various configurations',
        icon: Icons.grid_view,
        color: Colors.green,
        routePath: 'sliverGrid',
      ),
      SliverDemoItem(
        title: 'SliverFillViewport',
        description: 'Each child fills the entire viewport',
        icon: Icons.fullscreen,
        color: Colors.orange,
        routePath: 'sliverFillViewport',
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('CustomScrollView & Slivers'),
        appBar: AppBar(),
      ),
      body: CustomScrollView(
        slivers: [
          // Header with info
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.view_stream,
                            color: Theme.of(context).primaryColor,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'CustomScrollView Mastery',
                              style: TextStyle(
                                fontSize: DeviceConfiguration.isMobileResolution
                                    ? 24
                                    : 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CustomScrollView is Flutter\'s most powerful scrolling widget. '
                        'It combines multiple scrollable widgets (slivers) into a single, '
                        'unified scrolling experience.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildInfoChip('Slivers', Icons.layers),
                          _buildInfoChip('Performance', Icons.speed),
                          _buildInfoChip('Flexible', Icons.tune),
                          _buildInfoChip('Responsive', Icons.devices),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sliver demos grid
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConfiguration.isMobileResolution ? 16 : 24,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: DeviceConfiguration.isMobileResolution ? 1 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                    DeviceConfiguration.isMobileResolution ? 2.5 : 1.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final demo = sliverDemos[index];
                  return _buildSliverDemoCard(context, demo);
                },
                childCount: sliverDemos.length,
              ),
            ),
          ),

          // What are Slivers section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
              child: Card(
                color: Colors.blue.withOpacity(0.05),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Colors.blue,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'What are Slivers?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Slivers are scrollable areas that can be combined in a CustomScrollView. '
                        'They provide fine-grained control over scrolling behavior and enable '
                        'complex layouts that wouldn\'t be possible with regular scrolling widgets.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Benefits section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DeviceConfiguration.isMobileResolution ? 16 : 24,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Benefits of CustomScrollView',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildBenefitItem(
                        'Performance',
                        'Efficient rendering with lazy loading',
                        Icons.speed,
                        Colors.green,
                      ),
                      _buildBenefitItem(
                        'Flexibility',
                        'Mix different scrollable widgets',
                        Icons.tune,
                        Colors.blue,
                      ),
                      _buildBenefitItem(
                        'Animations',
                        'Smooth scroll-based animations',
                        Icons.animation,
                        Colors.purple,
                      ),
                      _buildBenefitItem(
                        'Responsiveness',
                        'Adapts to different screen sizes',
                        Icons.devices,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16 : 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.1),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 40,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pro Tip',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap on each sliver demo above to explore detailed examples '
                    'and learn how to implement them in your own apps!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverDemoCard(BuildContext context, SliverDemoItem demo) {
    return Card(
      elevation: 6,
      child: InkWell(
        onTap: () {
          context.go('/home/scrollTypes/customScrollView/${demo.routePath}');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                demo.color.withOpacity(0.1),
                demo.color.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: demo.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        demo.icon,
                        color: demo.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        demo.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  demo.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: demo.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        color: demo.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: Colors.blue.withOpacity(0.1),
      labelStyle: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildBenefitItem(
      String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SliverDemoItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String routePath;

  SliverDemoItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.routePath,
  });
}
