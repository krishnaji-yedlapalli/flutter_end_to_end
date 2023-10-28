import 'package:flutter/material.dart';

class StepperExampleApp extends StatelessWidget {
  const StepperExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StepperExample();
  }
}

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      // onStepCancel: () {
      //   if (_index > 0) {
      //     setState(() {
      //       _index -= 1;
      //     });
      //   }
      // },
      // onStepContinue: () {
      //   if (_index <= 0) {
      //     setState(() {
      //       _index += 1;
      //     });
      //   }
      // },
      // onStepTapped: (int index) {
      //   setState(() {
      //     _index = index;
      //   });
      // },

      stepIconBuilder: (int, state) {Icon(Icons.add, size: 12);},
      connectorColor: MaterialStateProperty.all(Colors.black),
      controlsBuilder: (_, controlDetails) => SizedBox(height: 0, width: 0,),

      type: StepperType.vertical,
      connectorThickness: 3,
      steps: <Step>[
        Step(
          label: Icon(Icons.add),
          // subtitle: Text('heloo'),
          title: const Text('Step 1 title'),
          content: Container(
            alignment: Alignment.center,
            child: const Text('Content for Step 1'),
          ),
          isActive: true,
          state: StepState.complete
        ),
        Step(
            label: Icon(Icons.add),
            // subtitle: Text('heloo'),
            title: const Text('Step 1 title'),
            content: SizedBox(child: Text('gh'),) ??  Container(
              alignment: Alignment.center,
              child: const Text('Content for Step 1'),
            ),
            isActive: true,
            subtitle: Text('dfgfd'),
            state: StepState.complete
        ),
        Step(
            label: Icon(Icons.add),
            // subtitle: Text('heloo'),
            title: const Text('Step 1 title'),
            content: Container(
              alignment: Alignment.center,
              child: const Text('Content for Step 1'),
            ),
            isActive: true,
            state: StepState.complete
        ),
        const Step(
          title: Text('Step 2 title'),
          content: Text('Content for Step 2'),
        ),
      ],
    );
  }
}
