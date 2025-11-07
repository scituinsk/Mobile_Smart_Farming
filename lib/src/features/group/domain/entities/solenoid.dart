class Solenoid {
  final String id;
  final String name;
  final bool status;
  final int? group;
  Solenoid({
    required this.id,
    required this.name,
    required this.status,
    this.group,
  });
}
