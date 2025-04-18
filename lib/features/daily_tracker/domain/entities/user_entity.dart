
class UserAuthEntity {

  final String id;
  final String userEmail;
  final String token;
  final int expiresIn;

  UserAuthEntity(this.id, this.userEmail, this.token, this.expiresIn);
}