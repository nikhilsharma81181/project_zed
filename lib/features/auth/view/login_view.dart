import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/features/auth/provider/auth_provider.dart';
import 'package:project_zed/shared/server_config/api_response_model.dart';

class LoginView extends StatefulHookConsumerWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  List<bool> fadeAnimation = [];
  final phoneCtrl = TextEditingController();

  bool animateError = false;
  String phoneErrorMsg = "";

  _handleSendOtp() async {
    FocusScope.of(context).unfocus();
    final authProv = ref.read(authProvider.notifier);
    ApiResponse success = await authProv.sendOtp(phone: phoneCtrl.text);
    if (success.success) {
      authProv.updatePhoneNumber(phoneCtrl.text);
      ref.read(loginAnimationProvider.notifier).animateToOtpView();
    } else {
      setState(() {
        phoneErrorMsg = success.errorMessage ?? "";
      });
    }
  }

  _handleGoogleSignIn() async {
    bool success = await ref.read(authProvider.notifier).signInWithGoogle();
    if (success) {
      setState(() {
        // nextPage = true;
      });
    }
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final authProv = ref.watch(authProvider);
    useEffect(() {
      phoneCtrl.text = authProv.phoneNumber ?? "";
      fadeAnimation = List.generate(7, (index) => false);
      Timer.periodic(const Duration(milliseconds: 150), (timer) {
        if (mounted) {
          if (fadeAnimation.every((element) => element)) {
            timer.cancel();
          } else {
            for (int i = 0; i < fadeAnimation.length; i++) {
              if (!fadeAnimation[i]) {
                fadeAnimation[i] = true;
                break;
              }
            }
            setState(() {});
          }
        }
      });
      return null;
    }, const []);
    return Padding(
      padding: EdgeInsets.all(width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          FadeInUp(
            animate: fadeAnimation[0],
            child: Text(
              'Join us!',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: width * 0.01),
          FadeInUp(
            animate: fadeAnimation[1],
            child: Text(
              'on a Exciting Journey of ',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FadeInUp(
            animate: fadeAnimation[2],
            child: Text(
              'Esports',
              style: GoogleFonts.exo2(
                color: Colors.white,
                fontSize: width * 0.15,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 70),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInUp(
                  animate: fadeAnimation[3],
                  child: Container(
                    height: width * 0.14,
                    width: width * 0.86,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: width * 0.042,
                      ),
                      validator: (value) {
                        if (value is! String || value.isEmpty) {
                          setState(() =>
                              phoneErrorMsg = "Field should not be empty");
                        } else {
                          setState(() => phoneErrorMsg = "");
                          if (value.length < 10) {
                            setState(() => phoneErrorMsg =
                                "Mobile number must be 10 digits");
                          } else {
                            setState(() => phoneErrorMsg = "");
                          }
                        }
                        setState(() => animateError = true);
                        if(animateError) {
                          Future.delayed(const Duration(milliseconds: 1000), () {
                          setState(() => animateError = false);
                        });
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon:
                            const Icon(Icons.phone, color: Colors.black),
                        counterText: '',
                        hintText: 'Enter your Mobile Number',
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.01),
                _buildError(),
                SizedBox(height: width * 0.01),
                FadeInUp(
                  animate: fadeAnimation[4],
                  child: SizedBox(
                    height: width * 0.14,
                    width: width * 0.86,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            phoneErrorMsg == '') {
                          setState(() {
                            phoneErrorMsg = "";
                          });
                          _handleSendOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 53, 53, 53),
                          ),
                        ),
                      ),
                      child: authProv.isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: width * 0.07,
                                height: width * 0.07,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              "Send OTP",
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: width * 0.044,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.04),
                FadeInUp(
                  animate: fadeAnimation[5],
                  child: Text(
                    'or login with',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: width * 0.04),
                FadeInUp(
                  animate: fadeAnimation[6],
                  child: SizedBox(
                    height: width * 0.14,
                    width: width * 0.86,
                    child: ElevatedButton(
                      onPressed: () {
                        _handleGoogleSignIn();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 53, 53, 53),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage(
                              'assets/images/google.png',
                            ),
                            height: 27,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Google',
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: width * 0.047,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    double width = MediaQuery.of(context).size.width;
    if (phoneErrorMsg == "") {
      return SizedBox(
        height: width * 0.05,
      );
    } else {
      return ShakeX(
        animate: animateError,
        duration: const Duration(milliseconds: 250),
        child: Text(
          phoneErrorMsg,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            color: const Color.fromARGB(255, 237, 99, 90),
            fontSize: 15.0,
          ),
        ),
      );
    }
  }
}
