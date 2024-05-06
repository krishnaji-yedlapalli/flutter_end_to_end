// ignore_for_file: unused_local_variable,pattern_never_matches_value_type

class Dart3Features {

  final fullName;
  Dart3Features(String firstName, String lastName) :
      fullName = firstName + lastName {
      print('builded initiators');
      invokeMethod();
  }


  void invokeMethod() {

    print(exhaustiveFunctionWithRecords());

    /// return three parameters.
    var res = recordsFunc();
    print(res.$1);
    print(res.$2);

    /// named arguments
    var res1 = namedRecordFunc();
    print(res1.y);
  }


  /// with positional arguments
  (int a, int b, int c, ) recordsFunc() {
    (int x, int y, int z)  recordVar = (1,2,3);
    return recordVar;
  }

  /// with named arguments
  (int, {int y, int z}) namedRecordFunc() {

    (int a, int b, {int c}) f = (2, c : 4, 34);

    /// name should be same
  (int x, {int y, int z}) xyz= (12, y : 23, z : 34);
    return xyz;
  }

  String exhaustivefunc(String name) {
    return switch(name) {
      'krishna'=> 'my name only',
      _ when name.contains('su') && name == 'sudheer' => 'f*ck you',
      _ => 'no data'
    };
    return 'heloo';
  }

  String exhaustiveFunctionWithRecords() {
    (int a, int b) records = (4,2);
    return switch(records){
    (3,4) => 'helooo',
    (int a, int b) when a > b => 'hey a is big',
    _ => 'nothing'
    };
  }


  String exhaustiveFunctionWithRecordsNamed() {
    (int a, int b, {int c}) records = (4,2, c : 12);
    return switch(records){
    (3,4) => 'helooo',
    (int a, int b, int d) when a > b && b < d => 'hey a is big',
    _ => 'nothing'
  };
  }
}