import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _description;
  DateTime? _dueDate;

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final newTask = Task(
      title: _title,
      description: _description,
      isDone: false,
      dueDate: _dueDate,
    );

    await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
    Navigator.pop(context);
  }

  void _pickDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a title'
                    : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'No due date selected'
                          : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickDueDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
