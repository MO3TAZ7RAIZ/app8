import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoAnimation;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Logo falls from top to center
    _logoAnimation = Tween<Offset>(
      begin: const Offset(0, -2), // Start above screen
      end: Offset.zero,           // End at center
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Bouncy effect
      ),
    );

    // Text fades in after logo lands
    _textOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0), // Starts halfway through
      ),
    );

    _controller.forward();

    // Navigate after 2 seconds total
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(authService: AuthService()),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _logoAnimation,
              child: CustomPaint(
                size: const Size(150, 150),
                painter: _InvertedTrianglePainter(),
              ),
            ),
            FadeTransition(
              opacity: _textOpacity,
              child: const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'GOTHAM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvertedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red[700]!
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Inner accent
    final accentPaint = Paint()
      ..color = Colors.red[400]!
      ..style = PaintingStyle.fill;

    final accentPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.7)
      ..lineTo(size.width * 0.2, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..close();

    canvas.drawPath(accentPath, accentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}