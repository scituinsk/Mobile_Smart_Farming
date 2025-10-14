class User {
  final String? id;
  final String firstName;
  final String? lastName;
  final String username;
  final String email;
  final String? image;
  final String? photo;
  final int? modulCount;
  final int? penjadwalanCount;

  User({
    this.id,
    required this.firstName,
    this.lastName,
    required this.username,
    required this.email,
    this.image,
    this.photo,
    this.penjadwalanCount,
    this.modulCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id; // Cuma compare ID
  }

  @override
  int get hashCode => id.hashCode; // Cuma hash ID
}
