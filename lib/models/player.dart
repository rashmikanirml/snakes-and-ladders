class Player {
  Player({
    required this.name,
    required this.position,
    required this.colorValue,
  });

  final String name;
  final int colorValue;
  int position;

  Map<String, dynamic> toMap() {
    return {'name': name, 'position': position, 'colorValue': colorValue};
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] as String,
      position: map['position'] as int,
      colorValue: map['colorValue'] as int,
    );
  }
}
