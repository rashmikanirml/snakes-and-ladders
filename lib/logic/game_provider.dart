import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/player.dart';
import 'board_config.dart';

class GameProvider extends ChangeNotifier {
  static const String _settingsSoundKey = 'sound_enabled';
  static const String _savedGameKey = 'saved_game';

  final Random _random = Random();

  List<Player> _players = <Player>[];
  int _currentPlayerIndex = 0;
  int _lastDiceValue = 1;
  bool _isRolling = false;
  bool _soundEnabled = true;
  int? _winnerIndex;

  List<Player> get players => _players;
  int get currentPlayerIndex => _currentPlayerIndex;
  int get lastDiceValue => _lastDiceValue;
  bool get isRolling => _isRolling;
  bool get soundEnabled => _soundEnabled;
  int? get winnerIndex => _winnerIndex;
  bool get hasActiveGame => _players.isNotEmpty && _winnerIndex == null;

  Player? get currentPlayer {
    if (_players.isEmpty) {
      return null;
    }
    return _players[_currentPlayerIndex];
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool(_settingsSoundKey) ?? true;
    await _loadSavedGame();
    notifyListeners();
  }

  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_settingsSoundKey, value);
    notifyListeners();
  }

  Future<void> startNewGame(List<String> playerNames) async {
    const List<int> colorValues = <int>[
      0xFFE53935,
      0xFF1E88E5,
      0xFF43A047,
      0xFFF9A825,
    ];

    _players = playerNames.asMap().entries.map((MapEntry<int, String> entry) {
      return Player(
        name: entry.value,
        position: 0,
        colorValue: colorValues[entry.key % colorValues.length],
      );
    }).toList();

    _currentPlayerIndex = 0;
    _lastDiceValue = 1;
    _winnerIndex = null;
    await _saveGame();
    notifyListeners();
  }

  Future<void> resetGame() async {
    _players = <Player>[];
    _currentPlayerIndex = 0;
    _lastDiceValue = 1;
    _winnerIndex = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedGameKey);
    notifyListeners();
  }

  Future<void> rollDice() async {
    if (_isRolling || _players.isEmpty || _winnerIndex != null) {
      return;
    }

    _isRolling = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 350));

    _lastDiceValue = _random.nextInt(6) + 1;
    final Player player = _players[_currentPlayerIndex];

    int newPosition = player.position + _lastDiceValue;
    if (newPosition <= BoardConfig.winningPosition) {
      player.position = newPosition;

      if (BoardConfig.snakesAndLadders.containsKey(player.position)) {
        player.position = BoardConfig.snakesAndLadders[player.position]!;
      }
    }

    if (player.position == BoardConfig.winningPosition) {
      _winnerIndex = _currentPlayerIndex;
      if (_soundEnabled) {
        await SystemSound.play(SystemSoundType.alert);
      }
    } else {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
      if (_soundEnabled) {
        await SystemSound.play(SystemSoundType.click);
      }
    }

    _isRolling = false;
    await _saveGame();
    notifyListeners();
  }

  Future<void> _saveGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_players.isEmpty) {
      await prefs.remove(_savedGameKey);
      return;
    }

    final Map<String, dynamic> data = <String, dynamic>{
      'players': _players.map((Player player) => player.toMap()).toList(),
      'currentPlayerIndex': _currentPlayerIndex,
      'lastDiceValue': _lastDiceValue,
      'winnerIndex': _winnerIndex,
    };

    await prefs.setString(_savedGameKey, jsonEncode(data));
  }

  Future<void> _loadSavedGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_savedGameKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;
      final List<dynamic> rawPlayers = data['players'] as List<dynamic>;
      _players = rawPlayers
          .map((dynamic item) => Player.fromMap(item as Map<String, dynamic>))
          .toList();
      _currentPlayerIndex = data['currentPlayerIndex'] as int;
      _lastDiceValue = data['lastDiceValue'] as int;
      _winnerIndex = data['winnerIndex'] as int?;
    } catch (_) {
      _players = <Player>[];
      _currentPlayerIndex = 0;
      _lastDiceValue = 1;
      _winnerIndex = null;
      await prefs.remove(_savedGameKey);
    }
  }
}
