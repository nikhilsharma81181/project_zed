import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:project_zed/features/arena/presentation/pages/arena_view.dart';
import 'package:project_zed/features/authentication/presentation/providers/login_animation_provider.dart';
import 'package:project_zed/features/authentication/presentation/providers/phone_auth_provider.dart';
import 'package:project_zed/core/server_config/api_response_model.dart';

class OTPView extends StatefulHookConsumerWidget {
  const OTPView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPViewState();
}

class _OTPViewState extends ConsumerState<OTPView> {
  final otpCtrl = TextEditingController();
  String otpErrorMsg = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final loginAnimationProv = ref.watch(loginAnimationProvider);
    final authProv = ref.watch(authNotifierProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInUp(
          animate: loginAnimationProv.otpPage[2],
          child: Text(
            "Verify OTP",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          animate: loginAnimationProv.otpPage[3],
          child: SizedBox(
            width: width * 0.8,
            child: Row(
              children: [
                Text(
                  '  Enter the OTP sent to ',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '+91-${authProv.phoneNumber}',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _pinFeild(),
        const SizedBox(height: 12),
        FadeInUp(
          animate: loginAnimationProv.otpPage[5],
          child: SizedBox(
            width: width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    for (var i = 0;
                        i < loginAnimationProv.otpPage.length;
                        i++) {
                      setState(() {
                        loginAnimationProv.otpPage[i] = false;
                      });
                    }
                  },
                  child: Text(
                    'Change Number',
                    style: GoogleFonts.lato(
                      color: Colors.yellowAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Resend OTP',
                  style: GoogleFonts.lato(
                    color: Colors.yellowAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _pinFeild() {
    double width = MediaQuery.of(context).size.width;
    final loginAnimationProv = ref.watch(loginAnimationProvider);
    return FadeInUp(
      animate: loginAnimationProv.otpPage[4],
      child: Container(
        height: 52,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
        child: PinCodeTextField(
          appContext: context,
          controller: otpCtrl,
          length: 6,
          autoFocus: true,
          animationType: AnimationType.fade,
          onChanged: (_) async {
            if (otpCtrl.text.length == 6) {
              final result = await ref
                  .read(authNotifierProvider.notifier)
                  .verifyOtp(otp: otpCtrl.text);
              otpCtrl.clear();
              result.fold(
                (failure) {
                  setState(() {
                    otpErrorMsg = failure.message;
                  });
                },
                (success) {
                  if (success) {
                    log("otp: $success");
                    Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomCenter,
                            child: const ArenaView()));
                  }
                },
              );
            }
          },
          cursorColor: Colors.white,
          cursorHeight: 20,
          autoDisposeControllers: true,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          textStyle: GoogleFonts.openSans(
            color: Colors.white,
          ),
          enableActiveFill: true,
          pinTheme: PinTheme(
            fieldWidth: width * 0.12,
            activeFillColor: Colors.transparent,
            activeColor: Colors.white,
            selectedColor: Colors.white,
            inactiveColor: Colors.grey.shade600,
            disabledColor: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(8),
            selectedFillColor: Colors.transparent,
            inactiveFillColor: Colors.transparent,
            shape: PinCodeFieldShape.box,
          ),
        ),
      ),
    );
  }
}
