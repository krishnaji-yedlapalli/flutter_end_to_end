import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/shared/widgets/responsive_widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Responsive app bar for the showcase page that adapts to different screen sizes
class ResponsiveShowcaseAppBar extends StatelessWidget {
  const ResponsiveShowcaseAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: _getExpandedHeight(),
      floating: false,
      pinned: true,
      elevation: DeviceConfiguration.platformElevation,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: ResponsiveText(
          'Responsive Showcase',
          color: Colors.white,
          fontWeight: FontWeight.w600,
          baseFontSize: _getTitleFontSize(),
        ),
        centerTitle: DeviceConfiguration.isMobilePortrait,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: _buildBackgroundContent(),
        ),
      ),
      actions: _buildActions(context),
    );
  }

  /// Get expanded height based on device type
  double _getExpandedHeight() {
    if (DeviceConfiguration.isDesktopResolution) {
      return 200.0; // Larger header on desktop
    } else if (DeviceConfiguration.isTabResolution) {
      return 180.0; // Medium header on tablet
    } else {
      return 150.0; // Compact header on mobile
    }
  }

  /// Get title font size based on device type
  double _getTitleFontSize() {
    if (DeviceConfiguration.isDesktopResolution) {
      return 20.0;
    } else if (DeviceConfiguration.isTabResolution) {
      return 18.0;
    } else {
      return 16.0;
    }
  }

  /// Build background content for the app bar
  Widget _buildBackgroundContent() {
    return Positioned(
      bottom: DeviceConfiguration.getResponsiveSpacing(20),
      left: DeviceConfiguration.getResponsiveSpacing(16),
      right: DeviceConfiguration.getResponsiveSpacing(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: DeviceConfiguration.isMobilePortrait
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (!DeviceConfiguration.isMobilePortrait) ...[
            // Only show subtitle on larger screens
            ResponsiveText(
              'Interactive examples of adaptive widgets',
              color: Colors.white.withOpacity(0.9),
              baseFontSize: 14.0,
            ),

            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),

            _buildDeviceIndicator(),
          ],
        ],
      ),
    );
  }

  /// Build device type indicator
  Widget _buildDeviceIndicator() {
    IconData deviceIcon;
    String deviceText;

    if (DeviceConfiguration.isDesktopResolution) {
      deviceIcon = Icons.desktop_windows;
      deviceText = 'Desktop View';
    } else if (DeviceConfiguration.isTabResolution) {
      deviceIcon = Icons.tablet;
      deviceText = 'Tablet View';
    } else {
      deviceIcon = Icons.phone_android;
      deviceText = 'Mobile View';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          deviceIcon,
          size: DeviceConfiguration.getResponsiveIconSize(16),
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(width: DeviceConfiguration.getResponsiveSpacing(6)),
        ResponsiveSmallText(
          deviceText,
          color: Colors.white.withOpacity(0.8),
        ),
      ],
    );
  }

  /// Build app bar actions
  List<Widget> _buildActions(BuildContext context) {
    return [
      // Info button
      IconButton(
        icon: Icon(
          Icons.info_outline,
          size: DeviceConfiguration.getResponsiveIconSize(24),
        ),
        onPressed: () => _showInfoDialog(context),
        tooltip: 'About Responsive Showcase',
      ),

      // Settings button (only on larger screens)
      if (!DeviceConfiguration.isMobilePortrait)
        IconButton(
          icon: Icon(
            Icons.settings,
            size: DeviceConfiguration.getResponsiveIconSize(24),
          ),
          onPressed: () => _showSettingsDialog(context),
          tooltip: 'Settings',
        ),

      SizedBox(width: DeviceConfiguration.getResponsiveSpacing(8)),
    ];
  }

  /// Show info dialog
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const ResponsiveTitle('About Responsive Showcase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ResponsiveText(
              'This showcase demonstrates responsive and adaptive widgets that work across all screen sizes and platforms.',
            ),
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
            const ResponsiveText('Features:'),
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
            const ResponsiveSmallText(
                '• Platform-specific styling (iOS/Android)'),
            const ResponsiveSmallText('• Responsive text and spacing'),
            const ResponsiveSmallText(
                '• Adaptive layouts for all screen sizes'),
            const ResponsiveSmallText('• Optimized performance'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const ResponsiveText('Close'),
          ),
        ],
      ),
    );
  }

  /// Show settings dialog
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const ResponsiveTitle('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ResponsiveText('Showcase settings will be available here.'),
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),
            ResponsiveSmallText(
              'Current resolution: ${DeviceConfiguration.resolutionType}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const ResponsiveText('Close'),
          ),
        ],
      ),
    );
  }
}
