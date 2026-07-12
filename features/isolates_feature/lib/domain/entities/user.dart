class User {
  final int id;
  final String name;
  final String email;
  final int age;
  final String city;
  final double salary;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.city,
    required this.salary,
  });

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, age: $age, city: $city, salary: $salary)';
}
