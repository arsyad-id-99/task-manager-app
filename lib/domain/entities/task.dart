import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isDone;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  @override
  List<Object> get props => [id, title, description, isDone];
}
