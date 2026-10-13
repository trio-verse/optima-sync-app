import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_widgets.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_state.dart';
import 'package:optima_sync_v2/app/presentation/task/widgets/task_widgets.dart';

class TaskFilterSheet extends StatefulWidget {
  final TaskManagerData data;
  const TaskFilterSheet({super.key, required this.data});
  @override
  State<TaskFilterSheet> createState() => _TaskFilterSheetState();
}

class _TaskFilterSheetState extends State<TaskFilterSheet> {
  String? _memberId;
  String? _categoryId;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _error;

  @override
  void initState() {
    super.initState();
    final filter = widget.data.filter;
    _memberId = filter.memberId;
    _categoryId = filter.categoryId;
    _fromDate = filter.fromDate;
    _toDate = filter.toDate;
  }

  Future<void> _pickDate(bool from) async {
    final selected = from ? _fromDate : _toDate;
    final now = DateTime.now();
    final initial = selected ?? (from ? _toDate : _fromDate) ?? now;
    final result = await showDatePicker(
      context: context, initialDate: initial,
      firstDate: DateTime(initial.year < 2000 ? initial.year : 2000),
      lastDate: DateTime(initial.year > now.year + 30 ? initial.year + 1 : now.year + 30, 12, 31),
    );
    if (result != null && mounted) setState(() {
      if (from) { _fromDate = result; } else { _toDate = result; }
      _error = null;
    });
  }

  void _apply() {
    final filter = TaskFilter(
      memberId: _memberId, categoryId: _categoryId,
      fromDate: _fromDate, toDate: _toDate,
    ).forAccess(widget.data.access);
    if (!filter.isValid) {
      setState(() => _error = 'From date must be before or equal to To date.');
      return;
    }
    Navigator.pop(context, filter);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final memberId = data.members.any((member) => member.id == _memberId) ? _memberId : null;
    final categoryId = data.categories.any((category) => category.id == _categoryId) ? _categoryId : null;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Filter Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            if (data.access.isManager) ...[
              DropdownButtonFormField<String>(
                value: memberId,
                isExpanded: true,
                decoration: taskInputDecoration('Member'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All members')),
                  ...data.members.map((member) => DropdownMenuItem(
                    value: member.id, child: Text(member.displayName, overflow: TextOverflow.ellipsis),
                  )),
                ],
                onChanged: (value) => setState(() => _memberId = value),
              ),
              const SizedBox(height: 12),
            ],
            DropdownButtonFormField<String>(
              value: categoryId,
              isExpanded: true,
              decoration: taskInputDecoration('Category'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All categories')),
                ...data.categories.map((category) => DropdownMenuItem(
                  value: category.id, child: Text(category.name, overflow: TextOverflow.ellipsis),
                )),
              ],
              onChanged: (value) => setState(() => _categoryId = value),
            ),
            const SizedBox(height: 12),
            _dateField('From due date', _fromDate, () => _pickDate(true), () => setState(() => _fromDate = null)),
            const SizedBox(height: 12),
            _dateField('To due date', _toDate, () => _pickDate(false), () => setState(() => _toDate = null)),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context, const TaskFilter().forAccess(data.access)),
                child: const Text('Reset'),
              )),
              const SizedBox(width: 10),
              Expanded(child: FilledButton(
                style: taskButtonStyle(), onPressed: _apply, child: const Text('Apply Filters'),
              )),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _dateField(String label, DateTime? value, VoidCallback pick, VoidCallback clear) =>
      InputDecorator(
        decoration: taskInputDecoration(label, icon: Icons.calendar_today_outlined),
        child: Row(children: [
          Expanded(child: InkWell(
            onTap: pick,
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(value == null ? 'Any date' : projectDateShort(value)),
            ),
          )),
          if (value != null) IconButton(onPressed: clear, tooltip: 'Clear date', icon: const Icon(Icons.close, size: 18)),
        ]),
      );
}
