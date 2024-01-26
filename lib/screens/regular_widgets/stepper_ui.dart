import 'package:flutter/material.dart';
import 'package:sample_latest/utils/device_configurations.dart';

class StepperExampleApp extends StatelessWidget {
  const StepperExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StepperExample();
  }
}

class StepperExample extends StatefulWidget
{
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _index = 0;

  List<
      ({
        String title,
        IconData icon,
        StepState state,
        bool isActive,
        String? subtitle,
        String? content
      })> stepperData = [
    (
      title: 'Your order Confirmed',
      icon: Icons.add,
      state: StepState.complete,
      isActive: true,
      subtitle: null,
      content: 'You order is confirmed, preparing to dispatch',
    ),
    (
      title: 'Your order ready to Dispatch',
      icon: Icons.add,
      state: StepState.complete,
      isActive: true,
      subtitle: null,
      content: 'Order is packed about to dispatch',
    ),
    (
      title: 'Your order Dispatched',
      icon: Icons.add,
      state: StepState.complete,
      isActive: true,
      subtitle: 'Dispatched at New york',
      content: 'Order is dispatched from Warehouse',
    ),
    (
      title: 'Your order is at Head office of deliver location ',
      icon: Icons.add,
      state: StepState.complete,
      isActive: true,
      subtitle: null,
      content:
          'You order is dispatched to the near by location, will deliver soon',
    ),
    (
      title: 'Your order on hold',
      icon: Icons.add,
      state: StepState.disabled,
      isActive: false,
      subtitle: null,
      content:
          'You order is on hold, looks like you are available or address is not proper',
    ),
    (
      title: 'Your order cancelled',
      icon: Icons.add,
      state: StepState.error,
      isActive: false,
      subtitle: null,
      content:
          'You order is cancelled due to improper address, order again with proper address',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DeviceConfiguration.isMobileResolution
        ? SingleChildScrollView(
          child: Column(
              children: [
                _stepperWithoutAction(),
                Divider(),
                _stepperWithTapAction()
              ],
            ),
        )
        : Row(
            children: [
              Expanded(child: _stepperWithoutAction()),
              VerticalDivider(),
              Expanded(child: _stepperWithTapAction())
            ],
          );
  }

  Widget _stepperWithoutAction() {
    return Column(
      children: [
        title('Stepper without any actions'),
        Stepper(
            currentStep: 5,
            // stepIconBuilder: (index, state) => Icon(Icons.add, size: 12),
            // connectorColor: MaterialStateProperty.all(Colors.black),
            controlsBuilder: (_, controlDetails) => SizedBox(
                  height: 0,
                  width: 0,
                ),
            type: StepperType.vertical,
            connectorThickness: 3,
            steps: stepperData
                .map((stepper) => Step(
                    label: Icon(stepper.icon),
                    subtitle: stepper.subtitle != null
                        ? Text(stepper.subtitle!)
                        : null,
                    title: Text(stepper.title),
                    content: SizedBox(),
                    isActive: stepper.isActive,
                    state: stepper.state))
                .toList()),
      ],
    );
  }

  Widget _stepperWithTapAction() {
    return Column(
      children: [
        title('Stepper with actions'),
        Stepper(
            currentStep: _index,

            // stepIconBuilder: (int, state) => Icon(Icons.add, size: 12),
            // connectorColor: MaterialStateProperty.all(Colors.black),
            // controlsBuilder: (_, controlDetails) => SizedBox(
            //       height: 0,
            //       width: 0,
            //     ),
            type: StepperType.vertical,
            connectorThickness: 3,
            onStepTapped: (index) {
              setState(() {
                _index = index;
              });
            },
            onStepContinue: () {
              if (_index == 5) return;
              setState(() {
                ++_index;
              });
            },
            onStepCancel: _index == 5 ? () {} : null,
            steps: stepperData
                .map((stepper) => Step(
                      label: Icon(stepper.icon),
                      subtitle: stepper.subtitle != null
                          ? Text(stepper.subtitle!)
                          : null,
                      title: Text(stepper.title),
                      content: Container(
                        // alignment: Alignment.center,
                        child: Wrap(
                          direction: Axis.vertical,
                          children: [
                            Text(stepper.content ?? '', style: TextStyle(color: Colors.orange)),
                            Text(DateTime.now().subtract(Duration(days: _index)).toString(), style: TextStyle(color: Colors.purple))
                          ],
                        ),
                      ),
                      isActive: stepper.isActive,
                      state: stepper.state,
                    ))
                .toList()),
      ],
    );
  }

  Text title(String title) => Text(title, style: Theme.of(context).textTheme.headlineSmall);
}
