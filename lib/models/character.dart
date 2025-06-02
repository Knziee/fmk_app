class Character {
  final String id;
  final String name;
  final String gender;
  final String imageUrl;
  final Map<String, int> votes;

  Character({
    required this.id,
    required this.name,
    required this.gender,
    required this.imageUrl,
    required this.votes,
  });

  factory Character.fromMap(Map<dynamic, dynamic> map) {
    return Character(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      imageUrl: map['imageUrl'],
      votes: Map<String, int>.from(map['votes'] ?? {}),
    );
  }
}
