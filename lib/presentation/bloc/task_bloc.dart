import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/usecases/add_task.dart';
import 'package:task_manager_app/domain/usecases/get_tasks.dart';
import 'package:task_manager_app/domain/usecases/update_task_status.dart';
import 'package:task_manager_app/presentation/bloc/task_event.dart';
import 'package:task_manager_app/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTaskStatus updateTaskStatus;
  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTaskStatus,
  }) : super(TaskInitial()) {
    on<FetchTasksEvent>((event, emit) async {
      if (state is! TaskLoading) {
        emit(TaskLoading());
      }
      final result = await getTasks();
      result.fold(
        (failure) => emit(TaskError(message: failure.toString())),
        (tasks) =>
            tasks.isEmpty ? emit(TaskEmpty()) : emit(TaskLoaded(tasks: tasks)),
      );
    });

    on<AddTaskEvent>((event, emit) async {
      emit(TaskActionInProgress());
      final result = await addTask(event.task);
      result.fold((failure) => emit(TaskError(message: failure.toString())), (
        success,
      ) {
        emit(TaskActionSuccess(message: 'Task added successfully'));
        add(FetchTasksEvent());
      });
    });

    on<UpdateTaskStatusEvent>((event, emit) async {
      final currentState = state;
      if (currentState is TaskLoaded) {
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.id) {
            return Task(
              id: task.id,
              title: task.title,
              description: task.description,
              isDone: event.isDone,
            );
          }
          return task;
        }).toList();
        emit(TaskLoaded(tasks: updatedTasks));
      }
      final result = await updateTaskStatus(event.id, event.isDone);
      result.fold((failure) {
        emit(TaskError(message: failure.toString()));
        if (currentState is TaskLoaded) {
          emit(TaskLoaded(tasks: currentState.tasks));
        }
      }, (success) {});
    });
  }
}
