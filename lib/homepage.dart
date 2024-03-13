import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/arena/view/arena_view.dart';
import 'package:project_zed/feed/view/feed_view.dart';
import 'package:project_zed/leaderboard/view/leaderboard_view.dart';
import 'package:project_zed/profile/view/view.dart';

class Homepage extends StatefulHookConsumerWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      const ArenaView(),
      const LeaderboardView(),
      const FeedView(),
      const ProfileView(),
    ];
    return Scaffold(
      body: pages[_currentPageIndex],
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        onTap: (val) {
          setState(() {
            _currentPageIndex = val;
            log(_currentPageIndex.toString());
          });
        },
        selectedIconTheme: const IconThemeData(color: Colors.black),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        fixedColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Arena',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            label: 'LeaderBoard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
