import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BullsEye Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0055FF),
          primary: const Color(0xFF0055FF),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String deadline;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _blockyInputDecoration(String label, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      prefixIcon: Icon(icon, color: Colors.black),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFFFFCC00),
                    child: const Icon(Icons.task_alt, size: 64, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'BULLSEYE',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: _blockyInputDecoration('Nama Lengkap', Icons.person_outline),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: _blockyInputDecoration('Email / Username', Icons.email_outlined),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Email wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isPasswordObscured,
                    decoration: _blockyInputDecoration(
                      'Password',
                      Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => _isPasswordObscured = !_isPasswordObscured);
                        },
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? 'Password minimal 6 karakter' : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055FF),
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MenuScreen(
                                userName: _nameController.text.trim(),
                                userPassword: _passwordController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('MASUK', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  final String userName;
  final String userPassword;

  const MenuScreen({
    super.key,
    required this.userName,
    required this.userPassword,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Sprint 2: Navigation & Multi-Screen App',
      description: 'Implement routing and parameter passing.',
      deadline: '11:59 PM',
    ),
  ];

  void _addNewTask(Task newTask) {
    setState(() {
      _tasks.add(newTask);
    });
  }

  void _markTaskCompleted(String taskId) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index].isCompleted = true;
      }
    });
  }

  Future<void> _openAddTaskModal() async {
    final Task? newTask = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskModal(),
    );

    if (newTask != null) {
      _addNewTask(newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CALENDAR & TASKS', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskModal,
        backgroundColor: const Color(0xFFFFCC00),
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(),
        icon: const Icon(Icons.add),
        label: const Text('ADD TASK', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16.0),
            color: const Color(0xFFFFCC00),
            child: Text(
              'Halo, ${widget.userName}!\nKamu ingin belajar apa hari ini?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          ..._tasks.map(
            (task) => Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              elevation: 0,
              shape: const RoundedRectangleBorder(),
              child: ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text('Due: ${task.deadline}\n${task.description}'),
                isThreeLine: true,
                trailing: task.isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                        ),
                        onPressed: () async {
                          final bool? isFinished = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PomodoroScreen(task: task),
                            ),
                          );

                          if (isFinished == true) {
                            _markTaskCompleted(task.id);
                          }
                        },
                        child: const Text('RUN TIMER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({super.key});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _deadlineController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _deadlineController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('BUAT TUGAS BARU', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Tugas', filled: true),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi Tugas', filled: true),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deadlineController,
                decoration: const InputDecoration(labelText: 'Deadline', filled: true),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Deadline wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0055FF), foregroundColor: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _titleController.text.trim(),
                        description: _descController.text.trim(),
                        deadline: _deadlineController.text.trim(),
                      );
                      Navigator.pop(context, newTask);
                    }
                  },
                  child: const Text('SIMPAN TUGAS', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  final Task task;

  const PomodoroScreen({super.key, required this.task});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int _workDuration = 25 * 60;
  Timer? _timer;
  int _secondsRemaining = _workDuration;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POMODORO FOCUS', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(widget.task.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(widget.task.description, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(32),
              color: const Color(0xFFFFCC00),
              child: Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0055FF), foregroundColor: Colors.white),
                onPressed: _toggleTimer,
                child: Text(_isRunning ? 'PAUSE' : 'START FOCUS', style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('MARK AS DONE NOW', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
