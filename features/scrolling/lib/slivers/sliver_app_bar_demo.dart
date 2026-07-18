import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

class SliverAppBarDemo extends StatefulWidget {
  const SliverAppBarDemo({Key? key}) : super(key: key);

  @override
  State<SliverAppBarDemo> createState() => _SliverAppBarDemoState();
}

class _SliverAppBarDemoState extends State<SliverAppBarDemo>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Main SliverAppBar with all features
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            snap: false,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedOpacity(
                opacity: _isScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Text(
                  'SliverAppBar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurple,
                          Colors.purple,
                          Colors.pink,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SliverAppBar Demo',
                          style: TextStyle(
                            fontSize: DeviceConfiguration.isMobileResolution
                                ? 28
                                : 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Expandable • Collapsible • Stretchable',
                          style: TextStyle(
                            fontSize: DeviceConfiguration.isMobileResolution
                                ? 16
                                : 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stretch indicator
                  Positioned(
                    top: 60,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Pull to stretch',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showInfoDialog(),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),

          // Content explaining SliverAppBar features
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureCard(
                    'Expandable Height',
                    'The app bar can expand to show more content when scrolled to the top',
                    Icons.expand_less,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    'Pinned Behavior',
                    'The app bar stays visible at the top when scrolling down',
                    Icons.push_pin,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    'Stretch Effect',
                    'Pull down to stretch the app bar beyond its normal size',
                    Icons.open_in_full,
                    Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    'Flexible Space',
                    'Custom content that animates as the app bar expands/collapses',
                    Icons.space_bar,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),

          // Different SliverAppBar variations
          _buildVariationSection(
              'Floating SliverAppBar', _buildFloatingAppBar()),
          _buildVariationSection('Snap SliverAppBar', _buildSnapAppBar()),
          _buildVariationSection(
              'Non-Pinned SliverAppBar', _buildNonPinnedAppBar()),

          // Sample content to demonstrate scrolling
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal:
                        DeviceConfiguration.isMobileResolution ? 16 : 24,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Sample Content ${index + 1}'),
                    subtitle: const Text('Scroll to see SliverAppBar behavior'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
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
      ),
    );
  }

  Widget _buildVariationSection(String title, Widget appBar) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomScrollView(
                  slivers: [
                    appBar,
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ListTile(
                            title: Text('Item ${index + 1}'),
                            subtitle: const Text('Sample content'),
                          );
                        },
                        childCount: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingAppBar() {
    return const SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      backgroundColor: Colors.blue,
      title: Text('Floating AppBar'),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildSnapAppBar() {
    return const SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: Colors.green,
      title: Text('Snap AppBar'),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildNonPinnedAppBar() {
    return const SliverAppBar(
      floating: false,
      pinned: false,
      snap: false,
      expandedHeight: 120,
      backgroundColor: Colors.orange,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Non-Pinned AppBar'),
        centerTitle: true,
      ),
      automaticallyImplyLeading: false,
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SliverAppBar Properties'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• expandedHeight: Height when fully expanded'),
              Text('• floating: Shows when scrolling up'),
              Text('• pinned: Stays visible when scrolling down'),
              Text('• snap: Snaps to expanded/collapsed state'),
              Text('• stretch: Allows over-scroll stretching'),
              Text('• flexibleSpace: Custom expandable content'),
              Text('• backgroundColor: App bar background color'),
              Text('• elevation: Shadow depth'),
              Text('• actions: Action buttons in app bar'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
