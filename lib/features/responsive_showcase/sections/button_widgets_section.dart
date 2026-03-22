import 'package:flutter/material.dart';
import 'package:sample_latest/shared/widgets/responsive_widgets/widgets.dart';

import '../../../core/device/config/device_configurations.dart';
import '../widgets/showcase_section_card.dart';

/// Section showcasing all responsive button widgets with interactive examples
class ButtonWidgetsSection extends StatelessWidget {
  const ButtonWidgetsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowcaseSectionCard(
      title: 'Responsive Button Widgets',
      subtitle: 'Interactive buttons that adapt to platform and screen size',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStandardButtons(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildButtonVariants(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildIconButtons(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildSpecialButtons(),
        ],
      ),
    );
  }

  /// Build standard button examples
  Widget _buildStandardButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Standard Buttons'),
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
            children: [
              // Primary and Secondary buttons row
              _buildButtonRow([
                Expanded(
                  child: AdaptiveResponsiveButton(
                    text: 'Primary',
                    onPressed: () => _showButtonPressed('Primary Button'),
                    isPrimary: true,
                  ),
                ),
                SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
                Expanded(
                  child: AdaptiveResponsiveButton(
                    text: 'Secondary',
                    onPressed: () => _showButtonPressed('Secondary Button'),
                    isPrimary: false,
                  ),
                ),
              ]),

              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),

              // Full width button
              AdaptiveResponsiveButton(
                text: 'Full Width Button',
                onPressed: () => _showButtonPressed('Full Width Button'),
                isFullWidth: true,
                icon: Icons.check_circle,
              ),

              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),

              // Button with icon
              AdaptiveResponsiveButton(
                text: 'With Icon',
                onPressed: () => _showButtonPressed('Icon Button'),
                icon: Icons.star,
                isPrimary: true,
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Standard Buttons', '''
AdaptiveResponsiveButton(
  text: 'Primary',
  onPressed: () {},
  isPrimary: true,
),
AdaptiveResponsiveButton(
  text: 'With Icon',
  icon: Icons.star,
  isFullWidth: true,
),'''),
      ],
    );
  }

  /// Build button variants examples
  Widget _buildButtonVariants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Button Size Variants'),
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
            children: [
              // Compact and Normal buttons row
              _buildButtonRow([
                Expanded(
                  child: AdaptiveResponsiveCompactButton(
                    text: 'Compact',
                    onPressed: () => _showButtonPressed('Compact Button'),
                    icon: Icons.compress,
                  ),
                ),
                SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
                Expanded(
                  child: AdaptiveResponsiveButton(
                    text: 'Normal',
                    onPressed: () => _showButtonPressed('Normal Button'),
                    icon: Icons.star,
                  ),
                ),
              ]),

              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),

              // Large button
              AdaptiveResponsiveLargeButton(
                text: 'Large Button',
                onPressed: () => _showButtonPressed('Large Button'),
                icon: Icons.rocket_launch,
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Button Variants', '''
AdaptiveResponsiveCompactButton(
  text: 'Compact',
  icon: Icons.compress,
),
AdaptiveResponsiveLargeButton(
  text: 'Large Button',
  icon: Icons.rocket_launch,
),'''),
      ],
    );
  }

  /// Build icon buttons examples
  Widget _buildIconButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Icon Buttons'),
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
            children: [
              // Icon buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AdaptiveResponsiveIconButton(
                    icon: Icons.favorite,
                    onPressed: () => _showButtonPressed('Favorite'),
                    tooltip: 'Like',
                  ),
                  AdaptiveResponsiveIconButton(
                    icon: Icons.share,
                    onPressed: () => _showButtonPressed('Share'),
                    tooltip: 'Share',
                    isPrimary: true,
                  ),
                  AdaptiveResponsiveIconButton(
                    icon: Icons.bookmark,
                    onPressed: () => _showButtonPressed('Bookmark'),
                    tooltip: 'Bookmark',
                  ),
                  AdaptiveResponsiveIconButton(
                    icon: Icons.more_vert,
                    onPressed: () => _showButtonPressed('More'),
                    tooltip: 'More Options',
                  ),
                ],
              ),

              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),

              // FAB examples
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AdaptiveResponsiveFAB(
                    icon: Icons.add,
                    onPressed: () => _showButtonPressed('Add FAB'),
                    tooltip: 'Add Item',
                  ),
                  AdaptiveResponsiveFAB(
                    icon: Icons.edit,
                    onPressed: () => _showButtonPressed('Extended FAB'),
                    tooltip: 'Edit Item',
                    isExtended: true,
                    label: 'Edit',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Icon Buttons', '''
AdaptiveResponsiveIconButton(
  icon: Icons.favorite,
  tooltip: 'Like',
),
AdaptiveResponsiveFAB(
  icon: Icons.add,
  isExtended: true,
  label: 'Add',
),'''),
      ],
    );
  }

  /// Build special buttons examples
  Widget _buildSpecialButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Outline Buttons'),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
        Container(
          padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(
              DeviceConfiguration.getResponsiveSpacing(8.0),
            ),
            border: Border.all(color: Colors.purple[200]!),
          ),
          child: Column(
            children: [
              // Outline buttons row
              _buildButtonRow([
                Expanded(
                  child: AdaptiveResponsiveOutlineButton(
                    text: 'Outline',
                    onPressed: () => _showButtonPressed('Outline Button'),
                  ),
                ),
                SizedBox(width: DeviceConfiguration.getResponsiveSpacing(12)),
                Expanded(
                  child: AdaptiveResponsiveOutlineButton(
                    text: 'With Icon',
                    onPressed: () => _showButtonPressed('Outline with Icon'),
                    icon: Icons.download,
                  ),
                ),
              ]),

              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),

              // Custom colored outline button
              AdaptiveResponsiveOutlineButton(
                text: 'Custom Color Outline',
                onPressed: () => _showButtonPressed('Custom Outline'),
                isFullWidth: true,
                icon: Icons.cloud_download,
                borderColor: Colors.green,
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Outline Buttons', '''
AdaptiveResponsiveOutlineButton(
  text: 'Outline',
  onPressed: () {},
),
AdaptiveResponsiveOutlineButton(
  text: 'Custom Color',
  icon: Icons.download,
  borderColor: Colors.green,
),'''),
      ],
    );
  }

  /// Build button row helper
  Widget _buildButtonRow(List<Widget> children) {
    return Row(children: children);
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

  /// Show button pressed feedback
  void _showButtonPressed(String buttonName) {
    // In a real app, you might show a snackbar or perform an action
    debugPrint('$buttonName pressed!');
  }
}
