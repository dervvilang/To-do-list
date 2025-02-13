import 'package:flutter/material.dart';
import 'views/splash_screen.dart'; // Импортируем сплеш-скрин
import 'package:provider/provider.dart'; // Импортируем провайдер
import 'views/home_screen.dart'; // Импортируем главный экран
import 'providers/task_provider.dart'; // Импортируем провайдер задач

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()..fetchTasks()), // Провайдер задач
      ],
      child: const MyApp(), // Запускаем приложение
    ),
  );
}

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
