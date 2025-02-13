import 'package:flutter/material.dart';
import 'views/splash_screen.dart'; // Импортируем сплеш-скрин

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Убираем надпись "Debug"
      title: 'To-Do List', // Название приложения
      initialRoute: '/', // Начальный маршрут
      routes: {
        '/': (context) => SplashScreen(), // Сплеш-скрин
        '/home': (context) => HomeScreen(), // Главный экран
      },
    );
  }
}

// Пример заглушки для главного экрана
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: Center(
        child: Text('Добро пожаловать в To-Do List!'),
      ),
    );
  }
}