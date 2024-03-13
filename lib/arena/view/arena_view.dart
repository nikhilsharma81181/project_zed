import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_zed/auth/provider/auth_provider.dart';

class ArenaView extends StatefulHookConsumerWidget {
  const ArenaView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArenaViewState();
}

class _ArenaViewState extends ConsumerState<ArenaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).signOut();
                },
                child: null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
