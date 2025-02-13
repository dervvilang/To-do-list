import 'package:flutter/material.dart';

class Task {
  final int? id; // Уникальный идентификатор (null при создании новой задачи)
  final String title; // Заголовок задачи
  final String category; // Категория задачи (например, "Работа", "Учеба")
  final DateTime? reminderTime; // Время напоминания (необязательно)
  final bool isCompleted; // Завершена ли задача

  // Конструктор
  Task({
    this.id,
    required this.title,
    required this.category,
    this.reminderTime,
    this.isCompleted = false,
  });

  // Преобразование объекта в Map (для сохранения в SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // ID задачи (может быть null для новых задач)
      'title': title, // Заголовок
      'category': category, // Категория
      'reminderTime': reminderTime?.toIso8601String(), // Дата → строка
      'isCompleted': isCompleted ? 1 : 0, // bool → int (SQLite не поддерживает bool)
    };
  }

  // Создание объекта Task из Map (при загрузке из SQLite)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'], // Присваиваем ID (если есть)
      title: map['title'], // Загружаем заголовок
      category: map['category'], // Загружаем категорию
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime']) // Преобразуем строку в DateTime
          : null,
      isCompleted: map['isCompleted'] == 1, // 1 → true, 0 → false
    );
  }

  // Метод copyWith() – создание копии объекта с измененными полями
  Task copyWith({
    int? id,
    String? title,
    String? category,
    DateTime? reminderTime,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id, // Если передано новое id, используем его, иначе старое
      title: title ?? this.title, // Новое название или текущее
      category: category ?? this.category, // Новая категория или текущая
      reminderTime: reminderTime ?? this.reminderTime, // Новое напоминание или текущее
      isCompleted: isCompleted ?? this.isCompleted, // Новый статус или текущий
    );
  }

  // Переопределение метода toString() для отладки
  @override
  String toString() {
    return 'Task(id: $id, title: $title, category: $category, reminderTime: $reminderTime, isCompleted: $isCompleted)';
  }

  // Функция для получения иконки по категории
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'работа':
        return Icons.work;
      case 'учёба':
        return Icons.school;
      case 'личное':
        return Icons.person;
      default:
        return Icons.task;  
    }
  }
}
