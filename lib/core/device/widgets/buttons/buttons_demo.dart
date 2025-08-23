import 'package:flutter/material.dart';
import 'buttons.dart';
import '../../config/device_configurations.dart';

/// Demo page showcasing all adaptive responsive button variants
class ButtonsDemo extends StatelessWidget {
  const ButtonsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adaptive Responsive Buttons',
          style: TextStyle(
            fontSize: DeviceConfiguration.getResponsiveFontSize(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: DeviceConfiguration.getResponsivePadding(base: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Device Info'),
            _buildDeviceInfoCard(),
            
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
            
            _buildSectionTitle('Standard Buttons'),
            _buildStandardButtons(),
            
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
            
            _buildSectionTitle('Button Variants'),
            _buildButtonVariants(),
            
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
            
            _buildSectionTitle('Icon Buttons'),
            _buildIconButtons(),
            
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
            
            _buildSectionTitle('Outline Buttons'),
            _buildOutlineButtons(),
            
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(100)), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: const AdaptiveResponsiveFAB(
        icon: Icons.add,
        tooltip: 'Add Item',
        isExtended: true,
        label: 'Add',
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: DeviceConfiguration.getResponsiveSpacing(12),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: DeviceConfiguration.getResponsiveFontSize(18),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
    return Card(
      child: Padding(
        padding: DeviceConfiguration.getResponsivePadding(base: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Resolution Type', DeviceConfiguration.resolutionType.toString()),
            _buildInfoRow('Screen Size', '${DeviceConfiguration.screenWidth.toInt()}x${DeviceConfiguration.screenHeight.toInt()}'),
            _buildInfoRow('Scale Factor', DeviceConfiguration.getResponsiveScaleFactor().toStringAsFixed(2)),
            _buildInfoRow('Platform Design', DeviceConfiguration.useCupertinoDesign ? 'Cupertino' : 'Material'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: DeviceConfiguration.getResponsiveSpacing(4),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: DeviceConfiguration.getResponsiveFontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: DeviceConfiguration.getResponsiveFontSize(14),
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AdaptiveResponsiveButton(
                text: 'Primary Button',
                onPressed: () {},
                isPrimary: true,
              ),
            ),
            SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
            Expanded(
              child: AdaptiveResponsiveButton(
                text: 'Secondary',
                onPressed: () {},
                isPrimary: false,
              ),
            ),
          ],
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        AdaptiveResponsiveButton(
          text: 'Full Width Button',
          onPressed: () {},
          isFullWidth: true,
          icon: Icons.check,
        ),
      ],
    );
  }

  Widget _buildButtonVariants() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AdaptiveResponsiveCompactButton(
                text: 'Compact',
                onPressed: () {},
                icon: Icons.compress,
              ),
            ),
            SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
            Expanded(
              child: AdaptiveResponsiveButton(
                text: 'Normal',
                onPressed: () {},
                icon: Icons.star,
              ),
            ),
          ],
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        AdaptiveResponsiveLargeButton(
          text: 'Large Button',
          onPressed: () {},
          icon: Icons.rocket_launch,
        ),
      ],
    );
  }

  Widget _buildIconButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AdaptiveResponsiveIconButton(
          icon: Icons.favorite,
          onPressed: () {},
          tooltip: 'Like',
        ),
        AdaptiveResponsiveIconButton(
          icon: Icons.share,
          onPressed: () {},
          tooltip: 'Share',
          isPrimary: true,
        ),
        AdaptiveResponsiveIconButton(
          icon: Icons.bookmark,
          onPressed: () {},
          tooltip: 'Bookmark',
        ),
        AdaptiveResponsiveIconButton(
          icon: Icons.more_vert,
          onPressed: () {},
          tooltip: 'More Options',
        ),
      ],
    );
  }

  Widget _buildOutlineButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AdaptiveResponsiveOutlineButton(
                text: 'Outline',
                onPressed: () {},
              ),
            ),
            SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
            Expanded(
              child: AdaptiveResponsiveOutlineButton(
                text: 'With Icon',
                onPressed: () {},
                icon: Icons.download,
              ),
            ),
          ],
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        AdaptiveResponsiveOutlineButton(
          text: 'Full Width Outline Button',
          onPressed: () {},
          isFullWidth: true,
          icon: Icons.cloud_download,
          borderColor: Colors.green,
        ),
      ],
    );
  }
}
