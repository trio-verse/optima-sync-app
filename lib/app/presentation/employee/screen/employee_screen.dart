import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/app/presentation/employee/bloc/employee_bloc.dart';
import 'package:optima_sync_v2/app/presentation/employee/bloc/employee_event.dart';
import 'package:optima_sync_v2/app/presentation/employee/bloc/employee_state.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:optima_sync_v2/core/widgets/app_drawer.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(const LoadEmployees());
  }

  void _openForm([EmployeeEntity? employee]) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EmployeeFormDialog(employee: employee),
    );
  }

  Future<void> _confirmDelete(EmployeeEntity employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove employee?'),
        content: Text('This will remove ${employee.name} from Employees.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<EmployeeBloc>().add(DeleteEmployeeSubmitted(employee.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      drawer: const AppDrawer(selectedItem: 'Employees'),
      appBar: AppBar(
        backgroundColor: AppPallete.cardBackground,
        surfaceTintColor: AppPallete.cardBackground,
        title: const Text(
          'Employees',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeLoaded && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
          if (state is EmployeeFailure && state.employees.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is EmployeeInitial || state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeFailure && state.employees.isEmpty) {
            return _EmployeeError(
              message: state.message,
              onRetry: () => context.read<EmployeeBloc>().add(
                const LoadEmployees(),
              ),
            );
          }

          final employees = switch (state) {
            EmployeeLoaded(:final employees) => employees,
            EmployeeWorking(:final employees) => employees,
            EmployeeFailure(:final employees) => employees,
            _ => const <EmployeeEntity>[],
          };

          return RefreshIndicator(
            onRefresh: () async {
              context.read<EmployeeBloc>().add(const LoadEmployees());
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              children: [
                _EmployeeHeader(onAdd: () => _openForm()),
                const SizedBox(height: 16),
                if (state is EmployeeWorking)
                  const LinearProgressIndicator(minHeight: 2),
                if (employees.isEmpty)
                  const _EmployeeEmpty()
                else
                  ...employees.map(
                    (employee) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _EmployeeCard(
                        employee: employee,
                        onEdit: () => _openForm(employee),
                        onDelete: () => _confirmDelete(employee),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmployeeHeader extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmployeeHeader({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Employees',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Manage the people who work with your organization.',
                style: TextStyle(color: AppPallete.textSecondary),
              ),
            ],
          );
          final button = FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Employee'),
          );

          if (constraints.maxWidth < 480) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [copy, const SizedBox(height: 14), button],
            );
          }
          return Row(
            children: [
              const Expanded(child: copy),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeCard({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppPallete.salesPrimarySoft,
                child: Text(
                  employee.name.isEmpty ? '?' : employee.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppPallete.salesPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      employee.position,
                      style: const TextStyle(color: AppPallete.textSecondary),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          const Divider(height: 26),
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: [
              _Info(label: 'Email', value: employee.email),
              _Info(label: 'Phone', value: employee.phone),
              _Info(
                label: 'Cost / Hour',
                value: '\$${employee.costPerHour.toStringAsFixed(2)}',
              ),
              _Info(
                label: 'Hours / Point',
                value: '${employee.hoursPerPoint}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;
  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppPallete.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(value, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class EmployeeFormDialog extends StatefulWidget {
  final EmployeeEntity? employee;
  const EmployeeFormDialog({super.key, this.employee});

  @override
  State<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _position;
  late final TextEditingController _cost;
  late final TextEditingController _hours;

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    _name = TextEditingController(text: employee?.name ?? '');
    _email = TextEditingController(text: employee?.email ?? '');
    _phone = TextEditingController(text: employee?.phone ?? '');
    _position = TextEditingController(text: employee?.position ?? '');
    _cost = TextEditingController(
      text: employee == null ? '' : employee.costPerHour.toString(),
    );
    _hours = TextEditingController(
      text: employee == null ? '' : employee.hoursPerPoint.toString(),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _position.dispose();
    _cost.dispose();
    _hours.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final input = EmployeeInput(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      position: _position.text.trim(),
      costPerHour: double.parse(_cost.text.trim()),
      hoursPerPoint: int.parse(_hours.text.trim()),
    );

    final bloc = context.read<EmployeeBloc>();
    if (_isEditing) {
      bloc.add(UpdateEmployeeSubmitted(widget.employee!.id, input));
    } else {
      bloc.add(CreateEmployeeSubmitted(input));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeLoaded && state.message != null) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final working = state is EmployeeWorking;
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppPallete.salesPrimarySoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1_outlined,
                            color: AppPallete.salesPrimary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _isEditing ? 'Edit Employee' : 'Add Employee',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: working ? null : () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _FormField(controller: _name, label: 'Name', validator: _required),
                    _FormField(
                      controller: _email,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final required = _required(value);
                        if (required != null) return required;
                        return value!.contains('@') ? null : 'Enter a valid email';
                      },
                    ),
                    _FormField(
                      controller: _phone,
                      label: 'Phone',
                      keyboardType: TextInputType.phone,
                      validator: _required,
                    ),
                    _FormField(
                      controller: _position,
                      label: 'Position',
                      validator: _required,
                    ),
                    _FormField(
                      controller: _cost,
                      label: 'Cost Per Hour',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final number = double.tryParse(value?.trim() ?? '');
                        return number == null || number < 0
                            ? 'Enter a valid amount'
                            : null;
                      },
                    ),
                    _FormField(
                      controller: _hours,
                      label: 'Hours Per Point',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final number = int.tryParse(value?.trim() ?? '');
                        return number == null || number < 1
                            ? 'Enter at least 1'
                            : null;
                      },
                    ),
                    if (state is EmployeeFailure) ...[
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: working ? null : () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: working ? null : _submit,
                            child: working
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(_isEditing ? 'Update Employee' : 'Add Employee'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppPallete.inputFill,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _EmployeeEmpty extends StatelessWidget {
  const _EmployeeEmpty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          Icon(Icons.badge_outlined, size: 50, color: AppPallete.textSecondary),
          SizedBox(height: 12),
          Text('No employees yet.'),
        ],
      ),
    );
  }
}

class _EmployeeError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _EmployeeError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
