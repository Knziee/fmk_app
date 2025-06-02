import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import '../models/character.dart';
import '../providers/user_selection.dart';

class CharacterService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<List<Character>> fetchRandomCharacters(UserSelection selection) async {
    final snapshot = await _dbRef
        .child(selection.selectedCategoryId ?? '')
        .get();

    if (!snapshot.exists) {
      print('⚠️ Nenhum dado encontrado para essa categoria.');
      return [];
    }

    final data = snapshot.value as Map<dynamic, dynamic>;
    final List<Character> allCharacters = [];

    if (data['items'] != null) {
      final itemsMap = data['items'] as Map<dynamic, dynamic>;

      for (var item in itemsMap.values) {
        final character = Character.fromMap(item);

        if (selection.selectedGender == null ||
            selection.selectedGender == 'both' ||
            character.gender == selection.selectedGender) {
          allCharacters.add(character);
        }
      }
    }

    if (allCharacters.isEmpty) {
      print('⚠️ Nenhum personagem encontrado após filtragem.');
    }

    allCharacters.shuffle(Random());
    final selected = allCharacters.take(3).toList();

    return selected;
  }
}
