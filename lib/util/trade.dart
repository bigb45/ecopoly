// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/models/property.dart';

class Trade {
  final Set<Property> firstPlayerProperties;
  final int firstPlayerMoney;
  final Set<Property> secondPlayerProperties;
  final int secondPlayerMoney;
  final Player tradingPlayer;
  final Player receivingPlayer;

  const Trade({
    required this.firstPlayerProperties,
    required this.firstPlayerMoney,
    required this.secondPlayerProperties,
    required this.secondPlayerMoney,
    required this.tradingPlayer,
    required this.receivingPlayer,
  });
}
