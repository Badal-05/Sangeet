import 'package:client/core/notifiers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';

import 'package:client/features/auth/view/pages/signup.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';

import 'package:client/features/home/view/pages/upload_song_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: currentUser == null ? const SignupPage() : const UploadSongPage(),
    );
  }
}
