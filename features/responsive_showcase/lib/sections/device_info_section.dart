import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/widgets/responsive_widgets/widgets.dart';

import '../widgets/showcase_section_card.dart';

/// Section that displays current device configuration and responsive metrics
class DeviceInfoSection extends StatelessWidget {
  const DeviceInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowcaseSectionCard(
      title: 'Device Information',
      subtitle: 'Current device configuration and responsive metrics',
      child: Column(
        children: [
          _buildInfoGrid(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(20)),
          _buildResolutionVisualization(),
        ],
      ),
    );
  }

  /// Build information grid with device details
  Widget _buildInfoGrid() {
    final infoItems = [
      {
        'label': 'Resolution Type',
        'value': DeviceConfiguration.resolutionType.toString().split('.').last,
        'icon': Icons.aspect_ratio,
      },
      {
        'label': 'Screen Size',
        'value':
            '${DeviceConfiguration.screenWidth.toInt()} × ${DeviceConfiguration.screenHeight.toInt()}',
        'icon': Icons.screenshot_monitor,
      },
      {
        'label': 'Scale Factor',
        'value':
            DeviceConfiguration.getResponsiveScaleFactor().toStringAsFixed(2),
        'icon': Icons.zoom_in,
      },
      {
        'label': 'Platform Design',
        'value':
            DeviceConfiguration.useCupertinoDesign ? 'Cupertino' : 'Material',
        'icon': DeviceConfiguration.useCupertinoDesign
            ? Icons.apple
            : Icons.android,
      },
      {
        'label': 'Grid Columns',
        'value': DeviceConfiguration.getGridColumnCount().toString(),
        'icon': Icons.grid_view,
      },
      {
        'label': 'Orientation',
        'value': DeviceConfiguration.isPortrait ? 'Portrait' : 'Landscape',
        'icon': DeviceConfiguration.isPortrait
            ? Icons.stay_current_portrait
            : Icons.stay_current_landscape,
      },
    ];

    // Determine grid columns based on device type
    int crossAxisCount;
    if (DeviceConfiguration.isDesktopResolution) {
      crossAxisCount = 3; // 3 columns on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      crossAxisCount = 2; // 2 columns on tablet
    } else {
      crossAxisCount = 1; // 1 column on mobile
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DeviceConfiguration.getResponsiveSpacing(12),
        mainAxisSpacing: DeviceConfiguration.getResponsiveSpacing(12),
        childAspectRatio: DeviceConfiguration.isMobilePortrait ? 4.0 : 3.5,
      ),
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        final item = infoItems[index];
        return _buildInfoCard(
          item['label'] as String,
          item['value'] as String,
          item['icon'] as IconData,
        );
      },
    );
  }

  /// Build individual info card
  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: DeviceConfiguration.getResponsivePadding(base: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(8.0),
        ),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResponsiveSmallText(
                  label,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: DeviceConfiguration.getResponsiveSpacing(2)),
                ResponsiveText(
                  value,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build resolution type visualization
  Widget _buildResolutionVisualization() {
    return Container(
      padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[50]!,
            Colors.purple[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(12.0),
        ),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const ResponsiveTitle(
            'Resolution Breakdown',
            centerText: true,
          ),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
          _buildResolutionBars(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
          _buildResolutionLegend(),
        ],
      ),
    );
  }

  /// Build resolution comparison bars
  Widget _buildResolutionBars() {
    final resolutions = [
      {'name': 'Mobile Portrait', 'width': 480, 'color': Colors.green},
      {'name': 'Mobile Landscape', 'width': 768, 'color': Colors.orange},
      {'name': 'Tablet Portrait', 'width': 1024, 'color': Colors.blue},
      {'name': 'Tablet Landscape', 'width': 1200, 'color': Colors.purple},
      {'name': 'Desktop Standard', 'width': 1440, 'color': Colors.red},
      {'name': 'Desktop Large', 'width': 1920, 'color': Colors.teal},
    ];

    const maxWidth = 1920.0;

    return Column(
      children: resolutions.map((resolution) {
        final width = resolution['width'] as int;
        final color = resolution['color'] as Color;
        final name = resolution['name'] as String;
        final isCurrentResolution = _isCurrentResolution(width);

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: DeviceConfiguration.getResponsiveSpacing(4),
          ),
          child: Row(
            children: [
              SizedBox(
                width: DeviceConfiguration.getResponsiveSpacing(120),
                child: ResponsiveSmallText(
                  name,
                  fontWeight:
                      isCurrentResolution ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentResolution ? color : Colors.grey[600],
                ),
              ),
              Expanded(
                child: Container(
                  height: DeviceConfiguration.getResponsiveSpacing(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: width / maxWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrentResolution
                            ? color
                            : color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: DeviceConfiguration.getResponsiveSpacing(8)),
              ResponsiveSmallText(
                '${width}px',
                fontWeight:
                    isCurrentResolution ? FontWeight.bold : FontWeight.normal,
                color: isCurrentResolution ? color : Colors.grey[600],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Build resolution legend
  Widget _buildResolutionLegend() {
    return ResponsiveSmallText(
      'Current screen width: ${DeviceConfiguration.screenWidth.toInt()}px',
      centerText: true,
      fontWeight: FontWeight.w600,
      color: Colors.blue[700],
    );
  }

  /// Check if the given width matches current resolution type
  bool _isCurrentResolution(int width) {
    final resolutionType = DeviceConfiguration.resolutionType;

    switch (resolutionType.toString().split('.').last) {
      case 'mobilePortrait':
        return width == 480;
      case 'mobileLandscape':
        return width == 768;
      case 'tabletPortrait':
        return width == 1024;
      case 'tabletLandscape':
        return width == 1200;
      case 'desktopStandard':
        return width == 1440;
      case 'desktopLarge':
        return width == 1920;
      default:
        return false;
    }
  }
}
