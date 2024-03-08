import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/widgets/player_model.dart';
import 'package:flutter/material.dart';

const maxPlayers = 4;

class PlayerNumberSelector extends StatefulWidget {
  final Function(int) onPlayerNumberChange;
  const PlayerNumberSelector({Key? key, required this.onPlayerNumberChange})
      : super(key: key);

  @override
  State<PlayerNumberSelector> createState() => _PlayerNumberSelectorState();
}

class _PlayerNumberSelectorState extends State<PlayerNumberSelector> {
  int playerCount = 2;
  List<Player> players = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...List.generate(playerCount, (index) {
          return GestureDetector(
            onTap: () {
              _showPlayerDialog(index);
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: playerModel(
                Colors.blue,
              ),
            ),
          );
        }),
        IconButton(
          onPressed: playerCount < maxPlayers
              ? () {
                  setState(() {
                    playerCount++;
                    widget.onPlayerNumberChange(playerCount);
                  });
                }
              : null,
          icon: const Icon(Icons.add),
          color: Colors.white,
        ),
      ],
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
                Navigator.pop(context); // Close the dialog
                _showColorPickerDialog(playerIndex);
              },
            ),
            if (playerCount >
                1) // Allow removing player if there are more than 1 player
              ListTile(
                title: const Text('Remove Player',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    playerCount--;
                    widget.onPlayerNumberChange(playerCount);
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title:
              const Text('Change Name', style: TextStyle(color: Colors.white)),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter new name',
              hintStyle: TextStyle(color: Colors.white),
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
                  print("updated player name to $newName");
                  // players[playerIndex].name = newName;
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

  void _showColorPickerDialog(int playerIndex) {
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
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
                Colors.orange,
                Colors.purple,
                Colors.teal,
                Colors.pink,
              ],
              onColorSelected: (color) {
                selectedColor = color;
                print("new color: $selectedColor");
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
                  // Update player color
                  // Replace currentPlayerColor with the actual player color property
                  players[playerIndex].color = selectedColor!;
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

class CircleColorPicker extends StatelessWidget {
  final List<Color> colors;
  final ValueChanged<Color>? onColorSelected;

  const CircleColorPicker({
    Key? key,
    required this.colors,
    this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            if (onColorSelected != null) {
              onColorSelected!(color);
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
