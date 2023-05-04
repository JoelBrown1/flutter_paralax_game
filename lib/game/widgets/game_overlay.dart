import 'dart:io';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../doodle_dash.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});
  final Game game;

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            child: ElevatedButton(
              child: isPaused
                  ? const Icon(
                      Icons.play_arrow,
                      size: 48,
                    )
                  : const Icon(
                      Icons.pause,
                      size: 48,
                    ),
              onPressed: () {
                // (widget.game as DoodleDash).togglePauseState();
                setState(
                  () {
                    isPaused = !isPaused;
                  },
                );
              },
            ),
          ),
          if (isPaused)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 72,
              right: MediaQuery.of(context).size.width / 2 - 72,
              child: const Icon(
                Icons.pause_circle,
                size: 144,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}
