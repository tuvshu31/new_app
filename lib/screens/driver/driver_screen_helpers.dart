import 'dart:async';

import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:geolocator/geolocator.dart';

final player = AudioPlayer();

void playSound(type) async {
  player.play(AssetSource("sounds/$type.wav"));
}

void stopSound() async {
  player.stop();
}
