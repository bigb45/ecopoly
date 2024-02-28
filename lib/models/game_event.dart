import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/models/property.dart';

class GameEvent {
  final String? message;
  final Player firstPlayer;
  Player? secondPlayer;
  final Property? property;
  final EventType type;
  final int? amount;
  GameEvent(
      {required this.message,
      required this.firstPlayer,
      required this.secondPlayer,
      required this.property,
      required this.amount,
      required this.type});
}

enum EventType {
  offerTrade,
  acceptTrade,
  purchase,
  rent,
  tax,
  property,
  jail,
  go,
  goToJail,
  passGo,
  gameStart,
  surprise,
  charity,
}
