import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  static const String boxName = 'tasksBox';

  late Box<Task> _taskBox;

  List<Task> get tasks => _taskBox.values.toList();

  Future<void> init() async {
    _taskBox = Hive.box<Task>(boxName);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
    notifyListeners();
  }

  Future<void> updateTask(int index, Task updatedTask) async {
    final key = _taskBox.keyAt(index);
    await _taskBox.put(key, updatedTask);
    notifyListeners();
  }

  Future<void> toggleTaskDone(int index) async {
    final task = _taskBox.getAt(index);
    if (task != null) {
      task.isDone = !task.isDone;
      await task.save();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _taskBox.clear();
    notifyListeners();
  }
}
