import 'dart:convert';

import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${ServerConstants.serverUrl}/song/upload'));
      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath('song', selectedAudio.path),
            await http.MultipartFile.fromPath('thumbnail', selectedImage.path)
          ],
        )
        ..fields.addAll(
          {
            'artist': artist,
            'songName': songName,
            'color': hexCode,
          },
        )
        ..headers.addAll(
          {
            'x-auth-token': token,
          },
        ); // here the file takes 'song' as the file, this is what we defined on the server side.

      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(AppFailure(err: await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(err: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs(
      {required String token}) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${ServerConstants.serverUrl}/song/list',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        // if the status code is not 200 then we will get a map.
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(err: resBodyMap['detail']));
      }
      //otherwise we will get a List<Map>.
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(err: e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favoriteSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${ServerConstants.serverUrl}/song/favorite',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {
            'song_id': songId,
          },
        ),
      );
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        // if the status code is not 200 then we will get a map.
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(err: resBodyMap['detail']));
      }

      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(AppFailure(err: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavSongs(
      {required String token}) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${ServerConstants.serverUrl}/song/list/favorites',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        // if the status code is not 200 then we will get a map.
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(err: resBodyMap['detail']));
      }
      //otherwise we will get a List<Map>.
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map['song']));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(err: e.toString()));
    }
  }
}
