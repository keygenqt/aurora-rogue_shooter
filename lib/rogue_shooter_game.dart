import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:rogue_shooter/components/enemy_creator.dart';
import 'package:rogue_shooter/components/player_component.dart';
import 'package:rogue_shooter/components/star_background_creator.dart';

class RogueShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  static const String description = '''
    A simple space shooter game used for testing performance of the collision
    detection system in Flame.
  ''';

  late final PlayerComponent _player;
  late final TextComponent _componentCounter;
  late final TextComponent _scoreText;
  late final AudioPool pool;

  int _score = 0;

  @override
  Future<void> onLoad() async {
    pool = await FlameAudio.createPool(
      'sfx/fire_1.mp3',
      minPlayers: 3,
      maxPlayers: 4,
    );
    add(_player = PlayerComponent());
    addAll([
      FpsTextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
      ),
      _scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      _componentCounter = TextComponent(
        position: size,
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
    ]);

    add(EnemyCreator());
    add(StarBackGroundCreator());
    startBgmMusic();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scoreText.text = 'Score: $_score';
    _componentCounter.text = 'Components: ${children.length}';
  }

  @override
  void onPanStart(_) {
    beginAudioFire();
    _player.beginFire();
  }

  @override
  void onPanEnd(_) {
    _player.stopFire();
  }

  @override
  void onPanCancel() {
    _player.stopFire();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.position += info.delta.global;
  }

  void increaseScore() {
    _score++;
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/bg_music.ogg');
  }

  void beginAudioFire() {
    pool.start();
  }
}
