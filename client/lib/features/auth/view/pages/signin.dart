import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loading_indicator.dart';

import 'package:client/features/auth/view/pages/signup.dart';
import 'package:client/features/auth/view/widgets/custom_auth_button.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/homepage.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late TapGestureRecognizer recognizer;
  final formKey = GlobalKey<
      FormState>(); // only with the help of this can we use the validator;

  @override
  void initState() {
    recognizer = TapGestureRecognizer()..onTap = _handlePress;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handlePress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SignupPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewmodelProvider.select((val) => val?.isLoading == true));

    ref.listen(authViewmodelProvider, (prev, next) {
      next?.when(
          data: (data) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),
              (_) => false,
            );
          },
          error: (error, stacktrace) {
            displaySnackBar(context, error.toString());
          },
          loading: () {});
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const LoadingIndicator()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign In.',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      text: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      text: 'Password',
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomAuthButton(
                      text: 'Sign In',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          ref.read(authViewmodelProvider.notifier).login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        } else {
                          displaySnackBar(context, 'Missing Fields');
                        }
                        //print(val);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            recognizer: recognizer,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Pallete.gradient2),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
