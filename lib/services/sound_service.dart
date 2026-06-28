import 'package:just_audio/just_audio.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = true;

  Future<SoundResult> playSuccessSound() async {
    return await _playSound(Assets.sounds.assetsSoundsRight);
  }

  Future<SoundResult> playFailureSound() async {
    return await _playSound(Assets.sounds.assetsSoundsWrong);
  }

  Future<SoundResult> playSound(String assetPath) async {
    return await _playSound(assetPath);
  }

  Future<SoundResult> _playSound(String assetPath) async {
    if (!_isInitialized) {
      return SoundResult.error('Sound service not available');
    }

    try {
      final isSoundEnabled = await SharedPreferencesStore.getSoundEnabled();
      if (!isSoundEnabled) {
        return SoundResult.disabled();
      }

      await _audioPlayer.stop();
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();

      return SoundResult.success();
    } on PlayerException catch (e) {
      return SoundResult.error(
        'Could not play sound: ${e.message ?? "Unknown error"}',
      );
    } on PlayerInterruptedException catch (e) {
      return SoundResult.error(
        'Sound interrupted: ${e.message ?? "Call or notification"}',
      );
    } catch (e) {
      return SoundResult.error('Sound failed: $e');
    }
  }

  Future<void> stop() async {
    if (!_isInitialized) return;

    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
      _isInitialized = false;
    } catch (_) {}
  }

  Future<void> reset() async {
    if (!_isInitialized) return;

    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.pause();
    } catch (_) {}
  }

  Future<void> setVolume(double volume) async {
    if (!_isInitialized) return;

    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (_) {}
  }
}

class SoundResult {
  final bool isSuccess;
  final bool isDisabled;
  final String? errorMessage;

  SoundResult._({
    required this.isSuccess,
    required this.isDisabled,
    this.errorMessage,
  });

  factory SoundResult.success() =>
      SoundResult._(isSuccess: true, isDisabled: false);

  factory SoundResult.disabled() =>
      SoundResult._(isSuccess: true, isDisabled: true);

  factory SoundResult.error(String message) =>
      SoundResult._(isSuccess: false, isDisabled: false, errorMessage: message);
}
