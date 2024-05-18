import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/core/constant/colors_const.dart';

class WalletWidget extends ConsumerWidget {
  const WalletWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wallet,
            size: 22,
            color: Pallate.textColor,
          ),
          const SizedBox(width: 2.5),
          Text(
            '500',
            style: GoogleFonts.exo2(
              color: Pallate.textColor,
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
