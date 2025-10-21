import 'package:flutter/material.dart';
import '../../../core/device/config/device_configurations.dart';
import '../../../core/device/widgets/text_widgets/text_widgets.dart';

/// Reusable card widget for showcase sections with consistent styling
class ShowcaseSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool expandable;
  final bool initiallyExpanded;

  const ShowcaseSectionCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.expandable = false,
    this.initiallyExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardPadding =
        padding ?? DeviceConfiguration.getResponsivePadding(base: 20.0);

    Widget content = Container(
      width: double.infinity,
      padding: cardPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (subtitle != null) ...[
            SizedBox(height: DeviceConfiguration.getResponsiveSpacing(8)),
            ResponsiveSubtitle(
              subtitle!,
              color: Colors.grey[600],
            ),
          ],
          SizedBox(height: DeviceConfiguration.getResponsiveSpacing(20)),
          child,
        ],
      ),
    );

    if (expandable) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: ResponsiveTitle(title),
          subtitle: subtitle != null ? ResponsiveSubtitle(subtitle!) : null,
          initiallyExpanded: initiallyExpanded,
          children: [
            Padding(
              padding: cardPadding,
              child: child,
            ),
          ],
        ),
      );
    }

    return content;
  }

  /// Build section header
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: ResponsiveTitle(
            title,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        if (expandable)
          Icon(
            Icons.expand_more,
            size: DeviceConfiguration.getResponsiveIconSize(24),
            color: Colors.grey[600],
          ),
      ],
    );
  }
}

/// Specialized section card variants

/// Card with gradient background
class ShowcaseGradientCard extends ShowcaseSectionCard {
  ShowcaseGradientCard({
    Key? key,
    required String title,
    String? subtitle,
    required Widget child,
    EdgeInsets? padding,
    List<Color>? gradientColors,
    bool expandable = false,
    bool initiallyExpanded = true,
  }) : super(
          key: key,
          title: title,
          subtitle: subtitle,
          child: child,
          padding: padding,
          expandable: expandable,
          initiallyExpanded: initiallyExpanded,
        );

  @override
  Widget build(BuildContext context) {
    final cardPadding =
        padding ?? DeviceConfiguration.getResponsivePadding(base: 20.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.05),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(
          DeviceConfiguration.getResponsiveSpacing(12.0),
        ),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ShowcaseSectionCard(
        title: title,
        subtitle: subtitle,
        padding: cardPadding,
        backgroundColor: Colors.transparent,
        expandable: expandable,
        initiallyExpanded: initiallyExpanded,
        child: child,
      ),
    );
  }
}

/// Compact card for smaller sections
class ShowcaseCompactCard extends ShowcaseSectionCard {
  const ShowcaseCompactCard({
    Key? key,
    required String title,
    String? subtitle,
    required Widget child,
    bool expandable = false,
    bool initiallyExpanded = true,
  }) : super(
          key: key,
          title: title,
          subtitle: subtitle,
          child: child,
          expandable: expandable,
          initiallyExpanded: initiallyExpanded,
        );

  @override
  Widget build(BuildContext context) {
    return ShowcaseSectionCard(
      title: title,
      subtitle: subtitle,
      padding: DeviceConfiguration.getResponsivePadding(base: 12.0),
      expandable: expandable,
      initiallyExpanded: initiallyExpanded,
      child: child,
    );
  }
}
