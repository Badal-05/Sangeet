import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loading_indicator.dart';
import 'package:client/features/auth/view/pages/signin.dart';
import 'package:client/features/auth/view/widgets/custom_auth_button.dart';
import 'package:client/features/auth/view/widgets/custom_text_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late TapGestureRecognizer? recognizer;
  final formKey = GlobalKey<
      FormState>(); // only with the help of this can we use the validator;

  @override
  void initState() {
    recognizer = TapGestureRecognizer()..onTap = _handlePress;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    recognizer!.dispose();
    super.dispose();
  }

  void _handlePress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SigninPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewmodelProvider)?.isLoading == true;

    ref.listen(authViewmodelProvider, (prev, next) {
      next?.when(
          data: (data) {
            displaySnackBar(
                context, 'Account created Successfully! Please Login');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SigninPage(),
              ),
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
                      'Sign Up.',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      text: 'Name',
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 15,
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
                      text: 'Sign Up',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          ref.read(authViewmodelProvider.notifier).signup(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        }

                        //print(val);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Already have an Account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            recognizer:
                                recognizer, // instead of this recognizer we could have also wrapped the entire richtext widget by gesturedetector or inkwell widget, but the issue was, we would be redirected even if we clicked on the other text
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
