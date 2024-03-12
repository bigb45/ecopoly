// ignore_for_file: avoid_print

import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static AudioManager? _instance;
  late AudioPlayer _audioPlayer;

  AudioManager._internal() {
    _audioPlayer = AudioPlayer();
  }

  factory AudioManager() {
    _instance ??= AudioManager._internal();
    return _instance!;
  }

  Future<void> playAudio(AudioType audio) async {
    try {
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.stop();
      }

      // Load and play the audio file
      final audioPath = _getAudioPath(audio);
      final audioAsset = AudioCache();
      await audioAsset.load("audio/$audioPath");
      await _audioPlayer.play(AssetSource("audio/$audioPath"));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      // Stop audio playback
      await _audioPlayer.stop();
    } catch (e) {
      // Handle any errors that occur while stopping playback
      print('Error stopping audio: $e');
    }
  }

  String _getAudioPath(AudioType audioType) {
    switch (audioType) {
      case AudioType.purchase:
        return "purchase.wav";
      case AudioType.payment:
        return "pay.wav";
      case AudioType.diceRoll:
        return "dice_roll.wav";

      case AudioType.sendToJail:
        return "go_to_jail.wav";
      case AudioType.cardDraw:
        return "card_draw.wav";
      case AudioType.passGo:
        return "pass_go.wav";
      case AudioType.sellProperty:
        return "sell_property.wav";
      case AudioType.plantTree:
        return "plant_tree.wav";
      case AudioType.removeTree:
        return "remove_tree.wav";
      case AudioType.startGame:
        return "game_start.wav";
    }
  }
}

enum AudioType {
  payment,
  purchase,
  diceRoll,
  sendToJail,
  cardDraw,
  passGo,
  sellProperty,
  plantTree,
  removeTree,
  startGame,
}
