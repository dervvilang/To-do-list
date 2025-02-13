import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState(); // Создаем состояние экрана добавления задачи
}

// Состояние экрана добавления задачи 
class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController(); // Контроллер для ввода названия задачи
  String? _selectedCategory; // Выбранная категория
  TimeOfDay? _selectedTime; // Выбранное время напоминания

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Добавить задачу',
          style: const TextStyle(
            color: Color.fromARGB(198, 255, 87, 132),
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю 
          children: [
            // Поле для ввода названия задачи
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название задачи',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Выпадающий список категорий
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Категория',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategory,
              items: ['Учёба', 'Работа', 'Личное', 'Другое']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Кнопка выбора времени напоминания
            Row(
              children: [
                Text(
                  _selectedTime != null
                      ? 'Напоминание: ${_selectedTime!.format(context)}'
                      : 'Выберите время напоминания',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Кнопка сохранения задачи
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Введите название задачи')),
                    );
                    return;
                  }

                  // Создаем новую задачу
                  final newTask = Task(
                    title: _titleController.text,
                    category: _selectedCategory ?? 'Без категории',
                    reminderTime: _selectedTime != null
                        ? DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          )
                        : null,
                    isCompleted: false,
                  );

                  // Добавляем задачу в provider
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(newTask);

                  // Закрываем экран
                  Navigator.pop(context);
                },
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
