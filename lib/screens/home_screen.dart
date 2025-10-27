import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showCompleted = true;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final allTasks = taskProvider.tasks;

    // Filter tasks based on the "show completed" toggle
    final visibleTasks = _showCompleted
        ? allTasks
        : allTasks.where((task) => !task.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon:
                Icon(_showCompleted ? Icons.visibility : Icons.visibility_off),
            tooltip: _showCompleted
                ? 'Hide completed tasks'
                : 'Show completed tasks',
            onPressed: () {
              setState(() {
                _showCompleted = !_showCompleted;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_showCompleted
                      ? 'Showing all tasks'
                      : 'Hiding completed tasks'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: visibleTasks.isEmpty
          ? const Center(
              child: Text('No tasks yet. Tap + to add one!'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: visibleTasks.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final task = visibleTasks[index];
                // Find actual index from allTasks for update/delete
                final actualIndex = allTasks.indexOf(task);

                return TaskTile(
                  task: task,
                  onToggle: () => taskProvider.toggleTaskDone(actualIndex),
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditTaskScreen(
                        index: actualIndex,
                        task: task,
                      ),
                    ),
                  ),
                  onDelete: () => showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Delete Task'),
                      content: Text(
                          'Are you sure you want to delete "${task.title}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            taskProvider.deleteTask(actualIndex);
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        ),
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
