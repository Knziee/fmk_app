import 'package:firebase_database/firebase_database.dart';
import '../models/categories.dart';

class CategoryService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<List<Category>> fetchCategories() async {
    final snapshot = await _dbRef.get();

    if (!snapshot.exists) return [];

    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

    List<Category> categories = [];

    data.forEach((key, value) {
      if (value is Map && value.containsKey('id')) {
        categories.add(Category.fromMap(value));
      }
    });

    return categories;
  }
}
