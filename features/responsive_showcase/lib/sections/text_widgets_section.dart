import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/shared/widgets/responsive_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/showcase_section_card.dart';

/// Section showcasing all responsive text widgets with examples
class TextWidgetsSection extends StatelessWidget {
  const TextWidgetsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowcaseSectionCard(
      title: 'Responsive Text Widgets',
      subtitle: 'Text components that adapt to screen size and platform',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextHierarchy(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildTextVariants(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildTextStyling(),
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(24)),
          _buildTextAlignment(),
        ],
      ),
    );
  }

  /// Build text hierarchy examples
  Widget _buildTextHierarchy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Text Hierarchy'),
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
              const ResponsiveHeader('Header Text'),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveSubHeader('Sub Header Text'),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveTitle('Title Text'),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(6)),
              const ResponsiveSubtitle('Subtitle Text'),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(6)),
              const ResponsiveText(
                'Regular body text that adapts to different screen sizes while maintaining optimal readability across all devices and platforms.',
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Text Hierarchy', '''
ResponsiveHeader('Header Text'),
ResponsiveSubHeader('Sub Header Text'),
ResponsiveTitle('Title Text'),
ResponsiveSubtitle('Subtitle Text'),
ResponsiveText('Body text...'),'''),
      ],
    );
  }

  /// Build text variants examples
  Widget _buildTextVariants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Text Size Variants'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ResponsiveLargeText(
                  'Large Text - For emphasis and important content'),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveText(
                  'Regular Text - Standard body text for most content'),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveSmallText(
                  'Small Text - For secondary information and details'),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveCaptionText(
                  'Caption Text - For image captions and fine print'),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Text Variants', '''
ResponsiveLargeText('Large text'),
ResponsiveText('Regular text'),
ResponsiveSmallText('Small text'),
ResponsiveCaptionText('Caption text'),'''),
      ],
    );
  }

  /// Build text styling examples
  Widget _buildTextStyling() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Text Styling Options'),

        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(16)),

        // Create responsive grid for styling examples
        _buildStylingGrid(),

        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),

        _buildCodeExample('Text Styling', '''
ResponsiveText('Bold Text', fontWeight: FontWeight.bold),
ResponsiveText('Italic Text', fontStyle: FontStyle.italic),
ResponsiveText('Colored Text', color: Colors.blue),
ResponsiveText('Underlined', decoration: TextDecoration.underline),'''),
      ],
    );
  }

  /// Build styling examples grid
  Widget _buildStylingGrid() {
    final stylingExamples = [
      {
        'text': 'Bold Text',
        'widget': const ResponsiveText('Bold Text', fontWeight: FontWeight.bold)
      },
      {
        'text': 'Italic Text',
        'widget':
            const ResponsiveText('Italic Text', fontStyle: FontStyle.italic)
      },
      {
        'text': 'Underlined',
        'widget': const ResponsiveText('Underlined',
            decoration: TextDecoration.underline)
      },
      {
        'text': 'Letter Spacing',
        'widget': const ResponsiveText('Letter Spacing', letterSpacing: 2.0)
      },
    ];

    int crossAxisCount;
    if (DeviceConfiguration.isDesktopResolution) {
      crossAxisCount = 2;
    } else if (DeviceConfiguration.isTabResolution) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DeviceConfiguration.getResponsiveSpacing(12),
        mainAxisSpacing: DeviceConfiguration.getResponsiveSpacing(12),
        childAspectRatio: 3.0,
      ),
      itemCount: stylingExamples.length,
      itemBuilder: (context, index) {
        final example = stylingExamples[index];
        return Container(
          padding: DeviceConfiguration.getResponsivePadding(base: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              DeviceConfiguration.getResponsiveSpacing(6.0),
            ),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(child: example['widget'] as Widget),
        );
      },
    );
  }

  /// Build text alignment examples
  Widget _buildTextAlignment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveSubHeader('Text Alignment'),
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
              const ResponsiveText('Left Aligned Text (Default)',
                  textAlign: TextAlign.left),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveText('Center Aligned Text', centerText: true),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveText('Right Aligned Text',
                  textAlign: TextAlign.right),
              SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
              const ResponsiveText(
                'Justified text that spreads across the full width and aligns to both margins.',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        SizedBox(height: DeviceConfiguration.getResponsiveSpacing(12)),
        _buildCodeExample('Text Alignment', '''
ResponsiveText('Left aligned', textAlign: TextAlign.left),
ResponsiveText('Centered', centerText: true),
ResponsiveText('Right aligned', textAlign: TextAlign.right),
ResponsiveText('Justified', textAlign: TextAlign.justify),'''),
      ],
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
