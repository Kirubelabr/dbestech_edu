import 'package:dbestech_edu/core/common/app/providers/user_provider.dart';
import 'package:dbestech_edu/core/common/widgets/gradient_background.dart';
import 'package:dbestech_edu/core/common/widgets/rounded_button.dart';
import 'package:dbestech_edu/core/extensions/context_extension.dart';
import 'package:dbestech_edu/core/res/fonts.dart';
import 'package:dbestech_edu/core/res/media_res.dart';
import 'package:dbestech_edu/core/utils/core_utils.dart';
import 'package:dbestech_edu/src/auth/data/models/user_model.dart';
import 'package:dbestech_edu/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:dbestech_edu/src/auth/presentation/views/sign_in_screen.dart';
import 'package:dbestech_edu/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:dbestech_edu/src/dashboard/presentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedUp) {
            context.read<AuthBloc>().add(
                  SignInEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: MediaRes.authGradientBackground,
            child: SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const Text(
                    'Easy to learn, discover more skills.',
                    style: TextStyle(
                      fontFamily: Fonts.aeonik,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign up for an account',
                        style: TextStyle(fontSize: 14),
                      ),
                      Baseline(
                        baselineType: TextBaseline.alphabetic,
                        baseline: 100,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignInScreen.routeName,
                            );
                          },
                          child: const Text('Already have an account?'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SignUpForm(
                    emailController: emailController,
                    fullNameController: fullNameController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    formKey: formKey,
                  ),
                  const SizedBox(height: 30),
                  if (state is AuthLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    RoundedButton(
                      label: 'Sign Up',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (!context.read<AuthBloc>().isClosed) {
                          debugPrint('Is this being called?');
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    email: emailController.text.trim(),
                                    name: fullNameController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
