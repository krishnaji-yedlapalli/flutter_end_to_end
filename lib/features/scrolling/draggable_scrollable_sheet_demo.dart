import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/shared/non_responsive_widgets/non_responsive_widgets.dart';

class DraggableScrollableSheetDemo extends StatefulWidget {
  const DraggableScrollableSheetDemo({Key? key}) : super(key: key);

  @override
  State<DraggableScrollableSheetDemo> createState() =>
      _DraggableScrollableSheetDemoState();
}

class _DraggableScrollableSheetDemoState
    extends State<DraggableScrollableSheetDemo> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('DraggableScrollableSheet'),
        appBar: AppBar(),
      ),
      body: Stack(
        children: [
          // Background content
          _buildBackgroundContent(),

          // Draggable scrollable sheet
          DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSheetHeader(),
                    Expanded(
                      child: _buildSheetContent(scrollController),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isExpanded) {
            _controller.animateTo(
              0.3,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            _controller.animateTo(
              0.9,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Icon(
            _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
      ),
    );
  }

  Widget _buildBackgroundContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DraggableScrollableSheet Demo',
                      style: TextStyle(
                        fontSize:
                            DeviceConfiguration.isMobileResolution ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This widget creates a bottom sheet that can be dragged up and down. '
                      'The sheet can be scrolled when expanded and supports various gestures.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Drag the bottom sheet up or down'),
                    const Text('• Use the FAB to animate the sheet'),
                    const Text('• Scroll within the sheet when expanded'),
                    const Text('• The sheet has min, initial, and max sizes'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Background Content Area\n(Drag the bottom sheet up)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.drag_handle,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Draggable Content',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.animateTo(
                    0.1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSheetContent(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 50,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildContentSection();
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getColorForIndex(index),
              child: Text(
                '${index}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text('Scrollable Item ${index}'),
            subtitle:
                Text('This is item number ${index} in the draggable sheet'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showItemOptions(context, index);
              },
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped item ${index}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sheet Features:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFeatureRow(Icons.touch_app, 'Draggable gestures'),
                _buildFeatureRow(Icons.scale, 'Scrollable content'),
                _buildFeatureRow(Icons.animation, 'Smooth animations'),
                _buildFeatureRow(Icons.settings, 'Configurable sizes'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Scrollable Items:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  void _showItemOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text('Edit Item ${index}'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text('Share Item ${index}'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text('Delete Item ${index}'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
