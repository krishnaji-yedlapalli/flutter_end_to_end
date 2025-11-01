import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/mixins/cards_mixin.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/shared/widgets/widgets.dart';

class ScrollTypes extends StatelessWidget with CardWidgetsMixin {
  const ScrollTypes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollTypes = [
      ScrollTypeItem(
        name: 'SingleChildScrollView',
        description:
            'Basic scrolling for single child widgets with overflow handling',
        icon: Icons.view_stream,
        routePath: 'singleChildScrollView',
      ),
      ScrollTypeItem(
        name: 'ListView',
        description:
            'Scrollable list of widgets with builder, separated, and custom types',
        icon: Icons.list,
        routePath: 'listView',
      ),
      ScrollTypeItem(
        name: 'GridView',
        description:
            'Scrollable grid layout with fixed count, extent, and staggered options',
        icon: Icons.grid_view,
        routePath: 'gridView',
      ),
      ScrollTypeItem(
        name: 'CustomScrollView',
        description:
            'Advanced scrolling with slivers, headers, and custom layouts',
        icon: Icons.view_stream,
        routePath: 'customScrollView',
      ),
      ScrollTypeItem(
        name: 'NestedScrollView',
        description:
            'Nested scrolling with collapsible headers and tab integration',
        icon: Icons.layers,
        routePath: 'nestedScrollView',
      ),
      ScrollTypeItem(
        name: 'PageView',
        description:
            'Horizontal page-by-page scrolling with smooth transitions',
        icon: Icons.swipe,
        routePath: 'pageView',
      ),
      ScrollTypeItem(
        name: 'ListWheelScrollView',
        description: 'Wheel-style scrolling picker interface for selections',
        icon: Icons.roller_shades,
        routePath: 'listWheelScrollView',
      ),
      ScrollTypeItem(
        name: 'DraggableScrollableSheet',
        description:
            'Bottom sheet with draggable scrolling and gesture support',
        icon: Icons.drag_handle,
        routePath: 'draggableScrollableSheet',
      ),
      ScrollTypeItem(
        name: 'AnimatedList',
        description:
            'List with smooth animations for insertions, removals, and updates',
        icon: Icons.animation,
        routePath: 'animatedList',
      ),
      ScrollTypeItem(
        name: 'Scrollbar',
        description:
            'Custom scrollbars with styling, interactivity, and visual feedback',
        icon: Icons.linear_scale,
        routePath: 'scrollbar',
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Flutter Scroll Types'),
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            SizedBox(height: DeviceConfiguration.isMobileResolution ? 16 : 20),
            _buildScrollTypesList(context, scrollTypes),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_list,
                  color: Theme.of(context).primaryColor,
                  size: DeviceConfiguration.isMobileResolution ? 24 : 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Flutter Scrolling Widgets',
                    style: TextStyle(
                      fontSize:
                          DeviceConfiguration.isMobileResolution ? 18 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Explore comprehensive examples of Flutter\'s scrolling widgets. '
              'Each demo showcases responsive design, cross-platform compatibility, '
              'and best practices for different scrolling scenarios.',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 14 : 16,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: const Text('Responsive'),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  labelStyle: TextStyle(
                    fontSize: DeviceConfiguration.isMobileResolution ? 12 : 14,
                  ),
                ),
                Chip(
                  label: const Text('Cross-Platform'),
                  backgroundColor: Colors.green.withOpacity(0.1),
                  labelStyle: TextStyle(
                    fontSize: DeviceConfiguration.isMobileResolution ? 12 : 14,
                  ),
                ),
                Chip(
                  label: const Text('Interactive'),
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  labelStyle: TextStyle(
                    fontSize: DeviceConfiguration.isMobileResolution ? 12 : 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollTypesList(
      BuildContext context, List<ScrollTypeItem> scrollTypes) {
    if (DeviceConfiguration.isMobileResolution) {
      // Mobile: Use ListView for better scrolling experience
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: scrollTypes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildScrollTypeCard(context, scrollTypes[index],
              isMobile: true);
        },
      );
    } else {
      // Desktop/Tablet: Use GridView
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemCount: scrollTypes.length,
        itemBuilder: (context, index) {
          return _buildScrollTypeCard(context, scrollTypes[index],
              isMobile: false);
        },
      );
    }
  }

  Widget _buildScrollTypeCard(BuildContext context, ScrollTypeItem scrollType,
      {required bool isMobile}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToDemo(context, scrollType),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
          child: isMobile
              ? _buildMobileCardContent(context, scrollType)
              : _buildDesktopCardContent(context, scrollType),
        ),
      ),
    );
  }

  Widget _buildMobileCardContent(
      BuildContext context, ScrollTypeItem scrollType) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            scrollType.icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                scrollType.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                scrollType.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildDesktopCardContent(
      BuildContext context, ScrollTypeItem scrollType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                scrollType.icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                scrollType.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Text(
            scrollType.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _navigateToDemo(BuildContext context, ScrollTypeItem scrollType) {
    context.go('/home/scrollTypes/${scrollType.routePath}');
  }
}

class ScrollTypeItem {
  final String name;
  final String description;
  final IconData icon;
  final String routePath;

  ScrollTypeItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.routePath,
  });
}
