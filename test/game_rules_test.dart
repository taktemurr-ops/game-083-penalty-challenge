import 'package:flutter_test/flutter_test.dart';
import 'package:game_083_penalty_challenge/core/arcade.dart';
import 'package:game_083_penalty_challenge/core/level_plan.dart';
import 'package:game_083_penalty_challenge/game/rules.dart';
import 'package:game_083_penalty_challenge/game/shot_engine.dart';

void main() {
  final rules = PenaltyRules();
  final planner = LevelPlanner(gameId: rules.gameId, optionalMechanics: rules.optionalMechanics);

  ShotSim fresh([int n = 1]) => ShotSim(rules.build(planner.spec(n)).puzzle);

  test('drag and release fires a shot, a tiny tap does not', () {
    final s = fresh();
    if (s.usesReticle) {
      s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 0, reason: 'too short a hold');
      for (var i = 0; i < 10; i++) {
        s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      }
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 1);
    } else {
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 503, y: 805));
      s.tick(const ArcadeInput(down: false, x: 503, y: 805));
      expect(s.shots, 0, reason: 'too short a drag');
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 500, y: 1000));
      s.tick(const ArcadeInput(down: false, x: 500, y: 1000));
      expect(s.shots, 1);
      expect(s.phase, 1);
    }
  });

  test('failing a round costs a life and restarts the same layout', () {
    final s = fresh(3);
    final before = s.goalText;
    s.roundFailed();
    expect(s.lives, 2);
    expect(s.goalText, before);
    expect(s.over, isFalse);
  });

  test('autopilot clears the first ten levels without losing a life', () {
    for (var n = 1; n <= 10; n++) {
      final s = fresh(n);
      final r = runBot(s, rules.bot, 60 * 60 * 6);
      expect(r.won, isTrue, reason: 'level $n');
      expect(s.stars, greaterThanOrEqualTo(1));
    }
  });

  test('penalty: a shot outside the posts misses, a saved shot does not count', () {
    final s = fresh() as PenaltySim;
    s.phase = 1;
    s.phaseTicks = 0;
    s.tgtX = 120;
    s.tgtY = 500;
    s.flyT = 5;
    for (var i = 0; i < 6; i++) {
      s.tick(ArcadeInput.idle);
    }
    expect(s.myGoals, 0);
    expect(s.myKicks, 1);
    // rival shot straight at the keeper
    expect(s.shooting, isFalse);
    s.tgtX = 500;
    s.tgtY = 600;
    for (var i = 0; i < 120 && s.cpuKicks == 0; i++) {
      s.tick(const ArcadeInput(down: true, x: 500, y: 600));
    }
    expect(s.cpuGoals, 0);
  });
}
