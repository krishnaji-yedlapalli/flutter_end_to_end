import 'dart:convert';
import 'dart:math';

class DummyDataSource {
  final Random _random = Random();

  final List<String> _firstNames = [
    'John',
    'Jane',
    'Mike',
    'Sarah',
    'David',
    'Emma',
    'Chris',
    'Lisa',
    'Robert',
    'Maria',
    'James',
    'Anna',
    'Michael',
    'Laura',
    'William'
  ];

  final List<String> _lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Hernandez',
    'Lopez',
    'Gonzalez'
  ];

  final List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
    'Austin',
    'Jacksonville'
  ];

  final List<String> _productNames = [
    'Laptop',
    'Smartphone',
    'Tablet',
    'Headphones',
    'Camera',
    'Watch',
    'Speaker',
    'Monitor',
    'Keyboard',
    'Mouse',
    'Printer',
    'Router'
  ];

  final List<String> _categories = [
    'Electronics',
    'Computers',
    'Audio',
    'Photography',
    'Accessories',
    'Gaming',
    'Office',
    'Home',
    'Sports',
    'Books'
  ];

  /// Generate large user dataset
  Future<List<Map<String, dynamic>>> generateUsers(int count) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 100 + (count ~/ 1000) * 50));

    return List.generate(count, (index) {
      final firstName = _firstNames[_random.nextInt(_firstNames.length)];
      final lastName = _lastNames[_random.nextInt(_lastNames.length)];

      return {
        'id': index + 1,
        'name': '$firstName $lastName',
        'email':
            '${firstName.toLowerCase()}.${lastName.toLowerCase()}@email.com',
        'age': 18 + _random.nextInt(50),
        'city': _cities[_random.nextInt(_cities.length)],
        'salary': 30000 + _random.nextDouble() * 120000,
      };
    });
  }

  /// Generate large product dataset
  Future<List<Map<String, dynamic>>> generateProducts(int count) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 100 + (count ~/ 1000) * 50));

    return List.generate(count, (index) {
      final productName = _productNames[_random.nextInt(_productNames.length)];
      final category = _categories[_random.nextInt(_categories.length)];

      return {
        'id': index + 1,
        'name': '$productName ${index + 1}',
        'category': category,
        'price': 10 + _random.nextDouble() * 2000,
        'stock': _random.nextInt(1000),
        'rating': 1 + _random.nextDouble() * 4,
      };
    });
  }

  /// Generate large JSON string for parsing tests
  Future<String> generateLargeJsonString(int recordCount) async {
    // Simulate API delay for large data
    await Future.delayed(
        Duration(milliseconds: 200 + (recordCount ~/ 1000) * 100));

    final users = await generateUsers(recordCount);
    return jsonEncode({
      'users': users,
      'metadata': {
        'total': recordCount,
        'generated_at': DateTime.now().toIso8601String(),
        'version': '1.0'
      }
    });
  }
}
