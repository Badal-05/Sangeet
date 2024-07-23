import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
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
    audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.play();
    state = song;
  }
}
