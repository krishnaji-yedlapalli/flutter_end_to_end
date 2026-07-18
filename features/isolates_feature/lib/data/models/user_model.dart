import 'package:isolates_feature/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.age,
    required super.city,
    required super.salary,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      city: json['city'] as String,
      salary: (json['salary'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'city': city,
      'salary': salary,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      age: age,
      city: city,
      salary: salary,
    );
  }
}
