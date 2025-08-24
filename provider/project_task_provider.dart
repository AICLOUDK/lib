import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/project.dart';
import '../models/task.dart';

class ProjectTaskProvider with ChangeNotifier {
  final LocalStorage storage = Localstorage('projects_tasks');

  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  Future<void> loadProjectsTasks() async {
    await storage.ready;

    final projectsData = storage.getItem('projects') as List<dynamic>? ?? [];
    _projects = projectsData.map((json) => Project(id: json['id'], name: json['name'])).toList();

    final tasksData = storage.getItem('tasks') as List<dynamic>? ?? [];
    _tasks = tasksData.map((json) => Task(id: json['id'], name: json['name'])).toList();

    notifyListeners();
  }

  void addProject(Project project) {
    _projects.add(project);
    saveProjects();
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void saveProjects() {
    storage.setItem('projects', _projects.map((p) => {'id': p.id, 'name': p.name}).toList());
  }

  void saveTasks() {
    storage.setItem('tasks', _tasks.map((t) => {'id': t.id, 'name': t.name}).toList());
  }
}