class Modul {
  final String id;
  final String name;
  final String? description;
  final String serialId;
  final List<Map<String, dynamic>>? features;
  final String createdAt;
  Modul({
    required this.id,
    required this.name,
    this.description,
    required this.serialId,
    this.features,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Modul && other.id == id; // Cuma compare ID
  }

  @override
  int get hashCode => id.hashCode; // Cuma hash ID
}
