import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MatchCardWidget extends ConsumerWidget {
  const MatchCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              border: Border.all(
                width: 1.5,
                color: Colors.white.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 3,
                        width: width * 0.55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF5F54E2).withOpacity(0),
                              const Color(0xFF5F54E2),
                              const Color(0xFF5F54E2),
                              const Color(0xFF5F54E2).withOpacity(0),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5F54E2).withOpacity(0.6),
                              blurRadius: 50,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: _cardContent(
                    context: context,
                    title: "Weekly Cash - TPP",
                    prize: 1000,
                    entryFee: 50,
                    progress: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardContent({
    required BuildContext context,
    required String title,
    required int prize,
    required int entryFee,
    required double progress,
  }) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 5,
            runSpacing: 8,
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            children: [
              _matchState(index: 0, state: "Featured"),
              _matchState(index: 1, state: "Tier 1"),
              _matchState(index: 2, state: "Squad"),
              _matchState(index: 3, state: "Erangle"),
              _matchState(index: 4, state: "TPP"),
              _matchState(index: 5, state: "18 Aug"),
              _matchState(index: 6, state: "09:30 PM"),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: width,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 0.2,
                  color: Colors.white,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF5F54E2).withOpacity(0.9)),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Prize: ",
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "\$$prize",
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Entry: ",
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "\$$entryFee",
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _btn(width: width),
        ],
      ),
    );
  }

  Widget _matchState({
    required int index,
    required String state,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 9,
      ),
      decoration: BoxDecoration(
        color: index == 0
            ? const Color.fromARGB(255, 212, 127, 15)
            : Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1,
          color: Colors.transparent,
        ),
      ),
      child: Text(
        state,
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _btn({required double width}) {
    return Container(
      width: width,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF5F54E2).withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1.4,
          color: const Color.fromARGB(255, 103, 90, 238),
        ),
      ),
      child: RawMaterialButton(
        onPressed: () {},
        child: Text(
          "Register Now",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
