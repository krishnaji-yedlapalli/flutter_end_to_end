class ProfileEntity {
  ProfileEntity(this.id, this.name, {this.isSelected = false});

  final String id;

  final String name;

  bool isSelected;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
