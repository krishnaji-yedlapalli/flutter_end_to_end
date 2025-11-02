import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/shared/non_responsive_widgets/non_responsive_widgets.dart';

class SingleChildScrollViewDemo extends StatelessWidget {
  const SingleChildScrollViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('SingleChildScrollView'),
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildVerticalScrollExample(),
            const SizedBox(height: 20),
            _buildHorizontalScrollExample(),
            const SizedBox(height: 20),
            _buildNestedScrollExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SingleChildScrollView',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A scrollable widget that can contain a single child widget. '
              'Useful when you have content that might overflow the screen.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalScrollExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vertical Scrolling Example',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    20,
                    (index) => Container(
                      height: 50,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text('Vertical Item ${index + 1}'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Horizontal Scrolling Example',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    15,
                    (index) => Container(
                      width: 120,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text('Item ${index + 1}'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNestedScrollExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nested Scrolling Example',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.orange.withOpacity(0.1),
                      child: const Center(
                        child: Text('Header Content'),
                      ),
                    ),
                    Container(
                      height: 150,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            10,
                            (index) => Container(
                              width: 100,
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text('${index + 1}'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      color: Colors.red.withOpacity(0.1),
                      child: const Center(
                        child: Text('Footer Content'),
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
}
