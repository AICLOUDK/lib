import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage = Localstorage('time_entries');
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  Future<void> loadEntries() async {
    await storage.ready;
    final data = storage.getItem('entries') as List<dynamic>? ?? [];
    _entries = data.map((json) => TimeEntry.fromJson(json)).toList();
    notifyListeners();
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    saveEntries();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    saveEntries();
    notifyListeners();
  }

  void saveEntries() {
    final data = _entries.map((e) => e.toJson()).toList();
    storage.setItem('entries', data);
  }
}