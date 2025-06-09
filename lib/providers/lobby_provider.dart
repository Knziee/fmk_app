import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/player.dart';
import '../services/multiplayer_service.dart';

class LobbyProvider extends ChangeNotifier {
  String? lobbyCode;
  String? localPlayerId;
  Player? localPlayer;
  List<Player> players = [];
  bool isHost = false;
  bool isStarted = false;
  String? categoryId;
  String? selectedGender;
  List<Character> lobbyCharacters = [];

  final _service = MultiplayerService();
  Stream<List<Player>>? _playersStream;

  Future<void> createLobby(
    Player player,
    String selectedCategoryId,
    String selectedGender,
  ) async {
    final code = await _service.createLobby(
      player,
      selectedCategoryId,
      selectedGender,
    );

    await _service.setHost(code, player.id);

    lobbyCode = code;
    localPlayer = Player(
      id: player.id,
      nickname: player.nickname,
      avatarId: player.avatarId,
      choices: player.choices,
      ready: player.ready,
      isHost: true,
    );
    isHost = true;
    categoryId = selectedCategoryId;
    this.selectedGender = selectedGender;

    _subscribeToPlayers();
  }

  Future<bool> joinLobby(String code, Player player) async {
    final result = await _service.joinLobby(code, player);
    if (!result.success) return false;

    categoryId = result.categoryId;
    selectedGender = result.gender;
    lobbyCode = code;
    localPlayer = player;
    isHost = false;

    notifyListeners();

    _subscribeToPlayers();
    return true;
  }

  Player? firstWhereOrNull(List<Player> list, bool Function(Player) test) {
    for (var element in list) {
      if (test(element)) return element;
    }
    return null;
  }

  void _subscribeToPlayers() {
    _playersStream = _service.watchPlayers(lobbyCode!);
    _playersStream!.listen((updatedPlayers) {
      players = updatedPlayers;

      final currentHost = firstWhereOrNull(players, (p) => p.isHost);
      if (currentHost == null && players.isNotEmpty) {
        players[0].isHost = true;
      }
      notifyListeners();
    });
  }

  Stream<bool> watchAllPlayersVoted() {
    if (lobbyCode == null) return const Stream.empty();
    return _service.watchAllPlayersVoted(lobbyCode!);
  }

  Future<void> updateChoices(Map<String, String> choices) async {
    if (lobbyCode == null || localPlayer == null) return;
    await _service.updateChoices(lobbyCode!, localPlayer!.id, choices);
  }

  Future<void> setReady(bool ready) async {
    if (lobbyCode == null || localPlayer == null) return;
    await _service.setReady(lobbyCode!, localPlayer!.id, ready);
  }

  Future<void> fetchFinalResults() async {
    if (lobbyCode == null) return;
    players = await _service.getFinalLobbyData(lobbyCode!);
    notifyListeners();
  }

  Future<void> leaveLobby() async {
    if (lobbyCode != null && localPlayer != null) {
      await _service.removePlayerFromLobby(lobbyCode!, localPlayer!.id);
    }
    lobbyCode = null;
    localPlayerId = null;
    localPlayer = null;
    players = [];
    isHost = false;
    _playersStream = null;
    notifyListeners();
  }

  Future<void> resetReadyAndChoicesForAll() async {
    if (lobbyCode == null) return;
    await _service.resetReadyAndChoicesForAllPlayers(lobbyCode!);
  }

  Future<void> saveRandomCharacters(List<Character> characters) async {
    if (lobbyCode == null) return;
    await _service.saveRandomCharacters(lobbyCode!, characters);
  }

  Future<void> fetchLobbyCharacters() async {
    if (lobbyCode == null) return;
    final fetched = await _service.fetchLobbyCharacters(lobbyCode!);
    lobbyCharacters = fetched;
    notifyListeners();
  }

  // Stream<List<Character>> watchLobbyCharacters() {
  //   if (lobbyCode == null) return const Stream.empty();
  //   return _service.watchLobbyCharacters(lobbyCode!);
  // }
}
