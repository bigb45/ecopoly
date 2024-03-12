// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/material.dart';

import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/widgets/player_model.dart';

const maxPlayers = 4;

class PlayerNumberSelector extends StatefulWidget {
  final Function(List<Player>) onPlayersChange;
  const PlayerNumberSelector({Key? key, required this.onPlayersChange})
      : super(key: key);

  @override
  State<PlayerNumberSelector> createState() => _PlayerNumberSelectorState();
}

class _PlayerNumberSelectorState extends State<PlayerNumberSelector> {
  int playerCount = 2;
  List<Player> players = [
    Player(name: 'Player 1', color: Colors.red, money: 1000, index: 0),
    Player(name: 'Player 2', color: Colors.blue, money: 1000, index: 0),
  ];
  double containerWidth = 150;

  @override
  void initState() {
    widget.onPlayersChange(players);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: containerWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate((playerCount + 1) ~/ 2, (index) {
                return SizedBox(
                  width: 70,
                  child: GestureDetector(
                    onTap: () {
                      _showPlayerDialog(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          playerModel(
                            players[index].color,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            players[index].name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          if (playerCount > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(playerCount ~/ 2, (index) {
                  final bottomIndex = index + (playerCount + 1) ~/ 2;
                  return SizedBox(
                    width: 70,
                    child: GestureDetector(
                      onTap: () {
                        _showPlayerDialog(bottomIndex);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            playerModel(
                              players[bottomIndex].color,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              players[bottomIndex].name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          IconButton(
            onPressed: playerCount < maxPlayers
                ? () {
                    setState(() {
                      playerCount++;
                      // containerWidth += 40.0;
                      players.add(Player(
                          name: 'Player $playerCount',
                          color: Colors.primaries[playerCount * 2],
                          money: 1000,
                          index: playerCount - 1));

                      widget.onPlayersChange(players);
                    });
                  }
                : null,
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  void _showPlayerDialog(int playerIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title:
            const Text('Player Options', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Change Name',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                _showNameChangeDialog(playerIndex);
              },
            ),
            ListTile(
              title: const Text('Change Color',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showColorPickerDialog(playerIndex, (color) {
                  setState(() {
                    players[playerIndex].color = color;
                  });
                }, players.map((e) => e.color).toList());
              },
            ),
            if (playerCount > 2)
              ListTile(
                title: const Text('Remove Player',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    playerCount--;
                    // containerWidth -= 40.0;
                    players.removeAt(playerIndex);
                    widget.onPlayersChange(players);
                  });
                  Navigator.pop(context); // Close the dialog
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showNameChangeDialog(int playerIndex) {
    String newName = '';
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          // title:
          //     const Text('Change Name', style: TextStyle(color: Colors.white)),
          insetPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: TextFormField(
                onChanged: (value) {
                  newName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  if (value.length > 10) {
                    return 'Name cannot exceed 10 characters';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter new name',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    print("updated player name to $newName");
                    players[playerIndex].name = newName;
                  });
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerDialog(int playerIndex, Function(Color) onColorSelected,
      List<Color> selectedColors) {
    Color? selectedColor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title:
              const Text('Change Color', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: CircleColorPicker(
              pickingPlayerColor: players[playerIndex].color,
              selectedColors: selectedColors,
              colors: Colors.primaries.sublist(3, 15),
              onColorSelected: (color) {
                onColorSelected(color);
                selectedColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  print("updated player color to $selectedColor");
                  // players[playerIndex].color = selectedColor!;
                });
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class CircleColorPicker extends StatefulWidget {
  final List<Color> colors;
  final ValueChanged<Color>? onColorSelected;
  final List<Color> selectedColors;
  final Color pickingPlayerColor;
  const CircleColorPicker({
    Key? key,
    required this.pickingPlayerColor,
    required this.colors,
    this.onColorSelected,
    required this.selectedColors,
  }) : super(key: key);

  @override
  _CircleColorPickerState createState() => _CircleColorPickerState();
}

class _CircleColorPickerState extends State<CircleColorPicker> {
  Color? currentSelection;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 2,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (0.9 / .6),
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.colors.length,
        itemBuilder: (context, index) {
          final color = widget.colors[index];
          final isSelected = widget.selectedColors.contains(color);

          return GestureDetector(
            onTap: () {
              if (widget.onColorSelected != null && !isSelected) {
                widget.onColorSelected!(color);
                setState(() {
                  widget.selectedColors.remove(widget.pickingPlayerColor);

                  currentSelection = color;
                  print("selected color: $color");
                });
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
                shape: BoxShape.circle,
                color: isSelected || color == currentSelection
                    ? color.withOpacity(0.2)
                    : color,
              ),
              child: currentSelection == color
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
