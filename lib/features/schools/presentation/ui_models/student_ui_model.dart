import 'package:equatable/equatable.dart';

class StudentUiModel extends Equatable {
  final String id;
  final String name;
  final String standard;
  final String location;
  final String section;

  const StudentUiModel({
    required this.id,
    required this.name,
    required this.standard,
    required this.location,
    required this.section,
  });

  StudentUiModel copyWith({
    String? id,
    String? name,
    String? standard,
    String? location,
    String? section,
  }) {
    return StudentUiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      standard: standard ?? this.standard,
      location: location ?? this.location,
      section: section ?? this.section,
    );
  }

  @override
  List<Object?> get props => [id, name, standard, location, section];
}
