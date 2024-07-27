import 'package:client/core/notifiers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loading_indicator.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getAllFavSongsProvider).when(
          data: (data) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 28, bottom: 15),
                    child: Text(
                      'Library',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == data.length) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UploadSongPage(),
                                ),
                              );
                            },
                            leading: const CircleAvatar(
                              radius: 35,
                              backgroundColor: Pallete.backgroundColor,
                              child: Icon(Icons.add),
                            ),
                            title: const Text(
                              'Upload New Song',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }
                        final song = data[index];
                        return ListTile(
                          onTap: () {
                            ref
                                .read(currentSongNotifierProvider.notifier)
                                .updateSong(song);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(song.thumbnail_url),
                            radius: 35,
                            backgroundColor: Pallete.backgroundColor,
                          ),
                          title: Text(
                            song.song_name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            song.artist,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, st) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => const LoadingIndicator(),
        );
  }
}
