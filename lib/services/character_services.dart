import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import '../models/character.dart';
import '../providers/user_selection.dart';

class CharacterService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final logger = Logger();

  Future<List<Character>> fetchRandomCharacters(UserSelection selection) async {
    final snapshot = await _dbRef
        .child(selection.selectedCategoryId ?? '')
        .get();

    if (!snapshot.exists) {
      logger.w('⚠️ Nenhum dado encontrado para essa categoria.');
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
      logger.w('⚠️ Nenhum personagem encontrado após filtragem.');
    }

    allCharacters.shuffle(Random());
    final selected = allCharacters.take(3).toList();

    return selected;
  }

  Future<void> incrementVote(
    String categoryId,
    String characterId,
    String voteType,
  ) async {
    final voteRef = _dbRef.child(
      '$categoryId/items/$characterId/votes/$voteType',
    );

    await voteRef.runTransaction((currentData) {
      final current = (currentData as int?) ?? 0;
      return Transaction.success(current + 1);
    });
  }
}
