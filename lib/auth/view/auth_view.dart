import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/auth/provider/auth_provider.dart';
import 'package:project_zed/auth/view/login_view.dart';
import 'package:project_zed/auth/view/otp_view.dart';

class AuthView extends StatefulHookConsumerWidget {
  const AuthView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  bool nextPage = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(71, 0, 0, 0),
                        Color.fromARGB(71, 0, 0, 0),
                        Color.fromARGB(108, 52, 52, 52),
                        Color.fromARGB(227, 52, 52, 52),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: _buildLoginComponent(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginComponent() {
    final loginAnimationProv = ref.watch(loginAnimationProvider);
    return loginAnimationProv.otpPage[1] == true
        ? const OTPView()
        : FadeOutDown(
            animate: loginAnimationProv.otpPage[0],
            child: const LoginView(),
          );
  }
}
