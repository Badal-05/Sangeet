import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer = AudioPlayer();
    // we will not use the below code to give audio to the provider beacuse it doesn't have a tag property which will be useful later.
    // also the used method will help us if we have multiple songs in queue.

    // await audioPlayer!.setUrl(song.song_url);

    final audioSource = AudioSource.uri(Uri.parse(song.song_url));
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen(
      (state) {
        if (audioPlayer!.playerState.processingState ==
            ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlaying = false;
          this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
        }
      },
    );

    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPauseSong() {
    if (isPlaying == true) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    // we don't want to update the state, because the song is still the same.
    // so this method tricks riverpod to update its listners that a change has been made.
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
