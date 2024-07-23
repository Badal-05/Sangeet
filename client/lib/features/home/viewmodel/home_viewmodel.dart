import 'dart:io';

import 'package:client/core/notifiers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

// when we want to fetch data, riverpod provides a special furtureProvider, it helps in caching and also improves the app performance.
// down below is the code to create the same.
@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.err,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color color,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedImage: selectedImage,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(color),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.toString(), StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
    print(val);
  }
}
