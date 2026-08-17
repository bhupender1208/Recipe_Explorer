import 'package:flutter/material.dart';
import 'dart:async'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 4));
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const RecipeListScreen(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MyLogin(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Scaffold(
      backgroundColor: Colors.black,  
      body: Stack(
        children: [
           Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 600 : double.infinity, 
                ),
                child: Image.asset(
                  "assets/images/splash1.png",
                  fit: isDesktop ? BoxFit.contain : BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),

          /// Fade Title
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: isDesktop ? 60 : 120),
              child: FadeTransition(
                opacity: _animation,
                child: Text(
                  """TastyVerse,
Your World of Delicious Recipes""",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 40,  
                    fontWeight: FontWeight.bold,
                    color: Colors.white,  
                    letterSpacing: isDesktop ? 1.2 : 2,
                    shadows: const [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}