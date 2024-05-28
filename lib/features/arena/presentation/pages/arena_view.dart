import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/core/constant/asset_constants.dart';
import 'package:project_zed/features/arena/presentation/widgets/arena_appbar_widget.dart';
import 'package:project_zed/features/arena/presentation/widgets/match_card_widget.dart';

class ArenaView extends HookConsumerWidget {
  const ArenaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: const ArenaContent(),
      ),
    );
  }
}

class ArenaContent extends HookConsumerWidget {
  const ArenaContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGame = useState(0);
    final selectedState = useState(0);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Container(
        key: ValueKey<int>(selectedGame.value),
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image:
                AssetImage(AssetConstants.gameImageBGList[selectedGame.value]),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                const ArenaAppBar(),
                ArenaContentWidget(
                  selectedGame: selectedGame.value,
                  selectedState: selectedState.value,
                  onGameSelected: (index) => selectedGame.value = index,
                  onStateSelected: (index) => selectedState.value = index,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArenaContentWidget extends StatefulWidget {
  final int selectedGame;
  final int selectedState;
  final Function(int) onGameSelected;
  final Function(int) onStateSelected;

  const ArenaContentWidget({
    super.key,
    required this.selectedGame,
    required this.selectedState,
    required this.onGameSelected,
    required this.onStateSelected,
  });

  @override
  State<ArenaContentWidget> createState() => _ArenaContentWidgetState();
}

class _ArenaContentWidgetState extends State<ArenaContentWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.042),
          child: Column(
            children: [
              const SizedBox(height: 25),
              _gameSelector(),
              const SizedBox(height: 25),
              _matches(),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _gameSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(
            AssetConstants.gameImageList.length,
            (index) => _gameOption(index: index),
          ),
        ),
        _matchStateOption(),
      ],
    );
  }

  Widget _gameOption({required int index}) {
    return GestureDetector(
      onTap: () => widget.onGameSelected(index),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AssetConstants.gameImageList[index],
            ),
            fit: BoxFit.cover,
            colorFilter: widget.selectedGame == index
                ? null
                : ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
          ),
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: widget.selectedGame == index
                ? Colors.white
                : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _matchStateOption() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.5,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        runAlignment: WrapAlignment.end,
        alignment: WrapAlignment.end,
        children: [
          _matchState(index: 0, state: "Upcoming"),
          _matchState(index: 1, state: "Ongoing"),
          _matchState(index: 2, state: "Completed"),
        ],
      ),
    );
  }

  Widget _matchState({
    required int index,
    required String state,
  }) {
    return GestureDetector(
      onTap: () => widget.onStateSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 11,
        ),
        decoration: BoxDecoration(
          color: widget.selectedState == index
              ? Colors.black.withOpacity(0.12)
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: widget.selectedState == index
              ? Border.all(
                  width: 1,
                  color: Colors.white.withOpacity(0.4),
                )
              : Border.all(
                  width: 1,
                  color: Colors.transparent,
                ),
        ),
        child: Text(
          state,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _matches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AssetConstants.gameNameList[widget.selectedGame],
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const MatchCardWidget(),
        const MatchCardWidget(),
        const MatchCardWidget(),
        const MatchCardWidget(),
      ],
    );
  }
}
