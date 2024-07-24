import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repo.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepo _homeLocalRepo;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    _homeLocalRepo = ref.watch(homeLocalRepoProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    //stop the existing song that is playing and then start playing the new song.
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();
    // we will not use the below code to give audio to the provider beacuse it doesn't have a tag property which will be useful later.
    // also the used method will help us if we have multiple songs in queue.

    // await audioPlayer!.setUrl(song.song_url);

    final audioSource = AudioSource.uri(Uri.parse(song.song_url),
        tag: MediaItem(
          id: song.id,
          title: song.song_name,
          artist: song.artist,
          artUri: Uri.parse(song.thumbnail_url),
        ));
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

    _homeLocalRepo.uploadLocalSong(song);

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
