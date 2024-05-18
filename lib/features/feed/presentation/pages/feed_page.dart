import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedPage extends StatefulHookConsumerWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedPageState();
}
class _FeedPageState extends ConsumerState<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}