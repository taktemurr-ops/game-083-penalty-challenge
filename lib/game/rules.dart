import 'package:studio_core/core/arcade.dart';
import 'package:studio_core/core/level_plan.dart';
import 'package:studio_core/core/missions.dart';
import 'package:studio_core/core/stats.dart';
import 'shot_engine.dart';

class PenaltyRules extends ArcadeRules<ShotLevel> {
  @override
  String get gameId => 'game-083-penalty-challenge';

  @override
  List<String> get optionalMechanics => const [];

  @override
  List<GameStat> get gameStats => const [
        GameStat('goals_scored', 'Atılan penaltı golü', 'Penalty goals', scale: 150),
        GameStat('saves', 'Kurtarış', 'Saves', scale: 100),
        GameStat('shootouts_won', 'Kazanılan seri', 'Shoot-outs won', scale: 30),
        GameStat('shots_taken', 'Yapılan atış', 'Shots taken', scale: 300),
      ];

  @override
  List<MissionTemplate> get missionTemplates => const [
        MissionTemplate('goals_scored', 'goals_scored', [37, 75, 150]),
        MissionTemplate('saves', 'saves', [12, 25, 50], coinReward: 80),
      ];

  @override
  ShotLevel generate(LevelSpec spec) => generateShot(ShotKind.penalty, spec);

  @override
  ArcadeMeta metaOf(ShotLevel l) => l.meta;

  @override
  ArcadeSim createSim(ShotLevel l) => ShotSim(l);

  @override
  ArcadeInput bot(ArcadeSim sim) => shotBot(sim);
}

ArcadeRules createRules() => PenaltyRules();
