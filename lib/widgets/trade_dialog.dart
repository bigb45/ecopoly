// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:ecopoly/models/player.dart';
import 'package:flutter/material.dart';

class TradeDialog extends StatefulWidget {
  final Player currentPlayer;
  final Player targetPlayer;

  const TradeDialog({
    Key? key,
    required this.currentPlayer,
    required this.targetPlayer,
  }) : super(key: key);

  @override
  State<TradeDialog> createState() => _TradeDialogState();
}

class _TradeDialogState extends State<TradeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.swap_horiz,
        size: 36,
      ),
      scrollable: true,
      actions: [
        ElevatedButton(
          onPressed: null,
          child: Text("Offer"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
      title: Text(
        "Trade Offer",
        textAlign: TextAlign.center,
      ),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlayerPropertiesList(
                player: widget.currentPlayer,
                isTrading: true,
              ),
              SizedBox(
                width: 10,
              ),
              PlayerPropertiesList(
                player: widget.targetPlayer,
                isTrading: false,
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
  const PlayerPropertiesList({
    Key? key,
    required this.player,
    required this.isTrading,
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
        color: Colors.grey[400],
      ),
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Text("\$$selectedMoney"),
            Slider(
              value: selectedMoney.toDouble(),
              onChanged: (value) {
                setState(() {
                  selectedMoney = value.toInt();
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
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
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
    );
  }
}
