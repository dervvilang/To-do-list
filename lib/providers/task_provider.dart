import 'package:flutter/material.dart'; // Импорт пакета material.dart для доступа к виджетам Flutter
import '../models/task.dart'; // Импорт модели Task для работы с задачами в бд
import '../services/database_service.dart'; // Импорт сервиса DatabaseService для работы с базой данных 

class TaskProvider extends ChangeNotifier {
  List<Task> _task = []; // Список задач (по умолчанию пустой)
  final DatabaseService _databaseService = DatabaseService(); // Экземпляр сервиса DatabaseService

  List<Task> get tasks => _task; // Геттер для получения списка задач

  // Метод для загрузки задач из бд
  Future<void> fetchTasks() async {
    _task = await _databaseService.getTask(); // Получаем задачи из бд
    notifyListeners(); // оповещяем UI об изменениях
  }

  // Метод для добавления задачи в бд
  Future<void> addTask(Task task) async {
    await _databaseService.insertTask(task); // Добавляем задачу в бд
    await fetchTasks(); // обновляем список задач
  }

  //Метод для обовления задачи
  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task); // Обновляем задачу в бд
    await fetchTasks(); // Обновляем список
  }

  // Метод для удаления задачи
  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id); // Удаляем задачу из бд
    await fetchTasks(); // Обновляем список задач
  }

}