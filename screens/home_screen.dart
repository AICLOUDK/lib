import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/time_entry_provider.dart';
import 'add_time_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Time Entries'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'By Project'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllEntriesTab(),
            GroupedByProjectTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddTimeEntryScreen()));
          },
          child: Icon(Icons.add),
          tooltip: 'Add Time Entry',
        ),
      ),
    );
  }
}

class AllEntriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, _) {
        final entries = provider.entries;
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (_, index) {
            final entry = entries[index];
            return ListTile(
              title: Text('Project: ${entry.projectId} - ${entry.totalTime} hrs'),
              subtitle: Text('Date: ${entry.date.toLocal().toString().split(' ')[0]} \nNotes: ${entry.notes}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  provider.deleteTimeEntry(entry.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class GroupedByProjectTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, _) {
        final grouped = <String, List<TimeEntry>>{};
        for (var entry in provider.entries) {
          grouped.putIfAbsent(entry.projectId, () => []).add(entry);
        }
        return ListView(
          children: grouped.entries.map((e) {
            final projectId = e.key;
            final entries = e.value;
            final totalTime = entries.fold(0.0, (sum, item) => sum + item.totalTime);
            return ExpansionTile(
              title: Text('Project: $projectId'),
              subtitle: Text('Total Time: $totalTime hrs'),
              children: entries.map((entry) {
                return ListTile(
                  title: Text('${entry.totalTime} hrs'),
                  subtitle: Text('Notes: ${entry.notes}'),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}