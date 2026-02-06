import 'package:pak_tani/src/features/profile/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.firstName,
    super.lastName,
    required super.username,
    required super.email,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'image': image,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      image: user.image,
    );
  }

  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      image: image,
    );
  }
}
