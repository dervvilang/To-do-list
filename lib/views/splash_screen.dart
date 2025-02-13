// lib/views/splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Настройка контроллера анимации
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Анимация прозрачности (появление текста)
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Анимация масштабирования (увеличение текста)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Запуск анимации
    _controller.forward();

    // Переход на главный экран через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
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
      backgroundColor: const Color.fromARGB(255, 255, 163, 198), // Фоновый цвет
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Анимированный текст с градиентом
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'To-Do List',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Colors.pinkAccent,
                          Colors.purple,
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 100)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Индикатор загрузки
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}