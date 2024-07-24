import 'package:client/features/home/model/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repo.g.dart';

@riverpod
HomeLocalRepo homeLocalRepo(HomeLocalRepoRef ref) {
  return HomeLocalRepo();
}

class HomeLocalRepo {
  final Box box = Hive.box();

  void uploadLocalSong(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key)));
    }
    return songs;
  }
}
