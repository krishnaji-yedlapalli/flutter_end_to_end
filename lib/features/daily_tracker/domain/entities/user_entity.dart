class UserAuthEntity {
  final String id;
  final String userEmail;
  final String token;
  final int expiresIn;

  UserAuthEntity(this.id, this.userEmail, this.token, this.expiresIn);

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userEmail': userEmail,
      'token': token,
      'expiresIn': expiresIn,
    };
  }

  // Create an instance from JSON
  factory UserAuthEntity.fromJson(Map<String, dynamic> json) {
    return UserAuthEntity(
      json['id'] as String,
      json['userEmail'] as String,
      json['token'] as String,
      json['expiresIn'] as int,
    );
  }
}
