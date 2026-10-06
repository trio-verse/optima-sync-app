import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_details_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/project_usecases.dart';
import 'package:optima_sync_v2/app/presentation/project/theme/project_colors.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_form_dialog.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_widgets.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';
import 'package:optima_sync_v2/service_locator.dart';

const int _kOverview = 0;
const int _kVersions = 1;
const int _kFeatures = 2;
const int _kCosts = 3;
const int _kTeam = 4;
const int _kMeetings = 5;

ProjectVersionEntity? _selectedVersionOf(ProjectDetailsData data) {
  for (final item in data.versions) {
    if (item.id == data.selectedVersionId) return item;
  }
  return null;
}

String? _nonEmpty(String? value) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? null : text;
}

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  final ProjectEntity initialProject;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    required this.initialProject,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final ProjectUsecases _usecases = sl<ProjectUsecases>();
  ProjectDetailsData? _data;
  String? _error;
  bool _loading = true;
  bool _working = false;
  int _tab = _kOverview;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    final result = await _usecases.getProjectDetails(widget.projectId);
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _error = 'Unable to load project details.';
        _loading = false;
      }),
      (data) => setState(() {
        _data = data;
        _error = null;
        _loading = false;
      }),
    );
  }

  Future<void> _perform<T>(
    Future<Either<WhateverFailure, T>> operation,
    String successMessage,
  ) async {
    setState(() => _working = true);
    final result = await operation;
    if (!mounted) return;
    var succeeded = false;
    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The request failed. Please try again.')),
      ),
      (_) {
        succeeded = true;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(successMessage)));
      },
    );
    if (succeeded) await _load(silent: true);
    if (mounted) setState(() => _working = false);
  }

  Future<void> _previewQuotation() async {
    final data = _data;
    final versionId = data?.selectedVersionId;
    if (versionId == null) {
      _showMessage('No project version is available for preview.');
      return;
    }
    setState(() => _working = true);
    final result = await _usecases.previewQuotation(
      widget.projectId,
      versionId,
    );
    if (!mounted) return;
    setState(() => _working = false);
    result.fold((_) => _showMessage('Unable to preview the quotation.'), (
      html,
    ) {
      final text = html
          .replaceAll(RegExp(r'<script[\s\S]*?</script>'), '')
          .replaceAll(RegExp(r'<style[\s\S]*?</style>'), '')
          .replaceAll(RegExp(r'<[^>]+>'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Quotation Preview',
            style: TextStyle(
              color: ProjectColors.title,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SizedBox(
            width: 620,
            child: SingleChildScrollView(
              child: SelectableText(
                text.isEmpty ? html : text,
                style: const TextStyle(color: ProjectColors.body, height: 1.4),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: ProjectColors.primary),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _generatePdf() async {
    final versionId = _data?.selectedVersionId;
    if (versionId == null) {
      _showMessage('No project version is available for PDF generation.');
      return;
    }
    await _perform(
      _usecases.generateQuotationPdf(widget.projectId, versionId),
      'Quotation PDF generated successfully.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _editProject() async {
    final data = _data;
    if (data == null) return;
    setState(() => _working = true);
    final clientsResult = await _usecases.getClients();
    if (!mounted) return;
    setState(() => _working = false);
    final clients = clientsResult.getOrElse(() => const []);
    if (clients.isEmpty) {
      _showMessage('Unable to load clients. Please try again.');
      return;
    }
    final result = await showDialog<Object>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectFormDialog(
        clients: clients,
        project: data.project,
        versionId: data.selectedVersionId,
      ),
    );
    if (!mounted || result is! ProjectUpdateInput) return;
    await _perform(
      _usecases.updateProject(widget.projectId, result),
      'Project updated successfully.',
    );
  }

  Future<void> _featureForm([ProjectFeatureEntity? feature]) async {
    final input = await showDialog<ProjectFeatureInput>(
      context: context,
      builder: (_) => _FeatureDialog(feature: feature),
    );
    if (input == null) return;
    await _perform(
      feature == null
          ? _usecases.createFeature(widget.projectId, input)
          : _usecases.updateFeature(widget.projectId, feature.id, input),
      feature == null ? 'Feature added.' : 'Feature updated.',
    );
  }

  Future<void> _costForm([ProjectCostEntity? cost]) async {
    final input = await showDialog<ProjectCostInput>(
      context: context,
      builder: (_) => _CostDialog(cost: cost),
    );
    if (input == null) return;
    await _perform(
      cost == null
          ? _usecases.createCost(widget.projectId, input)
          : _usecases.updateCost(widget.projectId, cost.id, input),
      cost == null ? 'Cost item added.' : 'Cost item updated.',
    );
  }

  Future<void> _teamForm([ProjectEmployeeEntity? assignment]) async {
    final data = _data;
    if (data == null) return;
    final input = await showDialog<_TeamInput>(
      context: context,
      builder: (_) => _TeamDialog(
        employees: data.availableEmployees,
        assignment: assignment,
      ),
    );
    if (input == null) return;
    await _perform(
      assignment == null
          ? _usecases.addProjectEmployee(
              widget.projectId,
              input.employeeId,
              input.points,
            )
          : _usecases.updateProjectEmployee(
              widget.projectId,
              assignment.id,
              input.points,
            ),
      assignment == null ? 'Team member added.' : 'Team member updated.',
    );
  }

  Future<void> _meetingForm([ProjectMeetingEntity? meeting]) async {
    final input = await showDialog<ProjectMeetingInput>(
      context: context,
      builder: (_) => _MeetingDialog(meeting: meeting),
    );
    if (input == null) return;
    await _perform(
      meeting == null
          ? _usecases.createMeeting(widget.projectId, input)
          : _usecases.updateMeeting(widget.projectId, meeting.id, input),
      meeting == null ? 'Meeting scheduled.' : 'Meeting updated.',
    );
  }

  Future<bool> _confirmDelete(String name) => showProjectConfirmDialog(
    context,
    title: 'Delete item?',
    message: 'Delete $name?',
  );

  void _selectVersion(String versionId) {
    final data = _data;
    if (data == null) return;
    setState(() => _data = data.copyWith(selectedVersionId: versionId));
  }

  void _selectTab(int index) => setState(() => _tab = index);

  Future<void> _showAddSheet() async {
    final choice = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Add to project',
                  style: TextStyle(
                    color: ProjectColors.title,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _SheetOption(
                icon: Icons.auto_awesome,
                label: 'Add New Feature',
                onTap: () => Navigator.pop(sheetContext, _kFeatures),
              ),
              _SheetOption(
                icon: Icons.receipt_long_outlined,
                label: 'Add Cost Item',
                onTap: () => Navigator.pop(sheetContext, _kCosts),
              ),
              _SheetOption(
                icon: Icons.group_add_outlined,
                label: 'Add Team Member',
                onTap: () => Navigator.pop(sheetContext, _kTeam),
              ),
              _SheetOption(
                icon: Icons.event_outlined,
                label: 'Schedule Meeting',
                onTap: () => Navigator.pop(sheetContext, _kMeetings),
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == _kFeatures) {
      await _featureForm();
    } else if (choice == _kCosts) {
      await _costForm();
    } else if (choice == _kTeam) {
      await _teamForm();
    } else if (choice == _kMeetings) {
      await _meetingForm();
    }
  }

  void _onFabPressed() {
    switch (_tab) {
      case _kFeatures:
        _featureForm();
        break;
      case _kCosts:
        _costForm();
        break;
      case _kTeam:
        _teamForm();
        break;
      case _kMeetings:
        _meetingForm();
        break;
      default:
        _showAddSheet();
    }
  }

  Widget? _buildFab() {
    if (_loading || _error != null || _data == null || _tab == _kVersions) {
      return null;
    }
    return FloatingActionButton(
      onPressed: _working ? null : _onFabPressed,
      backgroundColor: ProjectColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.background,
      floatingActionButton: _buildFab(),
      appBar: AppBar(
        backgroundColor: ProjectColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: ProjectColors.title),
        title: const Text(
          'Project Details',
          style: TextStyle(
            color: ProjectColors.title,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit project',
            onPressed: _data == null || _working ? null : _editProject,
            icon: const Icon(Icons.edit_outlined, color: ProjectColors.title),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: ProjectColors.primary),
            )
          : _error != null
          ? _DetailsError(message: _error!, onRetry: () => _load())
          : _buildContent(_data!),
    );
  }

  Widget _buildContent(ProjectDetailsData data) {
    return Column(
      children: [
        if (_working)
          const LinearProgressIndicator(
            minHeight: 3,
            color: ProjectColors.primary,
            backgroundColor: ProjectColors.primarySoft,
          ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: _tab == _kOverview
                      ? _OverviewHeader(
                          data: data,
                          onSelectVersion: _selectVersion,
                          onPreview: _previewQuotation,
                          onGeneratePdf: _generatePdf,
                        )
                      : _CompactBar(
                          data: data,
                          onSelectVersion: _selectVersion,
                          onPreview: _previewQuotation,
                          onGeneratePdf: _generatePdf,
                        ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedHeaderDelegate(
                  height: 64,
                  child: _TabPills(
                    selected: _tab,
                    onSelected: _selectTab,
                    counts: [
                      null,
                      data.versions.length,
                      data.features.length,
                      data.costs.length,
                      data.team.length,
                      data.meetings.length,
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  child: _tabBody(data),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabBody(ProjectDetailsData data) {
    switch (_tab) {
      case _kVersions:
        return _VersionsTab(data: data, onSelect: _selectVersion);
      case _kFeatures:
        return _FeaturesTab(
          features: data.features,
          onAdd: () => _featureForm(),
          onEdit: _featureForm,
          onDelete: (feature) async {
            if (await _confirmDelete(feature.name)) {
              await _perform(
                _usecases.deleteFeature(widget.projectId, feature.id),
                'Feature deleted.',
              );
            }
          },
        );
      case _kCosts:
        return _CostsTab(
          costs: data.costs,
          subTotal: data.project.subTotal,
          onAdd: () => _costForm(),
          onEdit: _costForm,
          onDelete: (cost) async {
            if (await _confirmDelete(cost.name)) {
              await _perform(
                _usecases.deleteCost(widget.projectId, cost.id),
                'Cost item deleted.',
              );
            }
          },
        );
      case _kTeam:
        return _TeamTab(
          team: data.team,
          onAdd: () => _teamForm(),
          onEdit: _teamForm,
          onDelete: (assignment) async {
            if (await _confirmDelete(
              assignment.employee?.name ?? 'team member',
            )) {
              await _perform(
                _usecases.deleteProjectEmployee(
                  widget.projectId,
                  assignment.id,
                ),
                'Team member removed.',
              );
            }
          },
        );
      case _kMeetings:
        return _MeetingsTab(
          meetings: data.meetings,
          onAdd: () => _meetingForm(),
          onEdit: _meetingForm,
          onDelete: (meeting) async {
            if (await _confirmDelete(meeting.title)) {
              await _perform(
                _usecases.deleteMeeting(widget.projectId, meeting.id),
                'Meeting deleted.',
              );
            }
          },
        );
      default:
        return _OverviewTab(data: data);
    }
  }
}

class _OverviewHeader extends StatelessWidget {
  final ProjectDetailsData data;
  final ValueChanged<String> onSelectVersion;
  final VoidCallback onPreview;
  final VoidCallback onGeneratePdf;

  const _OverviewHeader({
    required this.data,
    required this.onSelectVersion,
    required this.onPreview,
    required this.onGeneratePdf,
  });

  @override
  Widget build(BuildContext context) {
    final project = data.project;
    final version = _selectedVersionOf(data);
    final created = project.createdAt;
    final industry = _nonEmpty(project.industryName);
    final reference = _nonEmpty(project.referenceNumber);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (industry != null || reference != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (industry != null)
                  ProjectPill(
                    icon: Icons.apartment_outlined,
                    label: industry.toUpperCase(),
                    fontSize: 11,
                  ),
                if (reference != null)
                  ProjectPill(
                    icon: Icons.tag,
                    label: reference,
                    background: ProjectColors.tint,
                    foreground: ProjectColors.body,
                    fontSize: 11,
                  ),
              ],
            ),
          ),
        ProjectSurface(
          padding: const EdgeInsets.all(18),
          radius: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProjectIconTile(
                    icon: Icons.apartment,
                    size: 64,
                    radius: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                project.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ProjectColors.title,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (version != null) ...[
                              const SizedBox(width: 8),
                              ProjectPill(
                                label: 'V${version.id}',
                                background: ProjectColors.primarySoft,
                                foreground: ProjectColors.primary,
                                fontSize: 11,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        _MetaLine(
                          icon: Icons.business_center_outlined,
                          text: 'Client: ${project.clientName ?? '—'}',
                        ),
                        const SizedBox(height: 4),
                        _MetaLine(
                          icon: Icons.calendar_today_outlined,
                          text: created == null
                              ? 'Created —'
                              : 'Created ${projectDateShort(created)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (data.versions.isNotEmpty) ...[
                const SizedBox(height: 16),
                _VersionSelector(data: data, onSelectVersion: onSelectVersion),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProjectButton(
                      label: 'Preview',
                      icon: Icons.visibility_outlined,
                      kind: ProjectButtonKind.tonal,
                      height: 54,
                      expand: true,
                      onPressed: onPreview,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ProjectButton(
                      label: 'Generate PDF',
                      icon: Icons.picture_as_pdf_outlined,
                      height: 54,
                      expand: true,
                      onPressed: onGeneratePdf,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: ProjectColors.muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ProjectColors.body,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _VersionSelector extends StatelessWidget {
  final ProjectDetailsData data;
  final ValueChanged<String> onSelectVersion;

  const _VersionSelector({required this.data, required this.onSelectVersion});

  @override
  Widget build(BuildContext context) {
    final version = _selectedVersionOf(data);
    final title = version?.title ?? 'Select version';
    final isActive = version?.isActive ?? false;

    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: onSelectVersion,
      itemBuilder: (_) => data.versions
          .map(
            (item) => PopupMenuItem<String>(
              value: item.id,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.title}  •  V${item.id}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: item.id == data.selectedVersionId
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (item.id == data.selectedVersionId)
                    const Icon(
                      Icons.check,
                      size: 18,
                      color: ProjectColors.primary,
                    ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ProjectColors.tint,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.layers_outlined, color: ProjectColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Viewing Version',
                    style: TextStyle(color: ProjectColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ProjectColors.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              const ProjectPill(
                label: 'Active',
                background: ProjectColors.cyanSoft,
                foreground: ProjectColors.teal,
                fontSize: 11,
              ),
            ],
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down, color: ProjectColors.body),
          ],
        ),
      ),
    );
  }
}

class _CompactBar extends StatelessWidget {
  final ProjectDetailsData data;
  final ValueChanged<String> onSelectVersion;
  final VoidCallback onPreview;
  final VoidCallback onGeneratePdf;

  const _CompactBar({
    required this.data,
    required this.onSelectVersion,
    required this.onPreview,
    required this.onGeneratePdf,
  });

  @override
  Widget build(BuildContext context) {
    final version = _selectedVersionOf(data);
    final canPick = data.versions.length > 1;

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ProjectColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 8, color: ProjectColors.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              data.project.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ProjectColors.title,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (version != null) ...[
            const Text(
              '  •  ',
              style: TextStyle(color: ProjectColors.muted, fontSize: 13),
            ),
            Text(
              'V${version.id}',
              style: const TextStyle(
                color: ProjectColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (canPick)
            const Icon(Icons.arrow_drop_down, color: ProjectColors.primary),
        ],
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: canPick
                ? PopupMenuButton<String>(
                    position: PopupMenuPosition.under,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: onSelectVersion,
                    itemBuilder: (_) => data.versions
                        .map(
                          (item) => PopupMenuItem<String>(
                            value: item.id,
                            child: Text('${item.title}  •  V${item.id}'),
                          ),
                        )
                        .toList(),
                    child: chip,
                  )
                : chip,
          ),
        ),
        const SizedBox(width: 10),
        ProjectSquareButton(
          icon: Icons.visibility_outlined,
          tooltip: 'Preview',
          circle: true,
          onPressed: onPreview,
        ),
        const SizedBox(width: 10),
        ProjectSquareButton(
          icon: Icons.picture_as_pdf_outlined,
          tooltip: 'Generate PDF',
          circle: true,
          onPressed: onGeneratePdf,
        ),
      ],
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const _PinnedHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) => true;
}

class _TabPills extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelected;
  final List<int?> counts;

  const _TabPills({
    required this.selected,
    required this.onSelected,
    required this.counts,
  });

  static const List<String> _labels = [
    'Overview',
    'Versions',
    'Features',
    'Costs',
    'Team',
    'Meetings',
  ];

  static const List<IconData> _icons = [
    Icons.grid_view_rounded,
    Icons.layers_outlined,
    Icons.category_outlined,
    Icons.payments_outlined,
    Icons.groups_outlined,
    Icons.event_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProjectColors.background,
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(_labels.length, (index) {
            final isSelected = index == selected;
            final count = counts[index];
            final foreground = isSelected ? Colors.white : ProjectColors.body;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                color: isSelected
                    ? ProjectColors.primary
                    : ProjectColors.primarySoft,
                elevation: isSelected ? 3 : 0,
                shadowColor: ProjectColors.primary.withValues(alpha: 0.4),
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => onSelected(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_icons[index], size: 18, color: foreground),
                        const SizedBox(width: 8),
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: foreground,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (count != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : ProjectColors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: ProjectColors.tint,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ProjectIconTile(icon: icon, size: 40, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: ProjectColors.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: ProjectColors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabHeader extends StatelessWidget {
  final String title;
  final String? titleSuffix;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAdd;

  const _TabHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAdd,
    this.titleSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            style: const TextStyle(
              color: ProjectColors.title,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
            children: [
              if (titleSuffix != null)
                TextSpan(
                  text: ' $titleSuffix',
                  style: const TextStyle(
                    color: ProjectColors.muted,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: ProjectColors.body,
            fontSize: 14,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 14),
        ProjectButton(
          label: actionLabel,
          icon: Icons.add_circle_outline,
          height: 56,
          expand: true,
          onPressed: onAdd,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String editLabel;
  final String deleteLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionRow({
    required this.editLabel,
    required this.deleteLabel,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProjectButton(
            label: editLabel,
            icon: Icons.edit_outlined,
            kind: ProjectButtonKind.tonal,
            height: 48,
            expand: true,
            onPressed: onEdit,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ProjectButton(
            label: deleteLabel,
            icon: Icons.delete_outline,
            kind: ProjectButtonKind.danger,
            height: 48,
            expand: true,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: ProjectColors.title,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _MutedText extends StatelessWidget {
  final String text;
  final int? maxLines;
  const _MutedText(this.text, {this.maxLines});

  @override
  Widget build(BuildContext context) => Text(
    text,
    maxLines: maxLines,
    overflow: maxLines == null ? null : TextOverflow.ellipsis,
    style: const TextStyle(
      color: ProjectColors.muted,
      fontSize: 14,
      height: 1.35,
    ),
  );
}

class _OverviewTab extends StatelessWidget {
  final ProjectDetailsData data;

  const _OverviewTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final project = data.project;
    final version = _selectedVersionOf(data);
    final description = _nonEmpty(project.description);
    final duration =
        _nonEmpty(version?.duration) ?? _nonEmpty(project.duration);

    final totalFeatures = data.features.length;
    final doneFeatures = data.features
        .where((feature) => feature.status == 'completed')
        .length;
    final completion = totalFeatures == 0 ? 0.0 : doneFeatures / totalFeatures;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSurface(
          padding: const EdgeInsets.all(18),
          radius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.notes, color: ProjectColors.primary),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Project Description',
                      style: TextStyle(
                        color: ProjectColors.title,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ProjectColors.tint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  description ?? 'No description provided.',
                  style: TextStyle(
                    color: description == null
                        ? ProjectColors.muted
                        : ProjectColors.body,
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ProjectSurface(
          padding: const EdgeInsets.all(18),
          radius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Version Metrics',
                      style: TextStyle(
                        color: ProjectColors.title,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  ProjectStatusBadge(status: project.status, uppercase: true),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: ProjectColors.line),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TOTAL ESTIMATED AMOUNT',
                            style: TextStyle(
                              color: ProjectColors.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  projectMoney(project.totalAmount),
                                  style: const TextStyle(
                                    color: ProjectColors.primary,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'USD',
                                  style: TextStyle(
                                    color: ProjectColors.muted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const ProjectIconTile(
                      icon: Icons.payments_outlined,
                      size: 56,
                      radius: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _PricingBreakdown(project: project),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.timelapse_rounded,
                      iconColor: ProjectColors.teal,
                      iconBackground: ProjectColors.cyanSoft,
                      label: 'Duration',
                      value: duration ?? '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.task_alt,
                      iconColor: ProjectColors.primary,
                      iconBackground: ProjectColors.primarySoft,
                      label: 'Features',
                      value: '$doneFeatures / $totalFeatures Done',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Feature Completion',
                      style: TextStyle(
                        color: ProjectColors.body,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${(completion * 100).round()}%',
                    style: const TextStyle(
                      color: ProjectColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ProjectProgressBar(value: completion, height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

String _percent(double value) =>
    '${value == value.roundToDouble() ? value.toInt() : value}%';

class _PricingBreakdown extends StatelessWidget {
  final ProjectEntity project;
  const _PricingBreakdown({required this.project});

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value, {bool strong = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: strong ? ProjectColors.title : ProjectColors.body,
                fontSize: 14,
                fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: strong ? ProjectColors.primary : ProjectColors.title,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: ProjectColors.tint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          row('Subtotal', projectMoney(project.subTotal)),
          row('Profit Percentage', _percent(project.profitPercentage)),
          row('Discount Percentage', _percent(project.discount)),
          row('Tax Percentage', _percent(project.tax)),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;

  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProjectColors.tint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ProjectIconTile(
            icon: icon,
            color: iconColor,
            background: iconBackground,
            size: 40,
            radius: 12,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ProjectColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ProjectColors.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionsTab extends StatelessWidget {
  final ProjectDetailsData data;
  final ValueChanged<String> onSelect;

  const _VersionsTab({required this.data, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (data.versions.isEmpty) {
      return const ProjectEmptyState(
        icon: Icons.layers_outlined,
        message: 'No project versions are available.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Project Versions Timeline'),
        for (final version in data.versions)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _VersionCard(
              version: version,
              selected: version.id == data.selectedVersionId,
              onTap: () => onSelect(version.id),
            ),
          ),
      ],
    );
  }
}

class _VersionCard extends StatelessWidget {
  final ProjectVersionEntity version;
  final bool selected;
  final VoidCallback onTap;

  const _VersionCard({
    required this.version,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle =
        _nonEmpty(version.changeDescription) ??
        _nonEmpty(version.description) ??
        'No change description';
    final duration = _nonEmpty(version.duration);
    final start = version.startDate;
    final end = version.endDate;

    final meta = <String>[
      if (duration != null) duration,
      if (start != null) projectDateShort(start),
      if (end != null) projectDateShort(end),
    ];

    return ProjectSurface(
      onTap: onTap,
      radius: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? ProjectColors.primary
                  : ProjectColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              'V${version.id}',
              style: TextStyle(
                color: selected ? Colors.white : ProjectColors.primary,
                fontSize: 12,
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
                  version.title,
                  style: const TextStyle(
                    color: ProjectColors.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                _MutedText(subtitle, maxLines: 2),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    meta.join('  •  '),
                    style: const TextStyle(
                      color: ProjectColors.body,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (selected || version.isActive) ...[
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (selected) const ProjectPill(label: 'Viewing', fontSize: 11),
                if (selected && version.isActive) const SizedBox(height: 6),
                if (version.isActive)
                  const ProjectPill(
                    label: 'Active',
                    background: ProjectColors.cyanSoft,
                    foreground: ProjectColors.teal,
                    fontSize: 11,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FeaturesTab extends StatelessWidget {
  final List<ProjectFeatureEntity> features;
  final VoidCallback onAdd;
  final ValueChanged<ProjectFeatureEntity> onEdit;
  final ValueChanged<ProjectFeatureEntity> onDelete;

  const _FeaturesTab({
    required this.features,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final active = features.where((f) => f.status != 'completed').length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabHeader(
          title: 'Features',
          titleSuffix: '($active active)',
          subtitle: 'Manage scope and functional deliverables.',
          actionLabel: 'Add New Feature',
          onAdd: onAdd,
        ),
        if (features.isEmpty)
          const ProjectEmptyState(
            icon: Icons.category_outlined,
            message: 'No features have been added.',
          )
        else
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _FeatureCard(
                feature: feature,
                onEdit: () => onEdit(feature),
                onDelete: () => onDelete(feature),
              ),
            ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final ProjectFeatureEntity feature;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FeatureCard({
    required this.feature,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final description = _nonEmpty(feature.description);
    return ProjectSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProjectIconTile(
                icon: Icons.category_outlined,
                size: 48,
                radius: 15,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.name,
                      style: const TextStyle(
                        color: ProjectColors.title,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Feature #${feature.id}',
                      style: const TextStyle(
                        color: ProjectColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ProjectStatusBadge(status: feature.status, uppercase: true),
            ],
          ),
          const SizedBox(height: 14),
          description == null
              ? const _MutedText('No description provided.')
              : Text(
                  description,
                  style: const TextStyle(
                    color: ProjectColors.body,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: ProjectColors.line),
          const SizedBox(height: 14),
          _ActionRow(
            editLabel: 'Edit',
            deleteLabel: 'Delete',
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _CostsTab extends StatelessWidget {
  final List<ProjectCostEntity> costs;
  final double subTotal;
  final VoidCallback onAdd;
  final ValueChanged<ProjectCostEntity> onEdit;
  final ValueChanged<ProjectCostEntity> onDelete;

  const _CostsTab({
    required this.costs,
    required this.subTotal,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final total = costs.fold<double>(0, (sum, cost) => sum + cost.total);
    final lineLabel =
        '${costs.length} line item${costs.length == 1 ? '' : 's'}';
    final hasSubtotal = subTotal > 0;
    final covered = hasSubtotal ? total / subTotal : 0.0;
    final remaining = subTotal - total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSurface(
          padding: const EdgeInsets.all(18),
          radius: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Estimated Cost',
                          style: TextStyle(
                            color: ProjectColors.body,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                projectMoney(total),
                                style: const TextStyle(
                                  color: ProjectColors.title,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'USD',
                                style: TextStyle(
                                  color: ProjectColors.muted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const ProjectIconTile(
                    icon: Icons.account_balance_wallet_outlined,
                    size: 56,
                    radius: 18,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ProjectColors.tint,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: hasSubtotal
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Project Subtotal: ${projectMoney(subTotal)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: ProjectColors.title,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(covered * 100).round()}% Covered',
                                style: const TextStyle(
                                  color: ProjectColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ProjectProgressBar(
                            value: covered,
                            height: 8,
                            background: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _MutedText(lineLabel)),
                              Text(
                                remaining >= 0
                                    ? '${projectMoney(remaining)} remaining'
                                    : '${projectMoney(-remaining)} over subtotal',
                                style: TextStyle(
                                  color: remaining >= 0
                                      ? ProjectColors.body
                                      : ProjectColors.danger,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Text(
                        lineLabel,
                        style: const TextStyle(
                          color: ProjectColors.body,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              ProjectButton(
                label: 'Add Cost Item',
                icon: Icons.add_circle_outline,
                height: 56,
                expand: true,
                onPressed: onAdd,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _SectionTitle(
          title: 'Itemized Costs',
          trailing: ProjectPill(label: '${costs.length}', fontSize: 12),
        ),
        if (costs.isEmpty)
          const ProjectEmptyState(
            icon: Icons.receipt_long_outlined,
            message: 'No cost items have been added.',
          )
        else
          for (final cost in costs)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _CostCard(
                cost: cost,
                onEdit: () => onEdit(cost),
                onDelete: () => onDelete(cost),
              ),
            ),
        if (costs.isNotEmpty && total > 0) ...[
          const SizedBox(height: 8),
          _CostDistribution(costs: costs, total: total),
        ],
      ],
    );
  }
}

class _CostCard extends StatelessWidget {
  final ProjectCostEntity cost;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CostCard({
    required this.cost,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final description = _nonEmpty(cost.description);
    return ProjectSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProjectIconTile(
                icon: Icons.receipt_long_outlined,
                size: 52,
                radius: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            cost.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ProjectColors.title,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: ProjectColors.teal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    _MutedText(description ?? 'No description', maxLines: 2),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                projectMoney(cost.total),
                style: const TextStyle(
                  color: ProjectColors.title,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: ProjectColors.tint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calculate_outlined,
                  size: 20,
                  color: ProjectColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        color: ProjectColors.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${cost.quantity} unit${cost.quantity == 1 ? '' : 's'}',
                          style: const TextStyle(color: ProjectColors.primary),
                        ),
                        const TextSpan(
                          text: '  ×  ',
                          style: TextStyle(color: ProjectColors.muted),
                        ),
                        TextSpan(text: projectMoney(cost.amount)),
                        const TextSpan(
                          text: ' / unit',
                          style: TextStyle(
                            color: ProjectColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(
                          text: '  =  ',
                          style: TextStyle(color: ProjectColors.muted),
                        ),
                        TextSpan(text: projectMoney(cost.total)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ActionRow(
            editLabel: 'Edit Cost',
            deleteLabel: 'Remove',
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _CostDistribution extends StatelessWidget {
  final List<ProjectCostEntity> costs;
  final double total;

  const _CostDistribution({required this.costs, required this.total});

  @override
  Widget build(BuildContext context) {
    return ProjectSurface(
      padding: const EdgeInsets.all(18),
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Cost Distribution',
                  style: TextStyle(
                    color: ProjectColors.title,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${costs.length} item${costs.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: ProjectColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < costs.length; i++) ...[
            _DistributionRow(
              name: costs[i].name,
              amount: costs[i].total,
              share: costs[i].total / total,
              color: ProjectColors
                  .chartPalette[i % ProjectColors.chartPalette.length],
            ),
            if (i != costs.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  final String name;
  final double amount;
  final double share;
  final Color color;

  const _DistributionRow({
    required this.name,
    required this.amount,
    required this.share,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ProjectColors.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${projectMoney(amount)}  •  ${(share * 100).round()}%',
              style: const TextStyle(
                color: ProjectColors.title,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ProjectProgressBar(value: share, color: color, height: 7),
      ],
    );
  }
}

class _TeamTab extends StatelessWidget {
  final List<ProjectEmployeeEntity> team;
  final VoidCallback onAdd;
  final ValueChanged<ProjectEmployeeEntity> onEdit;
  final ValueChanged<ProjectEmployeeEntity> onDelete;

  const _TeamTab({
    required this.team,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabHeader(
          title: 'Team',
          titleSuffix: '(${team.length} member${team.length == 1 ? '' : 's'})',
          subtitle: 'People assigned to this project and their points.',
          actionLabel: 'Add Team Member',
          onAdd: onAdd,
        ),
        if (team.isEmpty)
          const ProjectEmptyState(
            icon: Icons.groups_outlined,
            message: 'No employees are assigned to this project.',
          )
        else
          for (var i = 0; i < team.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _TeamCard(
                assignment: team[i],
                color: ProjectColors
                    .chartPalette[i % ProjectColors.chartPalette.length],
                onEdit: () => onEdit(team[i]),
                onDelete: () => onDelete(team[i]),
              ),
            ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  final ProjectEmployeeEntity assignment;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TeamCard({
    required this.assignment,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final employee = assignment.employee;
    final name = employee?.name ?? 'Employee #${assignment.employeeId}';
    final position = _nonEmpty(employee?.position);
    final email = _nonEmpty(employee?.email);
    final double estimatedCost = employee == null
        ? 0.0
        : assignment.totalPoints *
              employee.hoursPerPoint *
              employee.costPerHour;

    return ProjectSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  projectInitials(name),
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
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
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ProjectColors.title,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _MutedText(position ?? 'No position', maxLines: 1),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ProjectPill(label: '${assignment.totalPoints} pts', fontSize: 12),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ProjectColors.tint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (email != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.mail_outline,
                        size: 18,
                        color: ProjectColors.muted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ProjectColors.body,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: ProjectColors.muted,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Estimated cost',
                        style: TextStyle(
                          color: ProjectColors.body,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      projectMoney(estimatedCost),
                      style: const TextStyle(
                        color: ProjectColors.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ActionRow(
            editLabel: 'Edit',
            deleteLabel: 'Remove',
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _MeetingsTab extends StatelessWidget {
  final List<ProjectMeetingEntity> meetings;
  final VoidCallback onAdd;
  final ValueChanged<ProjectMeetingEntity> onEdit;
  final ValueChanged<ProjectMeetingEntity> onDelete;

  const _MeetingsTab({
    required this.meetings,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final upcoming = meetings.where((m) => m.isUpcoming).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabHeader(
          title: 'Meetings',
          titleSuffix: '($upcoming upcoming)',
          subtitle: 'Schedule and track project syncs.',
          actionLabel: 'Schedule Meeting',
          onAdd: onAdd,
        ),
        if (meetings.isEmpty)
          const ProjectEmptyState(
            icon: Icons.event_outlined,
            message: 'No meetings have been scheduled.',
          )
        else
          for (final meeting in meetings)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _MeetingCard(
                meeting: meeting,
                onEdit: () => onEdit(meeting),
                onDelete: () => onDelete(meeting),
              ),
            ),
      ],
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final ProjectMeetingEntity meeting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MeetingCard({
    required this.meeting,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final date = meeting.meetingDate?.toLocal();
    final description = _nonEmpty(meeting.description);
    final url = _nonEmpty(meeting.meetingUrl);

    return ProjectSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 64,
                decoration: BoxDecoration(
                  color: ProjectColors.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: date == null
                    ? const Center(
                        child: Text(
                          '—',
                          style: TextStyle(
                            color: ProjectColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            projectMonthShort(date),
                            style: const TextStyle(
                              color: ProjectColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                          Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: ProjectColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            meeting.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ProjectColors.title,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (date != null) ...[
                          const SizedBox(width: 8),
                          ProjectPill(
                            label: meeting.isUpcoming ? 'Upcoming' : 'Past',
                            background: meeting.isUpcoming
                                ? ProjectColors.cyanSoft
                                : ProjectColors.tint,
                            foreground: meeting.isUpcoming
                                ? ProjectColors.teal
                                : ProjectColors.muted,
                            fontSize: 11,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date == null
                          ? 'No date set'
                          : '${projectDateShort(date)} • ${projectTime(date)}',
                      style: const TextStyle(
                        color: ProjectColors.body,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: ProjectColors.body,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
          if (url != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.link, size: 18, color: ProjectColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ProjectColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          _ActionRow(
            editLabel: 'Edit',
            deleteLabel: 'Delete',
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _FeatureDialog extends StatefulWidget {
  final ProjectFeatureEntity? feature;
  const _FeatureDialog({this.feature});
  @override
  State<_FeatureDialog> createState() => _FeatureDialogState();
}

class _FeatureDialogState extends State<_FeatureDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.feature?.name ?? '',
  );
  late final TextEditingController _description = TextEditingController(
    text: widget.feature?.description ?? '',
  );
  late String _status = widget.feature?.status ?? 'new';

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FormDialogShell(
    title: widget.feature == null ? 'Add New Feature' : 'Edit Feature',
    icon: Icons.category_outlined,
    formKey: _formKey,
    onSave: () {
      if (!_formKey.currentState!.validate()) return;
      Navigator.pop(
        context,
        ProjectFeatureInput(
          name: _name.text.trim(),
          description: _description.text.trim(),
          status: _status,
        ),
      );
    },
    children: [
      ProjectField(
        controller: _name,
        label: 'Feature Name',
        requiredField: true,
      ),
      ProjectField(controller: _description, label: 'Description', maxLines: 3),
      DropdownButtonFormField<String>(
        value: _status,
        isExpanded: true,
        borderRadius: BorderRadius.circular(16),
        decoration: projectInputDecoration('Status'),
        items: kFeatureStatuses
            .map(
              (status) => DropdownMenuItem(
                value: status,
                child: Text(ProjectColors.statusLabel(status)),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _status = value ?? _status),
      ),
    ],
  );
}

class _CostDialog extends StatefulWidget {
  final ProjectCostEntity? cost;
  const _CostDialog({this.cost});
  @override
  State<_CostDialog> createState() => _CostDialogState();
}

class _CostDialogState extends State<_CostDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.cost?.name ?? '',
  );
  late final TextEditingController _description = TextEditingController(
    text: widget.cost?.description ?? '',
  );
  late final TextEditingController _quantity = TextEditingController(
    text: '${widget.cost?.quantity ?? 1}',
  );
  late final TextEditingController _amount = TextEditingController(
    text: '${widget.cost?.amount ?? 0}',
  );

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _quantity.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FormDialogShell(
    title: widget.cost == null ? 'Add Cost Item' : 'Edit Cost Item',
    icon: Icons.receipt_long_outlined,
    formKey: _formKey,
    onSave: () {
      if (!_formKey.currentState!.validate()) return;
      Navigator.pop(
        context,
        ProjectCostInput(
          name: _name.text.trim(),
          description: _description.text.trim(),
          quantity: int.parse(_quantity.text.trim()),
          amount: double.parse(_amount.text.trim()),
        ),
      );
    },
    children: [
      ProjectField(controller: _name, label: 'Cost Name', requiredField: true),
      ProjectField(controller: _description, label: 'Description'),
      ProjectField(
        controller: _quantity,
        label: 'Quantity',
        numeric: true,
        integer: true,
      ),
      ProjectField(controller: _amount, label: 'Amount', numeric: true),
    ],
  );
}

class _TeamInput {
  final String employeeId;
  final int points;
  const _TeamInput(this.employeeId, this.points);
}

class _TeamDialog extends StatefulWidget {
  final List<EmployeeEntity> employees;
  final ProjectEmployeeEntity? assignment;
  const _TeamDialog({required this.employees, this.assignment});
  @override
  State<_TeamDialog> createState() => _TeamDialogState();
}

class _TeamDialogState extends State<_TeamDialog> {
  final _formKey = GlobalKey<FormState>();
  late String? _employeeId =
      widget.assignment?.employeeId ??
      (widget.employees.isEmpty ? null : widget.employees.first.id);
  late final TextEditingController _points = TextEditingController(
    text: '${widget.assignment?.totalPoints ?? 0}',
  );

  @override
  void dispose() {
    _points.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FormDialogShell(
    title: widget.assignment == null
        ? 'Add Team Member'
        : 'Edit Member Details',
    icon: Icons.group_add_outlined,
    formKey: _formKey,
    onSave: () {
      if (!_formKey.currentState!.validate() || _employeeId == null) return;
      Navigator.pop(
        context,
        _TeamInput(_employeeId!, int.parse(_points.text.trim())),
      );
    },
    children: [
      DropdownButtonFormField<String>(
        value: _employeeId,
        isExpanded: true,
        borderRadius: BorderRadius.circular(16),
        decoration: projectInputDecoration('Select Employee'),
        items: widget.employees
            .map(
              (employee) => DropdownMenuItem(
                value: employee.id,
                child: Text(
                  '${employee.name} • ${employee.position}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: widget.assignment == null
            ? (value) => setState(() => _employeeId = value)
            : null,
        validator: (value) => value == null ? 'Select an employee' : null,
      ),
      const SizedBox(height: 12),
      ProjectField(
        controller: _points,
        label: 'Total Points',
        numeric: true,
        integer: true,
      ),
    ],
  );
}

class _MeetingDialog extends StatefulWidget {
  final ProjectMeetingEntity? meeting;
  const _MeetingDialog({this.meeting});
  @override
  State<_MeetingDialog> createState() => _MeetingDialogState();
}

class _MeetingDialogState extends State<_MeetingDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title = TextEditingController(
    text: widget.meeting?.title ?? '',
  );
  late final TextEditingController _description = TextEditingController(
    text: widget.meeting?.description ?? '',
  );
  late final TextEditingController _url = TextEditingController(
    text: widget.meeting?.meetingUrl ?? '',
  );
  late DateTime _date =
      widget.meeting?.meetingDate ??
      DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _url.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(
        () => _date = DateTime(
          selected.year,
          selected.month,
          selected.day,
          _date.hour,
          _date.minute,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => _FormDialogShell(
    title: widget.meeting == null ? 'Schedule Meeting' : 'Edit Meeting',
    icon: Icons.event_outlined,
    formKey: _formKey,
    onSave: () {
      if (!_formKey.currentState!.validate()) return;
      Navigator.pop(
        context,
        ProjectMeetingInput(
          title: _title.text.trim(),
          meetingDate: _date,
          meetingUrl: _url.text.trim(),
          description: _description.text.trim(),
        ),
      );
    },
    children: [
      ProjectField(
        controller: _title,
        label: 'Meeting Title',
        requiredField: true,
      ),
      ProjectField(controller: _description, label: 'Description', maxLines: 3),
      ProjectField(controller: _url, label: 'Meeting URL'),
      ProjectDateField(
        label: 'Date',
        value: projectDateShort(_date),
        onTap: _pickDate,
      ),
    ],
  );
}

class _FormDialogShell extends StatelessWidget {
  final String title;
  final IconData icon;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSave;
  final List<Widget> children;

  const _FormDialogShell({
    required this.title,
    required this.icon,
    required this.formKey,
    required this.onSave,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
    contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
    title: Row(
      children: [
        ProjectIconTile(icon: icon, size: 42, radius: 13),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ProjectColors.title,
              fontSize: 19,
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
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...children,
              const SizedBox(height: 8),
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
                      label: 'Save',
                      expand: true,
                      onPressed: onSave,
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

class _DetailsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _DetailsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 44, color: ProjectColors.muted),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: ProjectColors.body),
          ),
          const SizedBox(height: 16),
          ProjectButton(label: 'Try Again', onPressed: onRetry),
        ],
      ),
    ),
  );
}
