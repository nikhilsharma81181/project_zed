
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_zed/core/constant/colors_const.dart';
import 'package:project_zed/features/wallet/presentation/widget/wallet_widget.dart';

class ArenaAppBar extends StatelessWidget {
  const ArenaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 100,
      collapsedHeight: 60,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double expandRatio = constraints.biggest.height / 100;
          double titleSize = 28 - (7 * (1 - expandRatio));
          double topPadding = 20 * expandRatio;

          return Container(
            padding: EdgeInsets.only(top: topPadding),
            child: _header(titleSize),
          );
        },
      ),
    );
  }

  Widget _header(double titleSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ProjectZed',
            style: GoogleFonts.lato(
              color: Pallate.textColor,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const WalletWidget(),
        ],
      ),
    );
  }
}
