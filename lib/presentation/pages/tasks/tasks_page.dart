import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:rokctapp/application/tasks/task_model.dart';
import 'package:rokctapp/infrastructure/tasks/task_service.dart';

class TasksPage extends StatefulWidget {
  final String userType;

  const TasksPage({Key? key, required this.userType}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late TaskService _taskService;
  List<TaskModel> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await _taskService.getTasks();
    setState(() {});
  }

  Future<void> _addTask() async {
    if (_titleController.text.isEmpty) return;

    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: _titleController.text,
      note: _noteController.text,
      createdAt: DateTime.now(),
      createdBy: widget.userType,
    );
    await _taskService.addTask(newTask);
    _titleController.clear();
    _noteController.clear();
    _loadTasks();
  }

  Future<void> _toggleTaskStatus(TaskModel task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await _taskService.updateTask(updatedTask);
    _loadTasks();
  }

  Future<void> _deleteTask(String id) async {
    await _taskService.deleteTask(id);
    _loadTasks();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note (Optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Checkbox(
                value: task.isDone,
                onChanged: (bool? value) => _toggleTaskStatus(task),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.note.isNotEmpty) Text(task.note),
                  Text(
                    'Created by: ${task.createdBy} on ${task.createdAt.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteTask(task.id),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
