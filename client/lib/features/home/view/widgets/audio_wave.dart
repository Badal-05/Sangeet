import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({
    super.key,
    required this.path,
  });

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();
  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPauseController() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: playAndPauseController,
            icon: playerController.playerState.isPaused
                ? const Icon(Icons.play_arrow_rounded)
                : const Icon(Icons.pause_rounded)),
        Expanded(
          child: AudioFileWaveforms(
              playerWaveStyle: const PlayerWaveStyle(
                  fixedWaveColor: Pallete.borderColor,
                  liveWaveColor: Pallete.gradient2,
                  spacing: 6,
                  showSeekLine: false),
              size: const Size(double.infinity, 100),
              playerController: playerController),
        ),
      ],
    );
  }
}
