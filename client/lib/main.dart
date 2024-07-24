import 'package:client/core/notifiers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';

import 'package:client/features/auth/view/pages/signup.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  // we want to initialize the _sharedPreferences before calling the set token and get token.
  // so for that we would have to run the init() method from auth_local_repo at the start of the app.
  // but for that we would need the authLocalRepoProvider.
  // hence we will use container. and change ProviderScope -> UncontrolledProviderScope
  final container = ProviderContainer();
  await container.read(authViewmodelProvider.notifier).initSharedPreferences();
  // final userModel =
  await container.read(authViewmodelProvider.notifier).getData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      //keeps track of all the providers created in the application
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    //print(currentUser == null);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sangeet",
      theme: AppTheme.darkTheme,
      home: currentUser == null ? const SignupPage() : const Homepage(),
    );
  }
}
