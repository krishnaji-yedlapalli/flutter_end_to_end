import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:sample_latest/features/isolates/core/isolates_injection_module.dart';
import 'package:sample_latest/features/isolates/isolate_with_compute.dart';
import 'package:sample_latest/features/isolates/presentation/cubit/isolate_cubit.dart';

class IsolateHome extends StatefulWidget {
  const IsolateHome({Key? key}) : super(key: key);

  @override
  State<IsolateHome> createState() => _IsolateHomeState();
}

class _IsolateHomeState extends State<IsolateHome> {
  bool _dependenciesInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    if (!_dependenciesInitialized) {
      try {
        IsolatesInjectionModule.initializeDependencies();
        _dependenciesInitialized = true;
      } catch (e) {
        // Dependencies might already be registered
        _dependenciesInitialized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var demos = [
      (
        'Enhanced Isolates Demo',
        'Clean Architecture + Platform Aware',
        IsolateType.isolateWithWithOutLag
      ),
      ('Legacy Demo', 'Original Implementation', IsolateType.isolateWithSpawn)
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolates Demonstrations'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: demos.length,
          itemBuilder: (_, index) {
            final demo = demos.elementAt(index);
            return Card(
              elevation: 4,
              child: InkWell(
                onTap: () => onTap(demo.$3, context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: DeviceConfiguration.getResponsivePadding(base: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        index == 0 ? Icons.rocket_launch : Icons.code,
                        size: DeviceConfiguration.getResponsiveIconSize(40),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                          height: DeviceConfiguration.getResponsiveSpacing(12)),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            demo.$1,
                            style: TextStyle(
                              fontSize:
                                  DeviceConfiguration.getResponsiveFontSize(14),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: DeviceConfiguration.getResponsiveSpacing(6)),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            demo.$2,
                            style: TextStyle(
                              fontSize:
                                  DeviceConfiguration.getResponsiveFontSize(12),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
        ),
      ),
    );
  }

  void onTap(IsolateType isolateType, BuildContext context) {
    if (!_dependenciesInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dependencies are still initializing...')),
      );
      return;
    }

    switch (isolateType) {
      case IsolateType.isolateWithWithOutLag:
        // Navigate to enhanced demo with BLoC provider
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => GetIt.instance<IsolateCubit>(),
              child: const EnhancedIsolateDemo(),
            ),
          ),
        );
        break;
      case IsolateType.isolateWithSpawn:
        context.go('/home/isolates/isolateWithSpawn');
        break;
    }
  }
}
