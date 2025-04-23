import 'package:flutter/material.dart';
import 'dream_journal_entry.dart';
import 'package:table_calendar/table_calendar.dart';

class NeuraDreamCalendarNavigator extends StatefulWidget {
  final List<DreamJournalEntry> dreamEntries;

  NeuraDreamCalendarNavigator({required this.dreamEntries});

  @override
  _NeuraDreamCalendarNavigatorState createState() =>
      _NeuraDreamCalendarNavigatorState();
}

class _NeuraDreamCalendarNavigatorState
    extends State<NeuraDreamCalendarNavigator> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<DreamJournalEntry>> _entryMap;

  @override
  void initState() {
    super.initState();
    _entryMap = _groupEntriesByDate(widget.dreamEntries);
  }

  Map<DateTime, List<DreamJournalEntry>> _groupEntriesByDate(
      List<DreamJournalEntry> entries) {
    final Map<DateTime, List<DreamJournalEntry>> data = {};
    for (var e in entries) {
      final d = DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day);
      data[d] = data[d] ?? [];
      data[d]!.add(e);
    }
    return data;
  }

  List<DreamJournalEntry> _getEntriesForDay(DateTime day) {
    return _entryMap[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dream Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEntriesForDay,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                  color: Colors.cyanAccent, shape: BoxShape.circle),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _getEntriesForDay(_selectedDay ?? _focusedDay)
                  .map((entry) => ListTile(
                        title: Text(
                            "${entry.timestamp.toLocal().toString().split(' ')[0]} - ${entry.emotion}"),
                        subtitle: Text(entry.interpretation),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}