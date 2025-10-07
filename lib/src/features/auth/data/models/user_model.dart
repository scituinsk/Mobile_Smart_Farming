import 'package:pak_tani/src/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.id,
    required super.firstName,
    super.lastName,
    required super.username,
    required super.email,
    super.avatar,
    super.photo,
    super.modulCount,
    super.penjadwalanCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      photo: json['photo'],
      modulCount: json['modul_count'],
      penjadwalanCount: json['penjadwalan_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'avatar': avatar,
      'photo': photo,
      'modul_count': modulCount,
      'penjadwalan_count': penjadwalanCount,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      avatar: user.avatar,
      photo: user.photo,
      modulCount: user.modulCount,
      penjadwalanCount: user.penjadwalanCount,
    );
  }

  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      avatar: avatar,
      photo: photo,
      modulCount: modulCount,
      penjadwalanCount: penjadwalanCount,
    );
  }
}
