import 'package:sqflite/sqflite.dart'; // Импорт пакета sqflite для работы с SQLite
import 'package:path/path.dart'; // Импорт пакета path для работы с путями 
import '../models/task.dart'; // Импорт модели Task


class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal(); // Статический экземпляр DatabaseService 
  factory DatabaseService() => _instance; // Фабричный метод для получения экземпляра DatabaseService 
  DatabaseService._internal(); // Приватный конструктор для создания экземпляра DatabaseService

  static Database? _database; // Ссылка на базу данных SQLite 

  // Метод для получения базы данных (создает базу данных, если она еще не создана) 
  Future<Database> get database async {
    if (_database != null) return _database!; // Если база данных уже открыта, возвращаем ее

    _database = await _initDB(); // Инициализируем базу данных и сохраняем ссылку в _database 
    return _database!; // Возвращаем ссылку на базу данных
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // Получаем путь к каталогу баз данных 
    final path = join(dbPath, 'tasks.db'); // Объединяем путь к каталогу и имя базы данных 

    return await openDatabase(
      path, // Путь к базе данных
      version: 1, // Версия базы данных
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            category TEXT,
            reminderTime TEXT,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )
        '''); // Создаем таблицу tasks
      },
    );
  }

  // Метод для добавления задачи в бд
  Future<int> insertTask(Task task) async {
    final db = await database; // Получаем базу данных
    return await db.insert(
      'tasks', // Имя таблицы
      task.toMap(), // Преобразуем объект Task в Map
      conflictAlgorithm: ConflictAlgorithm.replace, // Если id уже существует, заменяем запись
    );
  }

  // Метод для получения всех задач из бд
  Future<List<Task>> getTask() async {
    final db = await database; // Получаем базу данных 
    final List<Map<String, dynamic>> maps = await db.query('tasks'); // Получаем все записи из таблицы tasks

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]); // Преобразуем каждую запись в объект Task
    });
  }

  // Метод для обновления задачи в бд
  Future<int> updateTask(Task task) async {
    final db = await database; // Получаем базу данных

    return await db.update(
      'tasks', // Имя таблицы
      task.toMap(),
      where: 'id = ?', // Условие для обновления записи 
      whereArgs: [task.id], // Аргументы для условия 
    );
  }

  // Метод для удаления задачи из бд
  Future<int> deleteTask(int id) async {
    final db = await database; // Получаем базу данных

    return await db.delete(
      'tasks',
      where: 'id = ?', // Условие для удаления записи
      whereArgs: [id], // Аргументы для условия
    );
  }

}