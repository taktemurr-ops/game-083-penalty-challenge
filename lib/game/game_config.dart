import 'package:flutter/material.dart';

import 'package:studio_core/app/arcade_stage.dart';
import 'package:studio_core/app/game_api.dart';
import 'package:studio_core/core/game_rules.dart';
import 'shot_engine.dart';
import 'shot_view.dart';
import 'rules.dart';

final gameConfig = GameConfig(
  gameId: 'game-083-penalty-challenge',
  title: const ['Penaltı Düellosu', 'Penalty Challenge', 'Elfmeter-Duell', 'Desafío de Penaltis', 'Défi Penalty'],
  tagline: const ['At ve kurtar: penaltı serisini kazan!', 'Shoot and save – win the shoot-out!', 'Schießen und halten!', '¡Chuta y para!', 'Tirez et arrêtez !'],
  seedColor: const Color(0xFF0B132B),
  icon: Icons.sports_soccer,
  rules: PenaltyRules(),
  buildPlay: (ctx) => ArcadeStage(
    ctx: ctx,
    create: () => ShotSim((ctx.generated as GeneratedLevel<ShotLevel>).puzzle),
    paint: paintShot,
    sound: shotSound,
    boosterIcon: Icons.back_hand,
    boosterLabel: (l) => l == 'tr' ? 'Süper kaleci' : 'Super keeper',
    howTo: const ['Şut sırası: basılı tut, nişangahı kaleye götür, bırak. Kurtarış sırası: parmağını kalede sürükle, kaleci takip eder.', 'Shooting: hold, move the sight onto the goal, release. Saving: drag in the goal – the keeper follows your finger.', 'Schießen: halten und loslassen. Halten: im Tor ziehen.', 'Tirar: mantén y suelta. Parar: arrastra en la portería.', 'Tir : maintenez et relâchez. Arrêt : glissez dans le but.'],
  ),
  tutorial: const [
    TutorialStep(Icons.gps_fixed, ['Nişangahı köşelere götür ama direğe dikkat.', 'Aim for the corners but mind the posts.', 'Ecken anvisieren.', 'Apunta a las esquinas.', 'Visez les coins.']),
    TutorialStep(Icons.back_hand, ['Kurtarışta kaleciyi topun yönüne sürükle.', 'When saving, drag the keeper toward the shot.', 'Torwart ziehen.', 'Arrastra al portero.', 'Glissez le gardien.']),
    TutorialStep(Icons.emoji_events, ['5 atıştan sonra eşitlikte ani ölüm.', 'Level after 5 kicks: sudden death.', 'Danach Sudden Death.', 'Luego muerte súbita.', 'Puis mort subite.']),
  ],
);
