import 'package:flutter/material.dart';
import '../config/device_configurations.dart';
import '../enums/device_enums.dart';

/// Test widget to verify responsive design is working correctly
class ResponsiveTestWidget extends StatelessWidget {
  const ResponsiveTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Test'),
        backgroundColor: _getAppBarColor(),
      ),
      body: AdaptivePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildScalingDemo(),
            const SizedBox(height: 20),
            _buildGridDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: DeviceConfiguration.getResponsivePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: TextStyle(
                fontSize: DeviceConfiguration.getResponsiveFontSize(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
            _buildInfoRow('Resolution Type', DeviceConfiguration.resolutionType.toString()),
            _buildInfoRow('Screen Size', '${DeviceConfiguration.screenWidth.toInt()}x${DeviceConfiguration.screenHeight.toInt()}'),
            _buildInfoRow('Scale Factor', DeviceConfiguration.getResponsiveScaleFactor().toStringAsFixed(2)),
            _buildInfoRow('Grid Columns', DeviceConfiguration.getGridColumnCount().toString()),
            _buildInfoRow('Is Tablet Landscape', DeviceConfiguration.isTabletLandscape.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DeviceConfiguration.getResponsiveSpacing(4)),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: DeviceConfiguration.getResponsiveFontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: DeviceConfiguration.getResponsiveFontSize(14),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScalingDemo() {
    return Card(
      child: Padding(
        padding: DeviceConfiguration.getResponsivePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Scaling Demo',
              style: TextStyle(
                fontSize: DeviceConfiguration.getResponsiveFontSize(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
            Row(
              children: [
                Icon(
                  Icons.phone_android,
                  size: DeviceConfiguration.getResponsiveIconSize(24),
                ),
                SizedBox(width: DeviceConfiguration.getResponsiveSpacing(8)),
                Text(
                  'This text scales with device type',
                  style: TextStyle(
                    fontSize: DeviceConfiguration.getResponsiveFontSize(16),
                  ),
                ),
              ],
            ),
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: DeviceConfiguration.getResponsivePadding(base: 8),
                child: Text(
                  'Responsive Button',
                  style: TextStyle(
                    fontSize: DeviceConfiguration.getResponsiveFontSize(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridDemo() {
    int columnCount = DeviceConfiguration.getGridColumnCount();
    
    return Card(
      child: Padding(
        padding: DeviceConfiguration.getResponsivePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grid Layout Demo ($columnCount columns)',
              style: TextStyle(
                fontSize: DeviceConfiguration.getResponsiveFontSize(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
                crossAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8),
                mainAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8),
                childAspectRatio: 1.5,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Center(
                    child: Text(
                      'Item ${index + 1}',
                      style: TextStyle(
                        fontSize: DeviceConfiguration.getResponsiveFontSize(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getAppBarColor() {
    switch (DeviceConfiguration.resolutionType) {
      case DeviceResolutionType.mobilePortrait:
        return Colors.green;
      case DeviceResolutionType.mobileLandscape:
        return Colors.orange;
      case DeviceResolutionType.tabletPortrait:
        return Colors.blue;
      case DeviceResolutionType.tabletLandscape:
        return Colors.purple; // Your 7-inch landscape case
      case DeviceResolutionType.desktopStandard:
        return Colors.red;
      case DeviceResolutionType.desktopLarge:
        return Colors.teal;
    }
  }
}

/// Adaptive padding widget using the new system
class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final double basePadding;

  const AdaptivePadding({
    Key? key,
    required this.child,
    this.basePadding = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DeviceConfiguration.getResponsivePadding(base: basePadding),
      child: child,
    );
  }
}
