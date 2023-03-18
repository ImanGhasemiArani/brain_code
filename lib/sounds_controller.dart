import 'package:assets_audio_player/assets_audio_player.dart';

import 'app_options.dart';
import 'strs.dart';

class SoundsController {
  static final SoundsController _instance = SoundsController._internal();

  factory SoundsController() => _instance;

  SoundsController._internal() {
    initSounds();
  }

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  void initSounds() {
    _assetsAudioPlayer.open(
      Audio(Strs.urlMusicFile),
      autoStart: !AppOptions().isMute,
      showNotification: true,
      loopMode: LoopMode.single,
      playInBackground: PlayInBackground.disabledRestoreOnForeground,
    );
  }

  void play() {
    _assetsAudioPlayer.play();
  }

  void pause() {
    _assetsAudioPlayer.pause();
  }

  void stop() {
    _assetsAudioPlayer.stop();
  }
}
