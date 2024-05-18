import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/core/constant/colors_const.dart';
import 'package:project_zed/features/arena/view/arena_view.dart';
import 'package:project_zed/features/feed/presentation/pages/feed_page.dart';
import 'package:project_zed/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:project_zed/features/profile/presentation/pages/profile_page.dart';

class Homepage extends StatefulHookConsumerWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int _currentPageIndex = 0;
  List navIcons = [
    FontAwesomeIcons.battleNet,
    Icons.leaderboard_outlined,
    FontAwesomeIcons.fileLines,
    FontAwesomeIcons.user,
  ];

  @override
  Widget build(BuildContext context) {
    List pages = [
      const ArenaView(),
      const LeaderboardPage(),
      const FeedPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: pages[_currentPageIndex],
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            navIcons.length,
            (index) => _navItems(index: index),
          ),
        ),
      ),
    );
  }

  Widget _navItems({required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPageIndex = index;
        });
      },
      child: Container(
        width: 50, // For more touch detector area
        alignment: Alignment.center,
        child: FaIcon(
          navIcons[index],
          color: _currentPageIndex == index
              ? Pallate.accentColor
              : Pallate.iconColor.withOpacity(0.7),
          size: index < 2 ? 25 : 22, // To make icon size even
        ),
      ),
    );
  }
}
