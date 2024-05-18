import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/core/constant/asset_constants.dart';
import 'package:project_zed/core/constant/colors_const.dart';
import 'package:project_zed/features/wallet/presentation/widget/wallet_widget.dart';

class ArenaView extends StatefulHookConsumerWidget {
  const ArenaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArenaViewState();
}

class _ArenaViewState extends ConsumerState<ArenaView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {});
  }

  int _selectedGame = 0;
  int _selectedState = 0;
  List gameImageList = [
    AssetConstants.pubgIcon,
    AssetConstants.warzoneIcon,
  ];
  List gameImageBGList = [
    AssetConstants.pubgBG,
    AssetConstants.warzoneBG,
  ];

  List gameNameList = [
    "Battlegrounds Mobile India (BGMI)",
    "Warzone Mobile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: AnimatedSwitcher(
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
            key: ValueKey<int>(_selectedGame),
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage(gameImageBGList[_selectedGame]),
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
                  controller: _scrollController,
                  slivers: [
                    _buildSliverAppBar(),
                    _buildSliverList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
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

  Widget _buildSliverList() {
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
            gameImageList.length,
            (index) => _gameOption(index: index),
          ),
        ),
        _matchStateOption(),
      ],
    );
  }

  Widget _gameOption({required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGame = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              gameImageList[index],
            ),
            fit: BoxFit.cover,
            colorFilter: _selectedGame == index
                ? null
                : ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
          ),
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: _selectedGame == index ? Colors.white : Colors.transparent,
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
      onTap: () {
        setState(() {
          _selectedState = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 11,
        ),
        decoration: BoxDecoration(
          color: _selectedState == index
              ? Colors.black.withOpacity(0.12)
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: _selectedState == index
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
          gameNameList[_selectedGame],
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        _matcheCard(),
        _matcheCard(),
        _matcheCard(),
        _matcheCard(),
      ],
    );
  }

  Widget _matcheCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
