import 'package:client/core/notifiers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currSong = ref.watch(currentSongNotifierProvider);

    if (currSong == null) return const SizedBox();
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          height: 66,
          width: MediaQuery.of(context).size.width - 16,
          decoration: BoxDecoration(
            color: hexToRGB(currSong.hex_code),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(currSong.thumbnail_url),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currSong.song_name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currSong.artist,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Pallete.subtitleText),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.heart),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.play),
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: 26,
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              color: Pallete.inactiveSeekColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        )
      ],
    );
  }
}
