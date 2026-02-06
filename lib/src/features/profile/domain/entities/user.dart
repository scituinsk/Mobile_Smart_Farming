import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String? lastName;
  final String username;
  final String email;
  final String? image;

  User({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.username,
    required this.email,
    this.image,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, firstName, lastName, username, email, image];
}
