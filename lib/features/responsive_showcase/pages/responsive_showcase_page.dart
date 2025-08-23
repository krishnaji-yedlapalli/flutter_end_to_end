import 'package:flutter/material.dart';
import '../../../core/device/config/device_configurations.dart';
import '../../../core/device/widgets/text_widgets/text_widgets.dart';
import '../sections/device_info_section.dart';
import '../sections/text_widgets_section.dart';
import '../sections/button_widgets_section.dart';
import '../sections/layout_examples_section.dart';
import '../widgets/responsive_showcase_app_bar.dart';

/// Main responsive showcase page that demonstrates all adaptive and responsive widgets
class ResponsiveShowcasePage extends StatelessWidget {
  const ResponsiveShowcasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Responsive App Bar
          const ResponsiveShowcaseAppBar(),
          
          // Main content sections
          SliverPadding(
            padding: _getResponsivePadding(),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome section
                _buildWelcomeSection(),
                
                _buildSectionSpacing(),
                
                // Device information
                const DeviceInfoSection(),
                
                _buildSectionSpacing(),
                
                // Text widgets showcase
                const TextWidgetsSection(),
                
                _buildSectionSpacing(),
                
                // Button widgets showcase
                const ButtonWidgetsSection(),
                
                _buildSectionSpacing(),
                
                // Layout examples
                const LayoutExamplesSection(),
                
                // Bottom spacing
                SizedBox(height: DeviceConfiguration.getResponsiveSpacing(50)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// Get responsive padding based on device type
  EdgeInsets _getResponsivePadding() {
    if (DeviceConfiguration.isDesktopResolution) {
      // Desktop: More padding on sides, less on top/bottom
      return DeviceConfiguration.getResponsivePadding(
        horizontal: 32.0,
        vertical: 16.0,
      );
    } else if (DeviceConfiguration.isTabResolution) {
      // Tablet: Moderate padding
      return DeviceConfiguration.getResponsivePadding(
        horizontal: 24.0,
        vertical: 16.0,
      );
    } else {
      // Mobile: Standard padding
      return DeviceConfiguration.getResponsivePadding(base: 16.0);
    }
  }

  /// Build welcome section with responsive layout
  Widget _buildWelcomeSection() {
    return Container(
      padding: DeviceConfiguration.getResponsivePadding(base: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveHeader(
            'Responsive Showcase',
            centerText: true,
          ),
          
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
          
          const ResponsiveSubtitle(
            'Explore adaptive and responsive widgets that work seamlessly across all screen sizes and platforms.',
            centerText: true,
          ),
          
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
          
          _buildFeatureHighlights(),
        ],
      ),
    );
  }

  /// Build feature highlights with responsive grid
  Widget _buildFeatureHighlights() {
    final features = [
      {'icon': Icons.devices, 'title': 'Multi-Platform', 'desc': 'iOS, Android, Web, Desktop'},
      {'icon': Icons.restore_page_outlined, 'title': 'Responsive', 'desc': 'Adapts to all screen sizes'},
      {'icon': Icons.palette, 'title': 'Adaptive Design', 'desc': 'Platform-specific styling'},
      {'icon': Icons.speed, 'title': 'Optimized', 'desc': 'Performance-focused widgets'},
    ];

    // Determine grid columns based on device type
    int crossAxisCount;
    if (DeviceConfiguration.isDesktopResolution) {
      crossAxisCount = 4; // All in one row on desktop
    } else if (DeviceConfiguration.isTabletLandscape) {
      crossAxisCount = 4; // All in one row on tablet landscape
    } else if (DeviceConfiguration.isTabResolution) {
      crossAxisCount = 2; // Two columns on tablet
    } else {
      crossAxisCount = 2; // Two columns on mobile
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DeviceConfiguration.getResponsiveSpacing(12),
        mainAxisSpacing: DeviceConfiguration.getResponsiveSpacing(12),
        childAspectRatio: DeviceConfiguration.isMobilePortrait ? 1.2 : 1.5,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(
          feature['icon'] as IconData,
          feature['title'] as String,
          feature['desc'] as String,
        );
      },
    );
  }

  /// Build individual feature card
  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: DeviceConfiguration.getResponsivePadding(base: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(8.0),
        ),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: DeviceConfiguration.getResponsiveIconSize(24),
            color: Colors.blue,
          ),
          
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
          
          ResponsiveText(
            title,
            fontWeight: FontWeight.w600,
            centerText: true,
          ),
          
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(4)),
          
          ResponsiveSmallText(
            description,
            centerText: true,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  /// Build consistent section spacing
  Widget _buildSectionSpacing() {
    return SizedBox(
      height: DeviceConfiguration.getResponsiveSpacing(32),
    );
  }
}
