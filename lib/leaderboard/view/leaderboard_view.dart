import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LeaderboardView extends StatefulHookConsumerWidget {
  const LeaderboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaderboardViewState();
}
class _LeaderboardViewState extends ConsumerState<LeaderboardView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}