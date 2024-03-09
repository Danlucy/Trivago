import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/core/loader.dart';
import 'package:trivago/features/auth/controller/auth_controller.dart';
import 'package:trivago/features/auth/widget/sign_in_button.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivago'),
      ),
      body: isLoading
          ? const Loader()
          : const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign In With Your Google Account'),
                SizedBox(
                  height: 20,
                ),
                SignInButton()
              ],
            )),
    );
  }
}
