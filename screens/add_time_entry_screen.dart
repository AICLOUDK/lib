import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/time_entry.dart';
import '../provider/time_entry_provider.dart';
import '../provider/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedProjectId;
  String? selectedTaskId;
  double totalTime = 0.0;
  DateTime selectedDate = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);
    final projects = projectProvider.projects;
    final tasks = projectProvider.tasks;

    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Project'),
                value: selectedProjectId,
                items: projects
                    .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedProjectId = val;
                  });
                },
                validator: (val) => val == null ? 'Please select a project' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Task'),
                value: selectedTaskId,
                items: tasks
                    .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedTaskId = val;
                  });
                },
                validator: (val) => val == null ? 'Please select a task' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter total time';
                  if (double.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
                onSaved: (val) => totalTime = double.parse(val!),
              ),
              ListTile(
                title: Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (val) => val == null || val.isEmpty ? 'Please enter notes' : null,
                onSaved: (val) => notes = val!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save Entry'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newEntry = TimeEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      projectId: selectedProjectId!,
                      taskId: selectedTaskId!,
                      totalTime: totalTime,
                      date: selectedDate,
                      notes: notes,
                    );
                    Provider.of<TimeEntryProvider>(context, listen: false).addTimeEntry(newEntry);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}