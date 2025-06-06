library haptic_visual_cues;

import 'package:vibration/vibration.dart';

class HapticVisualCues {
  /// Short vibration pattern
  static Future<void> vibrateShort() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }
  }

  /// Custom pattern: inhale-exhale haptic
  static Future<void> breathingCue() async {
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      Vibration.vibrate(pattern: [0, 500, 500, 500]);
    } else {
      await vibrateShort();
    }
  }
}