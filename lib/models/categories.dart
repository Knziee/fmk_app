class Category {
  final String id;
  final String title;
  final String emoji;

  Category({required this.id, required this.title, required this.emoji});

  factory Category.fromMap(Map<dynamic, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      emoji: map['emoji'] ?? '',
    );
  }
}
