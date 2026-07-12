import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/shared/widgets/responsive_widgets/widgets.dart';

import '../widgets/showcase_section_card.dart';

/// Section demonstrating responsive layout patterns and examples
class LayoutExamplesSection extends StatelessWidget {
  const LayoutExamplesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowcaseSectionCard(
      title: 'Responsive Layout Examples',
      subtitle: 'Layout patterns that adapt to different screen sizes',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGridLayouts(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildCardLayouts(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildListLayouts(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildResponsiveSpacing(),
        ],
      ),
    );
  }

  /// Build responsive grid layout examples
  Widget _buildGridLayouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Responsive Grids'),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
        Container(
          padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(
              DeviceConfiguration.getResponsiveSpacing(8.0),
            ),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                'Grid adapts: ${DeviceConfiguration.getGridColumnCount()} columns on current device',
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: DeviceConfiguration.getGridColumnCount(),
                  crossAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8),
                  mainAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8),
                  childAspectRatio: 1.2,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.1),
                          Colors.purple.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        DeviceConfiguration.getResponsiveSpacing(6.0),
                      ),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.apps,
                            size: DeviceConfiguration.getResponsiveIconSize(24),
                            color: Colors.blue[600],
                          ),
                          SizedBox(
                              height:
                                  DeviceConfiguration.getResponsiveSpacing(4)),
                          ResponsiveSmallText(
                            'Item ${index + 1}',
                            fontWeight: FontWeight.w500,
                            centerText: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Responsive Grid', '''
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: DeviceConfiguration.getGridColumnCount(),
    crossAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8),
    mainAxisSpacing: DeviceConfiguration.getResponsiveSpacing(8),
  ),
  // ... rest of grid configuration
),'''),
      ],
    );
  }

  /// Build responsive card layout examples
  Widget _buildCardLayouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Responsive Cards'),

        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),

        // Determine layout based on screen size
        if (DeviceConfiguration.isDesktopResolution ||
            DeviceConfiguration.isTabletLandscape)
          _buildHorizontalCards()
        else
          _buildVerticalCards(),

        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),

        _buildCodeExample('Responsive Cards', '''
// Layout adapts based on screen size
if (DeviceConfiguration.isDesktopResolution) {
  return _buildHorizontalCards();
} else {
  return _buildVerticalCards();
}'''),
      ],
    );
  }

  /// Build horizontal card layout for larger screens
  Widget _buildHorizontalCards() {
    return Row(
      children: [
        Expanded(child: _buildSampleCard('Card 1', Icons.star)),
        SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
        Expanded(child: _buildSampleCard('Card 2', Icons.favorite)),
        SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
        Expanded(child: _buildSampleCard('Card 3', Icons.thumb_up)),
      ],
    );
  }

  /// Build vertical card layout for smaller screens
  Widget _buildVerticalCards() {
    return Column(
      children: [
        _buildSampleCard('Card 1', Icons.star),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildSampleCard('Card 2', Icons.favorite),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildSampleCard('Card 3', Icons.thumb_up),
      ],
    );
  }

  /// Build sample card widget
  Widget _buildSampleCard(String title, IconData icon) {
    return Container(
      padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(8.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: DeviceConfiguration.getResponsiveIconSize(24),
                color: Colors.blue[600],
              ),
              SizedBox(width: DeviceConfiguration.getResponsiveSpacing(8)),
              ResponsiveTitle(title),
            ],
          ),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
          const ResponsiveText(
            'This card adapts its layout based on the available screen space and device type.',
          ),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
          AdaptiveResponsiveCompactButton(
            text: 'Action',
            onPressed: () {},
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  /// Build responsive list layout examples
  Widget _buildListLayouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Responsive Lists'),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
        Container(
          padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(
              DeviceConfiguration.getResponsiveSpacing(8.0),
            ),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            children: List.generate(3, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < 2
                      ? DeviceConfiguration.getResponsiveSpacing(12)
                      : 0,
                ),
                child: _buildListItem('List Item ${index + 1}', Icons.list),
              );
            }),
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Responsive Lists', '''
ListView.separated(
  padding: DeviceConfiguration.getResponsivePadding(base: 16),
  separatorBuilder: (context, index) => SizedBox(
    height: DeviceConfiguration.getResponsiveSpacing(8),
  ),
  itemBuilder: (context, index) => _buildListItem(index),
),'''),
      ],
    );
  }

  /// Build list item widget
  Widget _buildListItem(String title, IconData icon) {
    return Container(
      padding: DeviceConfiguration.getResponsivePadding(base: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(6.0),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: DeviceConfiguration.getResponsiveIconSize(20),
            color: Colors.blue[600],
          ),
          SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  title,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: DeviceConfiguration.getResponsiveSpacing(4)),
                ResponsiveSmallText(
                  'Responsive list item with adaptive spacing',
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          AdaptiveResponsiveIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /// Build responsive spacing examples
  Widget _buildResponsiveSpacing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Responsive Spacing'),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
        Container(
          padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(
              DeviceConfiguration.getResponsiveSpacing(8.0),
            ),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ResponsiveText(
                'Spacing adapts to screen size:',
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
              _buildSpacingExample('Small spacing', 8.0),
              _buildSpacingExample('Medium spacing', 16.0),
              _buildSpacingExample('Large spacing', 24.0),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
              ResponsiveSmallText(
                'Current scale factor: ${DeviceConfiguration.getResponsiveScaleFactor().toStringAsFixed(2)}',
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Responsive Spacing', '''
// Spacing automatically scales with device type
SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
EdgeInsets.all(DeviceConfiguration.getResponsiveSpacing(12)),
padding: DeviceConfiguration.getResponsivePadding(base: 16),'''),
      ],
    );
  }

  /// Build spacing example widget
  Widget _buildSpacingExample(String label, double baseSpacing) {
    final actualSpacing = DeviceConfiguration.getResponsiveSpacing(baseSpacing);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: DeviceConfiguration.getResponsiveSpacing(4),
      ),
      child: Row(
        children: [
          Container(
            width: actualSpacing,
            height: DeviceConfiguration.getResponsiveSpacing(4),
            decoration: BoxDecoration(
              color: Colors.green[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
          ResponsiveSmallText(
            '$label: ${actualSpacing.toStringAsFixed(1)}px',
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  /// Build code example widget
  Widget _buildCodeExample(String title, String code) {
    return Container(
      padding: DeviceConfiguration.getResponsivePadding(base: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(6.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveSmallText(
            title,
            color: Colors.green[300],
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
          ResponsiveSmallText(
            code,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
