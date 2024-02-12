// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ecopoly/models/player.dart';

class GameManager {
  static final _instance = GameManager._init();
  factory GameManager() => _instance;

  List<Player> players = const [];
  Player currentPlayer = Player(name: '', money: 0, index: 0);

  GameManager._init() {
    players = [];
    currentPlayer = Player(name: '', money: 0, index: 0);
  }

  void setPlayers(int numberOfPlayers) {
    players = List.generate(
      numberOfPlayers,
      (index) => Player(name: 'Player ${index + 1}', money: 1500, index: index),
    );
  }

  void startGame() {
    print("Game started");
  }

  (int, int) rollDice() {
    var firstDie = Random().nextInt(6) + 1;
    var secondDie = Random().nextInt(6) + 1;
    currentPlayer.position =
        (currentPlayer.position + (firstDie + secondDie)) % 40;
    print(
        "player ${currentPlayer.name} rolled a $firstDie and $secondDie, now at position ${currentPlayer.position}");

    currentPlayer = _nextPlayer();

    return (firstDie, secondDie);
  }

  Player _nextPlayer() {
    return players[(players.indexOf(currentPlayer) + 1) % players.length];
  }

  void endGame() {
    print("Game ended");
  }
}
