import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';

class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  State<PageViewDemo> createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PageData> _pages = [
    PageData(
      title: 'Welcome to PageView',
      subtitle: 'Swipe horizontally to navigate',
      color: Colors.blue,
      icon: Icons.swipe,
      description: 'PageView allows you to create swipeable pages with smooth transitions.',
    ),
    PageData(
      title: 'Smooth Animations',
      subtitle: 'Built-in page transitions',
      color: Colors.green,
      icon: Icons.animation,
      description: 'Each page transition is animated smoothly with customizable curves.',
    ),
    PageData(
      title: 'Responsive Design',
      subtitle: 'Works on all screen sizes',
      color: Colors.orange,
      icon: Icons.devices,
      description: 'PageView adapts to different screen sizes and orientations.',
    ),
    PageData(
      title: 'Interactive Controls',
      subtitle: 'Tap indicators to jump',
      color: Colors.purple,
      icon: Icons.touch_app,
      description: 'Use page indicators or buttons to navigate between pages.',
    ),
    PageData(
      title: 'Customizable',
      subtitle: 'Many configuration options',
      color: Colors.red,
      icon: Icons.settings,
      description: 'Customize scroll direction, physics, and page snapping behavior.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('PageView Demo'),
        appBar: AppBar(),
      ),
      body: Column(
        children: [
          _buildInfoCard(),
          Expanded(
            child: _buildPageView(),
          ),
          _buildPageIndicator(),
          _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PageView Widget',
                style: TextStyle(
                  fontSize: DeviceConfiguration.isMobileResolution ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A scrollable widget that works page by page. Perfect for onboarding, '
                'image galleries, and step-by-step interfaces.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _buildPage(_pages[index]);
        },
      ),
    );
  }

  Widget _buildPage(PageData pageData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            pageData.color.withOpacity(0.8),
            pageData.color.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: pageData.color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 24.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                pageData.icon,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              pageData.title,
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              pageData.subtitle,
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 16 : 18,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pageData.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? _pages[index].color
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _currentPage > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
          ),
          Text(
            '${_currentPage + 1} of ${_pages.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _currentPage < _pages.length - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class PageData {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final IconData icon;

  PageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.icon,
  });
}
