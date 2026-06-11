import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/domain/repositories/auth_repository.dart';
import 'package:task_manager_app/domain/usecases/auth.dart';

import 'core/network/auth_interceptor.dart';
import 'core/network/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/task_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/update_task_status.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/pages/auth_page.dart';
import 'presentation/pages/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Init SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  final authLocalDataSource = AuthLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  // 2. Init Dio & AuthInterceptor
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  dio.interceptors.add(AuthInterceptor(localDataSource: authLocalDataSource));

  // 3. Init Data Sources & Repositories
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );

  final taskRemoteDataSource = TaskRemoteDataSourceImpl(dio: dio);
  final taskRepository = TaskRepositoryImpl(
    remoteDataSource: taskRemoteDataSource,
  );

  // 4. Init UseCases
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  final getTasks = GetTasks(taskRepository);
  final addTask = AddTask(taskRepository);
  final updateTaskStatus = UpdateTaskStatus(taskRepository);

  // 5. Check status login
  final isLoggedIn = await authRepository.isLoggedIn();

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      getTasks: getTasks,
      addTask: addTask,
      updateTaskStatus: updateTaskStatus,
      initialRouteIsTask: isLoggedIn,
      authRepository: authRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTaskStatus updateTaskStatus;
  final bool initialRouteIsTask;
  final AuthRepository authRepository;

  const MyApp({
    Key? key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getTasks,
    required this.addTask,
    required this.updateTaskStatus,
    required this.initialRouteIsTask,
    required this.authRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF174DB1);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            authRepository: authRepository,
          ),
        ),
        BlocProvider(
          create: (_) => TaskBloc(
            getTasks: getTasks,
            addTask: addTask,
            updateTaskStatus: updateTaskStatus,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task Tracker App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeColor,
            primary: themeColor,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: themeColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
        home: initialRouteIsTask ? TaskListPage() : AuthPage(),
      ),
    );
  }
}
