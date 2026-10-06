import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/presentation/project/theme/project_colors.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_widgets.dart';

class ProjectFormDialog extends StatefulWidget {
  final List<ProjectClientOption> clients;
  final ProjectEntity? project;
  final String? versionId;

  const ProjectFormDialog({
    super.key,
    required this.clients,
    this.project,
    this.versionId,
  });

  bool get isEdit => project != null;

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _duration;
  late final TextEditingController _subtotal;
  late final TextEditingController _profit;
  late final TextEditingController _discount;
  late final TextEditingController _tax;
  late final TextEditingController _paymentTerms;
  String? _clientId;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _validUntil;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _title = TextEditingController(text: project?.title ?? '');
    _description = TextEditingController(text: project?.description ?? '');
    _duration = TextEditingController(text: project?.duration ?? '');
    _subtotal = TextEditingController(text: _fmt(project?.subTotal ?? 0));
    _profit = TextEditingController(text: _fmt(project?.profitPercentage ?? 0));
    _discount = TextEditingController(text: _fmt(project?.discount ?? 0));
    _tax = TextEditingController(text: _fmt(project?.tax ?? 0));
    _paymentTerms = TextEditingController(text: project?.paymentTerms ?? '');
    _startDate = project?.startDate;
    _endDate = project?.endDate;
    _validUntil = project?.validUntil;

    final knownClient =
        project?.clientId != null &&
        widget.clients.any((c) => c.id == project!.clientId);
    if (knownClient) {
      _clientId = project!.clientId;
    } else if (widget.clients.isNotEmpty) {
      _clientId = widget.clients.first.id;
    }
  }

  static String _fmt(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  @override
  void dispose() {
    for (final controller in [
      _title,
      _description,
      _duration,
      _subtotal,
      _profit,
      _discount,
      _tax,
      _paymentTerms,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  double _number(TextEditingController controller) =>
      double.tryParse(controller.text.trim()) ?? 0;

  String _date(DateTime? date) =>
      date == null ? 'Select date' : projectDateIso(date);

  Future<void> _pickDate(
    ValueChanged<DateTime> onSelected,
    DateTime? initial,
  ) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) onSelected(selected);
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _clientId == null) return;
    final duration = _duration.text.trim();
    final terms = _paymentTerms.text.trim();

    if (widget.isEdit) {
      Navigator.pop(
        context,
        ProjectUpdateInput(
          versionId: widget.versionId,
          clientId: _clientId!,
          title: _title.text.trim(),
          description: _description.text.trim(),
          startDate: _startDate,
          endDate: _endDate,
          duration: duration,
          subTotal: _number(_subtotal),
          profitPercentage: _number(_profit),
          discount: _number(_discount),
          tax: _number(_tax),
          validUntil: _validUntil,
          paymentTerms: terms,
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      ProjectInput(
        clientId: _clientId!,
        title: _title.text.trim(),
        description: _description.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        duration: duration,
        subTotal: _number(_subtotal),
        issueDate: DateTime.now(),
        validUntil: _validUntil,
        paymentTerms: terms,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
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
                    ProjectIconTile(
                      icon: isEdit
                          ? Icons.edit_outlined
                          : Icons.create_new_folder_outlined,
                      size: 44,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEdit ? 'Edit Project' : 'Create New Project',
                        style: const TextStyle(
                          color: ProjectColors.title,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: ProjectColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ProjectField(
                  controller: _title,
                  label: 'Project Title',
                  requiredField: true,
                ),
                ProjectField(
                  controller: _description,
                  label: 'Description',
                  requiredField: true,
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  value: _clientId,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(16),
                  decoration: projectInputDecoration('Select Client'),
                  items: widget.clients
                      .map(
                        (client) => DropdownMenuItem(
                          value: client.id,
                          child: Text(
                            client.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _clientId = value),
                  validator: (value) =>
                      value == null ? 'Select a client' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ProjectDateField(
                        label: 'Start Date',
                        value: _date(_startDate),
                        onTap: () => _pickDate(
                          (value) => setState(() => _startDate = value),
                          _startDate,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ProjectDateField(
                        label: 'End Date',
                        value: _date(_endDate),
                        onTap: () => _pickDate(
                          (value) => setState(() => _endDate = value),
                          _endDate,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ProjectField(controller: _duration, label: 'Duration'),
                ProjectField(
                  controller: _subtotal,
                  label: 'Subtotal',
                  numeric: true,
                ),
                if (isEdit) ...[
                  ProjectField(
                    controller: _profit,
                    label: 'Profit Percentage',
                    numeric: true,
                  ),
                  ProjectField(
                    controller: _discount,
                    label: 'Discount Percentage',
                    numeric: true,
                  ),
                  ProjectField(
                    controller: _tax,
                    label: 'Tax Percentage',
                    numeric: true,
                  ),
                ],
                ProjectDateField(
                  label: 'Valid Until',
                  value: _date(_validUntil),
                  onTap: () => _pickDate(
                    (value) => setState(() => _validUntil = value),
                    _validUntil,
                  ),
                ),
                const SizedBox(height: 12),
                ProjectField(controller: _paymentTerms, label: 'Payment Terms'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ProjectButton(
                        label: 'Cancel',
                        kind: ProjectButtonKind.tonal,
                        expand: true,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ProjectButton(
                        label: isEdit ? 'Save Changes' : 'Save Project',
                        expand: true,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
