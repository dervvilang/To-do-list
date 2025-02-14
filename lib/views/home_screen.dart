import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Все'; // Выбранная категория
  bool showCompletedTasks = false; // Показывать ли завершенные задачи

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'To-Do List',
          style: TextStyle(
            color: const Color.fromARGB(198, 255, 87, 132),
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks.where((task) {
            return selectedCategory == 'Все' || task.category == selectedCategory;
          }).toList();

          final currentTasks = tasks.where((task) => !task.isCompleted).toList();
          final completedTasks = tasks.where((task) => task.isCompleted).toList();

          return Column(
            children: [
              // Горизонтальный список категорий
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Все', 'Работа', 'Учёба', 'Личное'].map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      child: ChoiceChip(
                        label: Text(category,
                          style: TextStyle(
                            color: selectedCategory == category ? Colors.white : Colors.white,
                          ),
                        ),
                        backgroundColor: const Color.fromARGB(255, 255, 162, 187),
                        selectedColor: const Color.fromARGB(255, 255, 136, 168),
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                          color: selectedCategory == category
                            ? const Color.fromARGB(235, 255, 106, 146)
                            : const Color.fromARGB(255, 255, 152, 179),
                          width: 2
                        ),
                        selected: selectedCategory == category,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    // Блок "Текущие задачи"
                    ExpansionTile(
                      initiallyExpanded: true, // Открыто по умолчанию
                      title: const Text(
                        'Текущие задачи',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        if (currentTasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(child: Text('Нет текущих задач')),
                          )
                        else
                          Column(
                            children: currentTasks.map((task) => _buildTaskTile(task, taskProvider)).toList(),
                          ),
                      ],
                    ),

                    // Блок "Завершенные задачи"
                    ExpansionTile(
                      initiallyExpanded: false, // По умолчанию свернуто
                      title: const Text(
                        'Завершенные задачи',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        if (completedTasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(child: Text('Нет завершенных задач')),
                          )
                        else
                          Column(
                            children: completedTasks.map((task) => _buildTaskTile(task, taskProvider)).toList(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(198, 255, 87, 132), // Цвет кнопки
        foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Цвет иконки +
        splashColor: const Color.fromARGB(197, 255, 56, 109), // Цвет при нажатии
        child: const Icon(Icons.add),
      ),
    );
  }

  // Виджет для одной задачи
  Widget _buildTaskTile(Task task, TaskProvider taskProvider) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(
        color: const Color.fromARGB(255, 201, 42, 76), // Цвет фона при удалении задачи
        alignment: Alignment.centerRight, // Выравнивание по правому краю
        padding: const EdgeInsets.only(right: 20), // Отступ справа
        child: const Icon(Icons.delete, color: Color.fromARGB(255, 255, 226, 234)),
      ),
      direction: DismissDirection.endToStart, // Указываем направление свайпа
      onDismissed: (direction) {
        taskProvider.deleteTask(task.id!); // Удаляем задачу
      },
      child: Card(
        surfaceTintColor: const Color.fromARGB(255, 255, 114, 154),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null, // Зачеркиваем выполненные
            ),
          ),
          subtitle: task.category != null ? Text('Категория: ${task.category}') : null,
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              final updatedTask = Task(
                id: task.id,
                title: task.title,
                category: task.category,
                reminderTime: task.reminderTime,
                isCompleted: value ?? false,
              );
              taskProvider.updateTask(updatedTask);
            },
          ),
        ),
      ),
    );
  }
}
