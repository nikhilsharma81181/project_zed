import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedView extends StatefulHookConsumerWidget {
  const FeedView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedViewState();
}
class _FeedViewState extends ConsumerState<FeedView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}