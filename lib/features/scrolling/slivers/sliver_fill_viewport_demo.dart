import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/shared/non_responsive_widgets/non_responsive_widgets.dart';

class SliverFillViewportDemo extends StatelessWidget {
  const SliverFillViewportDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('SliverFillViewport Demo'),
        appBar: AppBar(),
      ),
      body: CustomScrollView(
        slivers: [
          // Info header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(
                  DeviceConfiguration.isMobileResolution ? 16.0 : 24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fullscreen,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'SliverFillViewport',
                            style: TextStyle(
                              fontSize: DeviceConfiguration.isMobileResolution
                                  ? 20
                                  : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'SliverFillViewport creates a sliver where each child fills the entire viewport. '
                        'Perfect for full-screen pages, onboarding screens, or image galleries.',
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Swipe vertically to see each viewport page',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // SliverFillViewport with different pages
          SliverFillViewport(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildViewportPage(context, index);
              },
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewportPage(BuildContext context, int index) {
    final pages = [
      _buildWelcomePage(),
      _buildFeaturePage(),
      _buildGalleryPage(),
      _buildStatisticsPage(),
      _buildContactPage(),
    ];

    return Container(
      margin: EdgeInsets.all(DeviceConfiguration.isMobileResolution ? 16 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: pages[index],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.purple,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 24.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.waving_hand,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 32 : 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This is a SliverFillViewport demo.\nEach page fills the entire screen.',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 16 : 18,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Swipe up to continue',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturePage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green,
            Colors.teal,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 24.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Features',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 32 : 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ..._buildFeatureList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      'Full viewport coverage',
      'Smooth scrolling transitions',
      'Perfect for onboarding',
      'Responsive design',
      'Easy to implement',
    ];

    return features
        .map((feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize:
                            DeviceConfiguration.isMobileResolution ? 16 : 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildGalleryPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange,
            Colors.red,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 24.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Gallery',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 32 : 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      DeviceConfiguration.isMobileResolution ? 2 : 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image ${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo,
            Colors.purple,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 24.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Statistics',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 32 : 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Users', '10K+'),
                _buildStatCard('Downloads', '50K+'),
                _buildStatCard('Rating', '4.8★'),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Countries', '25+'),
                _buildStatCard('Languages', '12'),
                _buildStatCard('Updates', '100+'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: DeviceConfiguration.isMobileResolution ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: DeviceConfiguration.isMobileResolution ? 12 : 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink,
            Colors.purple,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            DeviceConfiguration.isMobileResolution ? 24.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contact_mail,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: DeviceConfiguration.isMobileResolution ? 32 : 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            _buildContactItem(Icons.email, 'hello@example.com'),
            const SizedBox(height: 16),
            _buildContactItem(Icons.phone, '+1 (555) 123-4567'),
            const SizedBox(height: 16),
            _buildContactItem(Icons.location_on, '123 Flutter Street'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Get in Touch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: DeviceConfiguration.isMobileResolution ? 16 : 18,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
