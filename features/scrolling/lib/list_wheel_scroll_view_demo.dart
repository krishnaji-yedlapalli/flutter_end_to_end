import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/shared/widgets/non_responsive_widgets/non_responsive_widgets.dart';
import 'package:flutter/material.dart';

class ListWheelScrollViewDemo extends StatefulWidget {
  const ListWheelScrollViewDemo({Key? key}) : super(key: key);

  @override
  State<ListWheelScrollViewDemo> createState() =>
      _ListWheelScrollViewDemoState();
}

class _ListWheelScrollViewDemoState extends State<ListWheelScrollViewDemo> {
  int selectedIndex = 0;
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  final List<String> timeZones = [
    'UTC-12:00 Baker Island',
    'UTC-11:00 American Samoa',
    'UTC-10:00 Hawaii',
    'UTC-09:00 Alaska',
    'UTC-08:00 Pacific Time',
    'UTC-07:00 Mountain Time',
    'UTC-06:00 Central Time',
    'UTC-05:00 Eastern Time',
    'UTC-04:00 Atlantic Time',
    'UTC-03:00 Argentina',
    'UTC-02:00 South Georgia',
    'UTC-01:00 Azores',
    'UTC+00:00 London',
    'UTC+01:00 Paris',
    'UTC+02:00 Cairo',
    'UTC+03:00 Moscow',
    'UTC+04:00 Dubai',
    'UTC+05:00 Karachi',
    'UTC+05:30 India',
    'UTC+06:00 Dhaka',
    'UTC+07:00 Bangkok',
    'UTC+08:00 Singapore',
    'UTC+09:00 Tokyo',
    'UTC+10:00 Sydney',
    'UTC+11:00 Solomon Islands',
    'UTC+12:00 New Zealand',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('ListWheelScrollView'),
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildTimeZonePicker(),
            const SizedBox(height: 20),
            _buildColorPicker(),
            const SizedBox(height: 20),
            _buildNumberPicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ListWheelScrollView',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A scrollable list widget that creates a wheel-like scrolling effect. '
              'Perfect for pickers and selection interfaces.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeZonePicker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Zone Picker',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 50,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: timeZones.length,
                  builder: (context, index) {
                    final isSelected = index == selectedIndex;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Theme.of(context).primaryColor)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          timeZones[index],
                          style: TextStyle(
                            fontSize: isSelected ? 16 : 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Selected: ${timeZones[selectedIndex]}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Color Picker Wheel',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListWheelScrollView(
                itemExtent: 60,
                diameterRatio: 2.0,
                perspective: 0.01,
                children: colors.map((color) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        color.toString().split('(')[1].split(')')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPicker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number Picker',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNumberWheel('Hours', 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNumberWheel('Minutes', 60),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNumberWheel('Seconds', 60),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberWheel(String label, int maxValue) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            perspective: 0.01,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: maxValue,
              builder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
