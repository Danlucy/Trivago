import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/features/auth/controller/auth_controller.dart';
import 'package:trivago/routes/app_router.dart';
import 'constants/colour.dart';
import 'core/error_text.dart';
import 'core/loader.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  bool isOnline = await hasNetwork();
  runApp(
    isOnline
        ? const ProviderScope(
            child: MyApp(),
          )
        : const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'No Internet',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(
    BuildContext context,
  ) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    AppRouter appRouter = AppRouter(ref: ref);
    return ref.watch(authStateChangeProvider).when(
        data: (data) => MaterialApp.router(
              routerConfig: appRouter.config(),
              debugShowCheckedModeBanner: false,
              title: 'Trivago',
              theme: Pallete.darkModeAppTheme,
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
