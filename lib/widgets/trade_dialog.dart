// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:ecopoly/util/trade.dart';
import 'package:ecopoly/widgets/game_button.dart';
import 'package:flutter/material.dart';

import 'package:ecopoly/models/player.dart';

class TradeDialog extends StatefulWidget {
  final Player currentPlayer;
  final Player targetPlayer;
  final Function onTradeCompleted;
  const TradeDialog({
    Key? key,
    required this.currentPlayer,
    required this.targetPlayer,
    required this.onTradeCompleted,
  }) : super(key: key);

  @override
  State<TradeDialog> createState() => _TradeDialogState();
}

class _TradeDialogState extends State<TradeDialog> {
  Set<int> currentSelectedIndexes = {};
  Set<int> targetSelectedIndexes = {};
  int currentSelectedMoney = 0;
  int targetSelectedMoney = 0;
  bool isTradeValid = false;
  bool validateTrade() {
    if (currentSelectedIndexes.isNotEmpty ||
        targetSelectedIndexes.isNotEmpty ||
        currentSelectedMoney > 0 ||
        targetSelectedMoney > 0) {
      isTradeValid = true;
      return true;
    }
    isTradeValid = false;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      icon: Icon(
        Icons.swap_horiz,
        size: 36,
        color: Colors.white,
      ),
      scrollable: true,
      actions: [
        GameButton(
          onPressed: isTradeValid
              ? () {
                  widget.onTradeCompleted(Trade(
                    tradingPlayer: widget.currentPlayer,
                    receivingPlayer: widget.targetPlayer,
                    firstPlayerProperties: currentSelectedIndexes
                        .map((e) => widget.currentPlayer.properties[e])
                        .toSet(),
                    secondPlayerProperties: targetSelectedIndexes
                        .map((e) => widget.targetPlayer.properties[e])
                        .toSet(),
                    firstPlayerMoney: currentSelectedMoney,
                    secondPlayerMoney: targetSelectedMoney,
                  ));

                  print(
                      "trading: ${currentSelectedIndexes.map((e) => widget.currentPlayer.properties[e].name)} for ${targetSelectedIndexes.map((e) => widget.targetPlayer.properties[e].name)}, money: $currentSelectedMoney, $targetSelectedMoney");
                  Navigator.of(context).pop();
                }
              : null,
          childText: "Offer",
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
      title: Text(
        "Trade Offer",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlayerPropertiesList(
                player: widget.currentPlayer,
                isTrading: true,
                onSelectionChanged: (selectedIndexes) {
                  setState(() {
                    currentSelectedIndexes = selectedIndexes;
                    validateTrade();
                  });
                },
                onMoneyChanged: (selectedMoney) {
                  setState(() {
                    currentSelectedMoney = selectedMoney;
                    validateTrade();
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              PlayerPropertiesList(
                player: widget.targetPlayer,
                isTrading: false,
                onSelectionChanged: (selectedIndexes) {
                  setState(() {
                    targetSelectedIndexes = selectedIndexes;
                    validateTrade();
                  });
                },
                onMoneyChanged: (selectedMoney) {
                  setState(() {
                    targetSelectedMoney = selectedMoney;
                    validateTrade();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerPropertiesList extends StatefulWidget {
  final Player player;
  final bool isTrading;
  final Function(Set<int>) onSelectionChanged; // New callback function
  final Function(int) onMoneyChanged; // New callback function
  const PlayerPropertiesList({
    Key? key,
    required this.player,
    required this.isTrading,
    required this.onSelectionChanged,
    required this.onMoneyChanged,
  }) : super(key: key);

  @override
  State<PlayerPropertiesList> createState() => _PlayerPropertiesListState();
}

class _PlayerPropertiesListState extends State<PlayerPropertiesList> {
  Set<int> selectedIndexes = {};
  int selectedMoney = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade900,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              0.6, // Adjust the height as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  widget.isTrading ? "Your Properties" : "Their Properties",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 8),
              Text("\$$selectedMoney", style: TextStyle(color: Colors.white)),
              Slider(
                value: selectedMoney.toDouble(),
                onChanged: (value) {
                  setState(() {
                    selectedMoney = value.toInt();
                    widget.onMoneyChanged(selectedMoney);
                  });
                },
                max: widget.player.money.toDouble(),
                min: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      widget.player.properties.length,
                      (index) {
                        final property = widget.player.properties[index];
                        final isSelected = selectedIndexes.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedIndexes.remove(index);
                              } else {
                                selectedIndexes.add(index);
                              }
                              widget.onSelectionChanged(selectedIndexes);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.deepPurple[300]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.purpleAccent
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.asset(
                                    property.imageName,
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  property.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
