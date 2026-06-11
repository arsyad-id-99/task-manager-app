// lib/presentation/pages/task_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:task_manager_app/presentation/pages/auth_page.dart';
import 'package:task_manager_app/presentation/widgets/task_empty_state.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_card.dart';
import '../widgets/task_shimmer_loading.dart'; // Import Shimmer
import 'add_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(FetchTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF174DB1);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Task Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text(
                    'Apakah Anda yakin ingin keluar dari aplikasi?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.read<AuthBloc>().add(LogoutRequested());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthPage()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Keluar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          return current is TaskLoading ||
              current is TaskLoaded ||
              current is TaskEmpty ||
              current is TaskError;
        },
        builder: (context, state) {
          Widget content;

          if (state is TaskLoading) {
            content = const TaskShimmerLoading();
          } else if (state is TaskEmpty) {
            content = TaskEmptyState(
              onRefresh: () {
                context.read<TaskBloc>().add(FetchTasksEvent());
              },
            );
          } else if (state is TaskLoaded) {
            content = ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: state.tasks[index]);
              },
            );
          } else {
            content = const CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Center(child: Text('Terjadi kesalahan memuat data.')),
                ),
              ],
            );
          }

          return RefreshIndicator(
            color: themeColor,
            onRefresh: () async {
              context.read<TaskBloc>().add(FetchTasksEvent());
            },
            child: content,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskPage()),
          );
          if (context.mounted) {
            context.read<TaskBloc>().add(FetchTasksEvent());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
