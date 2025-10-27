import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>(TaskProvider.boxName);

  final taskProvider = TaskProvider();
  await taskProvider.init();

  runApp(MyApp(taskProvider: taskProvider));
}

class MyApp extends StatelessWidget {
  final TaskProvider taskProvider;
  const MyApp({Key? key, required this.taskProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: taskProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.indigo,
            fontFamily: 'Roboto'),
        home: HomeScreen(),
      ),
    );
  }
}
