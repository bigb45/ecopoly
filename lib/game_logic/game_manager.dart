// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ecopoly/models/bike_lane.dart';
import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/city.dart';
import 'package:ecopoly/models/game_event.dart';
import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/models/player_status.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/models/tax.dart';
import 'package:ecopoly/models/utility.dart';
import 'package:ecopoly/util/audio_manager.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/util/trade.dart';
import 'package:flutter/material.dart';
import 'package:ecopoly/models/card.dart';

const gridWidth = 11;

class GameManager extends ChangeNotifier {
  static final _instance = GameManager._init();
  static const jailPosition = 10;
  static const doublesLimit = 3;
  static const startingMoney = 1000;
  factory GameManager() => _instance;
  bool gameStarted = false;
  bool gameEnded = false;
  bool rolledDice = false;
  bool canBuyProperty = false;
  int doublesCount = 0;
  bool infoCardOpen = false;
  int infoCardIndex = 0;
  Player? winner;

  List<GameEvent> gameEvents = [];
  var firstDie = 1;
  var secondDie = 1;
  List<Player> players = const [];
  Player currentPlayer =
      Player(name: '', money: 0, index: -1, color: Colors.blue);

  GameManager._init() {
    print("initializing game manager");
    players = [];
    currentPlayer = Player(name: '', money: 0, index: -1, color: Colors.blue);
  }

  void setPlayers(List<Player> initialPlayers) {
    print("setting players");
    players = List.generate(
      initialPlayers.length,
      (index) => Player(
          name: initialPlayers[index].name,
          money: startingMoney,
          index: index,
          color: initialPlayers[index].color),
    );
  }

  void startGame() {
    AudioManager().playAudio(AudioType.startGame);
    gameEvents.insert(
        0,
        GameEvent(
            message: "",
            firstPlayer: currentPlayer,
            secondPlayer: null,
            amount: null,
            property: null,
            type: EventType.gameStart));
    gameStarted = true;
    currentPlayer = players[0];
    notifyListeners();
    print("Game started");
  }

  (int, int) rollDice() {
    firstDie = Random().nextInt(6) + 1;
    secondDie = Random().nextInt(6) + 1;

    // firstDie = 1;
    // secondDie = 2;
    int prevPosition = currentPlayer.position;
    if (currentPlayer.isInJail) {
      if (currentPlayer.jailTurns == 3 || firstDie == secondDie) {
        currentPlayer.isInJail = false;
        currentPlayer.jailTurns = 0;
        if (firstDie == secondDie) {
          currentPlayer.position =
              (currentPlayer.position + (firstDie + secondDie)) % 40;
          print(
              "player ${currentPlayer.name} rolled a $firstDie and $secondDie");
          updatePosition(firstDie + secondDie);
        }

        endTurn();
        notifyListeners();
      } else {
        currentPlayer.jailTurns++;
        print("player ${currentPlayer.name} failed to roll a double");
        endTurn();
        notifyListeners();
      }
      return (firstDie, secondDie);
    } else {
      currentPlayer.position =
          (currentPlayer.position + (firstDie + secondDie)) % 40;
      print("player ${currentPlayer.name} rolled a $firstDie and $secondDie");
      updatePosition(firstDie + secondDie);

      if (firstDie == secondDie) {
        rolledDice = false;
        doublesCount++;
      } else {
        rolledDice = true;
        doublesCount = 0;
      }
      if (doublesCount == doublesLimit) {
        rolledDice = true;
        doublesCount = 0;
        print(
            "Player ${currentPlayer.name} rolled doubles 3 times in a row, go to jail");
        sendToJail();
        gameEvents.insert(
            0,
            GameEvent(
                message: "",
                firstPlayer: currentPlayer,
                secondPlayer: null,
                amount: null,
                property: null,
                type: EventType.doublesJail));
        return (firstDie, secondDie);
      }
      CellType cellType = board[currentPlayer.position].type;
      _handleNewPlayerPosition(cellType, prevPosition);
      notifyListeners();
      return (firstDie, secondDie);
    }
  }

  void getOutOfJail() {
    currentPlayer.money -= 50;
    AudioManager().playAudio(AudioType.payment);
    print("player ${currentPlayer.name} paid 50 to get out of jail");
    currentPlayer.isInJail = false;
    currentPlayer.jailTurns = 0;
    endTurn();
  }

  void sendToJail() {
    AudioManager().playAudio(AudioType.sendToJail);
    currentPlayer.goToJail();
    canBuyProperty = false;
    endTurn();
  }

  void _handleNewPlayerPosition(CellType cellType, int prevPosition) {
    final isProperty = (cellType == CellType.property ||
        cellType == CellType.city ||
        cellType == CellType.utility ||
        cellType == CellType.bikelane);

    // if the player lands on property that is not owned
    if (isProperty &&
        (board[currentPlayer.position] as Property).owner == null) {
      canBuyProperty = true;
      notifyListeners();
    } else {
      canBuyProperty = false;
      notifyListeners();
    }

    // if the player passes go
    if (prevPosition > currentPlayer.position &&
        currentPlayer.position != 0 &&
        !currentPlayer.isInJail) {
      currentPlayer.money += 200;
      AudioManager().playAudio(AudioType.passGo);
      gameEvents.insert(
        0,
        GameEvent(
            message: "",
            firstPlayer: currentPlayer,
            secondPlayer: null,
            property: null,
            amount: null,
            type: EventType.passGo),
      );
      print("Player ${currentPlayer.name} passed go, received 200");
      notifyListeners();
    }

    // if the player lands on tax
    if (cellType == CellType.tax) {
      int tax = (board[currentPlayer.position] as Tax).amount ??
          ((board[currentPlayer.position] as Tax).percentage! *
                  currentPlayer.money)
              .round();
      currentPlayer.money -= tax;
      AudioManager().playAudio(AudioType.payment);
      gameEvents.insert(
          0,
          GameEvent(
              message: "",
              firstPlayer: currentPlayer,
              secondPlayer: null,
              amount: tax,
              property: null,
              type: EventType.tax));
      notifyListeners();
      return;
    }

    // if the player lands on property that is owned by another player
    if (isProperty &&
        (board[currentPlayer.position] as Property).owner != null) {
      Property property = board[currentPlayer.position] as Property;
      int rent = 0;
      Player owner = property.owner!;
      if (owner != currentPlayer) {
        if (property.type == CellType.utility) {
          rent = (property as Utility)
              .calculateRent(diceValue: firstDie + secondDie);
        } else if (property.type == CellType.bikelane) {
          rent = (property as BikeLane).calculateRent();
          currentPlayer.payRent(rent);
          owner.receiveRent(rent);
        } else {
          rent = property.calculateRent();
          currentPlayer.payRent(rent);
          owner.receiveRent(rent);
        }
        currentPlayer.payRent(rent);
        AudioManager().playAudio(AudioType.payment);
        owner.receiveRent(rent);
        print(
            "Player ${currentPlayer.name} landed on ${property.name}, paid $rent to ${owner.name}");
        gameEvents.insert(
            0,
            GameEvent(
                message:
                    "Player ${currentPlayer.name} landed on ${property.name}, paid $rent to ${owner.name}",
                firstPlayer: currentPlayer,
                secondPlayer: owner,
                property: property,
                amount: rent,
                type: EventType.rent));
      }

      notifyListeners();
      return;
    }

    // if the player lands on go to jail
    if (cellType == CellType.goToJail) {
      sendToJail();
      print("Player ${currentPlayer.name} landed on go to jail");
      gameEvents.insert(
          0,
          GameEvent(
              message: "",
              firstPlayer: currentPlayer,
              secondPlayer: null,
              amount: null,
              property: null,
              type: EventType.goToJail));
      notifyListeners();
      return;
    }

    // if the player lands on go
    if (cellType == CellType.start) {
      currentPlayer.money += 300;
      AudioManager().playAudio(AudioType.passGo);
      print("Player ${currentPlayer.name} landed on go, received 300");
      gameEvents.insert(
          0,
          GameEvent(
              message: "",
              firstPlayer: currentPlayer,
              secondPlayer: null,
              amount: null,
              property: null,
              type: EventType.go));
      notifyListeners();
      return;
    }

    // if the player lands on a chance
    if (cellType == CellType.chance) {
      GameCard card = drawSurpriseCard();
      currentPlayer.money += card.amount;
      gameEvents.insert(
          0,
          GameEvent(
              message: card.description,
              firstPlayer: currentPlayer,
              secondPlayer: null,
              property: null,
              amount: card.amount,
              type: EventType.surprise));
      notifyListeners();
      return;
    }

    // if the player lands on a charity
    if (cellType == CellType.charity) {
      GameCard card = drawCharityCard();
      currentPlayer.money += card.amount;
      gameEvents.insert(
          0,
          GameEvent(
              message: card.description,
              firstPlayer: currentPlayer,
              secondPlayer: null,
              property: null,
              amount: card.amount,
              type: EventType.charity));
      notifyListeners();
      return;
    }
  }

  void openInfoCard(int index) {
    infoCardOpen = true;
    infoCardIndex = index;
    notifyListeners();
  }

  void closeInfoCard() {
    infoCardOpen = false;
    notifyListeners();
  }

  GameCard drawCharityCard() {
    AudioManager().playAudio(AudioType.cardDraw);
    int charityCardIndex = Random().nextInt(chanceCards.length);
    print(
        "Player ${currentPlayer.name} drew a chance card, ${chanceCards[charityCardIndex].description}");
    return chanceCards[charityCardIndex];
  }

  GameCard drawSurpriseCard() {
    AudioManager().playAudio(AudioType.cardDraw);

    int surpriseCardIndex = Random().nextInt(surpriseCards.length);
    print(
        "Player ${currentPlayer.name} drew a chance card, ${surpriseCards[surpriseCardIndex].description}");
    return surpriseCards[surpriseCardIndex];
  }

  void addTrade({required Trade trade}) {
    gameEvents.insert(
        0,
        GameEvent(
            message: "",
            firstPlayer: trade.tradingPlayer,
            secondPlayer: trade.receivingPlayer,
            amount: null,
            property: null,
            type: EventType.offerTrade));
    print("added trade $trade");
    notifyListeners();
  }

  void buyProperty() {
    AudioManager().playAudio(AudioType.purchase);

    Property property = board[currentPlayer.position] as Property;

    canBuyProperty = false;

    currentPlayer.buyProperty(property);

    gameEvents.insert(
        0,
        GameEvent(
            message: "",
            firstPlayer: currentPlayer,
            secondPlayer: null,
            amount: null,
            property: board[currentPlayer.position] as Property,
            type: EventType.purchase));
    notifyListeners();
  }

  void sellProperty(Property property) {
    if (property.trees == 0) {
      currentPlayer.sellProperty(property);
      AudioManager().playAudio(AudioType.sellProperty);
      gameEvents.insert(
          0,
          GameEvent(
              message: "",
              firstPlayer: currentPlayer,
              secondPlayer: null,
              amount: null,
              property: property,
              type: EventType.sell));
      notifyListeners();
    }
  }

  void endTurn() {
    currentPlayer = _nextPlayer();
    rolledDice = false;
    canBuyProperty = false;
    doublesCount = 0;
    notifyListeners();
  }

  void quit(int playerIndex) {
    Player player = players.firstWhere((player) => player.index == playerIndex);
    player.quit();
    endTurn();
    players.remove(player);

    if (players.length == 1) {
      endGame();
      gameEnded = true;
      notifyListeners();
    }
  }

  Player _nextPlayer() {
    if (!gameEnded) {
      Player nextPlayer =
          players[(players.indexOf(currentPlayer) + 1) % players.length];
      return nextPlayer;
    }
    return Player(name: "Ended", money: 0, index: -1, color: Colors.red);
  }

  void endGame() {
    winner = players[0];
    print("Game ended");
  }

  void updatePosition(steps) {
    currentPlayer.movePlayer(steps: steps);

    notifyListeners();
  }

  void plantTree(City city) {
    if (currentPlayer.money > city.treeCost) {
      print("Player ${currentPlayer.name} planted a tree in ${city.name}");
      currentPlayer.plantTree(city);
      AudioManager().playAudio(AudioType.plantTree);
      notifyListeners();
    }
  }

  void destroyTree(City city) {
    if (city.trees > 0) {
      AudioManager().playAudio(AudioType.removeTree);
      currentPlayer.destroyTree(city);
    }

    notifyListeners();
  }

  int getIndex(int x, int y) {
    if (y <= x) {
      return x + y;
    } else if (y > x && x != 0) {
      return gridWidth + y + (gridWidth - x - 1) - 1;
    } else if (y > x && x == 0) {
      return (3 * gridWidth - 3) + (gridWidth - y) - 1;
    }
    return 0;
  }
}
