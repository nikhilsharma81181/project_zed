import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_zed/auth/provider/auth_provider.dart';
import 'package:project_zed/firebase_options.dart';
import 'package:project_zed/homepage.dart';
import 'package:project_zed/auth/view/auth_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SaveLoginDetails.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProjectZed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulHookConsumerWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    String? token = SaveLoginDetails.getToken();
    log("Token: $token");
    if (token != null && token.isNotEmpty) {
      return _buildPageTransition(child: const Homepage());
    } else {
      return _buildPageTransition(child: const AuthView());
    }
  }

  Widget _buildPageTransition({required Widget child}) {
    return PageTransition(
      type: PageTransitionType.fade, // You can change the transition type here
      child: child,
    ).child;
  }
}
