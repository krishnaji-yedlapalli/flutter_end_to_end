import 'package:flutter_test/flutter_test.dart';
import 'package:sample_latest/core/mixins/validators.dart';

class ValidatorTest with Validators {}

void main() {
  late ValidatorTest validatorTest;

  setUp((){
   validatorTest = ValidatorTest();
  });

  group('Validator testing', () {

    test('email validator test', () {
      expect(validatorTest.textEmptyValidator('', 'email required'),
          'email required');

      expect(validatorTest.textEmptyValidator(null, 'email required'),
          'email required');
    });
  });
}
