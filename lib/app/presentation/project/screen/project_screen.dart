import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/presentation/project/bloc/project_bloc.dart';
import 'package:optima_sync_v2/app/presentation/project/bloc/project_event.dart';
import 'package:optima_sync_v2/app/presentation/project/bloc/project_state.dart';
import 'package:optima_sync_v2/app/presentation/project/screen/project_details_screen.dart';
import 'package:optima_sync_v2/app/presentation/project/theme/project_colors.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_form_dialog.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_widgets.dart';
import 'package:optima_sync_v2/core/widgets/app_drawer.dart';

const List<String> _kFilterStatuses = [
  'new',
  'under_review',
  'in_progress',
  'completed',
];

enum _ProjectSort {
  latest('Latest'),
  oldest('Oldest'),
  name('Name');

  final String label;
  const _ProjectSort(this.label);
}

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final _search = TextEditingController();
  String? _status;
  _ProjectSort _sort = _ProjectSort.latest;

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(const LoadProjects());
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  int _newestFirst(ProjectEntity a, ProjectEntity b) {
    final x = a.createdAt;
    final y = b.createdAt;
    if (x == null && y == null) return 0;
    if (x == null) return 1;
    if (y == null) return -1;
    return y.compareTo(x);
  }

  List<ProjectEntity> _filtered(List<ProjectEntity> projects) {
    final query = _search.text.trim().toLowerCase();
    final result = projects.where((project) {
      final matchesStatus = _status == null || project.status == _status;
      final matchesSearch =
          query.isEmpty ||
          project.title.toLowerCase().contains(query) ||
          (project.clientName ?? '').toLowerCase().contains(query) ||
          project.referenceNumber.toLowerCase().contains(query);
      return matchesStatus && matchesSearch;
    }).toList();

    switch (_sort) {
      case _ProjectSort.latest:
        result.sort(_newestFirst);
        break;
      case _ProjectSort.oldest:
        result.sort((a, b) => _newestFirst(b, a));
        break;
      case _ProjectSort.name:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
    }
    return result;
  }

  Future<void> _openCreate(List<ProjectClientOption> clients) async {
    final result = await showDialog<Object>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectFormDialog(clients: clients),
    );
    if (!mounted || result is! ProjectInput) return;
    context.read<ProjectBloc>().add(CreateProjectSubmitted(result));
  }

  Future<void> _openEdit(
    ProjectEntity project,
    List<ProjectClientOption> clients,
  ) async {
    final result = await showDialog<Object>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectFormDialog(
        clients: clients,
        project: project,
        versionId: project.currentVersionId,
      ),
    );
    if (!mounted || result is! ProjectUpdateInput) return;
    context.read<ProjectBloc>().add(UpdateProjectSubmitted(project.id, result));
  }

  Future<void> _openDetails(ProjectEntity project) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectDetailsScreen(
          projectId: project.id,
          initialProject: project,
        ),
      ),
    );
    if (mounted) context.read<ProjectBloc>().add(const LoadProjects());
  }

  Future<void> _confirmDelete(ProjectEntity project) async {
    final confirmed = await showProjectConfirmDialog(
      context,
      title: 'Delete project?',
      message: 'Delete ${project.title}? This action cannot be undone.',
    );
    if (confirmed && mounted) {
      context.read<ProjectBloc>().add(DeleteProjectSubmitted(project.id));
    }
  }

  void _openFilterSheet(List<ProjectEntity> projects) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.8,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Filter by status',
                  style: TextStyle(
                    color: ProjectColors.title,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _FilterOption(
                label: 'All Projects',
                count: projects.length,
                selected: _status == null,
                onTap: () {
                  setState(() => _status = null);
                  Navigator.pop(sheetContext);
                },
              ),
              for (final status in _kFilterStatuses)
                _FilterOption(
                  label: ProjectColors.statusLabel(status),
                  count: projects.where((p) => p.status == status).length,
                  selected: _status == status,
                  onTap: () {
                    setState(() => _status = status);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.background,
      drawer: const AppDrawer(selectedItem: 'Projects'),
      appBar: AppBar(
        backgroundColor: ProjectColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: ProjectColors.title),
        title: const Text(
          'Projects',
          style: TextStyle(
            color: ProjectColors.title,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocConsumer<ProjectBloc, ProjectState>(
        listener: (context, state) {
          if (state is ProjectLoaded && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          if (state is ProjectInitial || state is ProjectLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ProjectColors.primary),
            );
          }
          if (state is ProjectFailure) {
            return _ProjectError(
              message: state.message,
              onRetry: () =>
                  context.read<ProjectBloc>().add(const LoadProjects()),
            );
          }

          final loaded = state as ProjectLoaded;
          final projects = _filtered(loaded.projects);
          return RefreshIndicator(
            color: ProjectColors.primary,
            onRefresh: () async {
              context.read<ProjectBloc>().add(const LoadProjects());
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _ProjectStats(projects: loaded.projects),
                const SizedBox(height: 16),
                ProjectButton(
                  label: 'Create Project',
                  icon: Icons.add_circle_outline,
                  height: 58,
                  expand: true,
                  onPressed: () => _openCreate(loaded.clients),
                ),
                const SizedBox(height: 16),
                _SearchRow(
                  controller: _search,
                  filterActive: _status != null,
                  onFilter: () => _openFilterSheet(loaded.projects),
                ),
                if (loaded.isWorking)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      color: ProjectColors.primary,
                      backgroundColor: ProjectColors.primarySoft,
                    ),
                  ),
                const SizedBox(height: 22),
                _PipelineHeader(
                  count: projects.length,
                  sort: _sort,
                  onSort: (value) => setState(() => _sort = value),
                ),
                const SizedBox(height: 14),
                if (projects.isEmpty)
                  _ProjectEmpty(hasProjects: loaded.projects.isNotEmpty)
                else ...[
                  for (final project in projects)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ProjectCard(
                        project: project,
                        onOpen: () => _openDetails(project),
                        onEdit: () => _openEdit(project, loaded.clients),
                        onDelete: () => _confirmDelete(project),
                      ),
                    ),
                  const _CaughtUpCard(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProjectStats extends StatelessWidget {
  final List<ProjectEntity> projects;
  const _ProjectStats({required this.projects});

  @override
  Widget build(BuildContext context) {
    final total = projects.length;
    final inProgress = projects.where((p) => p.status == 'in_progress').length;
    final pending = projects
        .where((p) => p.status == 'new' || p.status == 'under_review')
        .length;
    final completed = projects.where((p) => p.status == 'completed').length;

    double share(int value) => total == 0 ? 0 : value / total;
    String percent(int value) => '${(share(value) * 100).round()}%';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.folder_outlined,
                iconColor: ProjectColors.primary,
                iconBackground: ProjectColors.primarySoft,
                tag: 'All',
                value: total,
                label: 'Total Projects',
                progress: total == 0 ? 0 : 1,
                barColor: ProjectColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.timelapse_rounded,
                iconColor: ProjectColors.primary,
                iconBackground: ProjectColors.primarySoft,
                tag: 'WIP',
                value: inProgress,
                caption: percent(inProgress),
                label: 'In Progress',
                progress: share(inProgress),
                barColor: ProjectColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.visibility_outlined,
                iconColor: ProjectColors.teal,
                iconBackground: ProjectColors.cyanSoft,
                tag: 'Review',
                showDot: pending > 0,
                value: pending,
                caption: percent(pending),
                label: 'Pending Review',
                progress: share(pending),
                barColor: ProjectColors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.verified_outlined,
                iconColor: ProjectColors.muted,
                iconBackground: ProjectColors.tint,
                tag: 'Done',
                value: completed,
                caption: percent(completed),
                label: 'Completed',
                progress: share(completed),
                barColor: ProjectColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String tag;
  final bool showDot;
  final int value;
  final String? caption;
  final String label;
  final double progress;
  final Color barColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.tag,
    required this.value,
    required this.label,
    required this.progress,
    required this.barColor,
    this.caption,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProjectIconTile(
                icon: icon,
                color: iconColor,
                background: iconBackground,
                size: 42,
                radius: 13,
              ),
              const Spacer(),
              if (showDot)
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: ProjectColors.teal,
                    shape: BoxShape.circle,
                  ),
                )
              else
                ProjectPill(
                  label: tag,
                  background: ProjectColors.tint,
                  foreground: ProjectColors.muted,
                  fontSize: 11,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  color: ProjectColors.title,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              if (caption != null) ...[
                const SizedBox(width: 6),
                Text(
                  caption!,
                  style: const TextStyle(
                    color: ProjectColors.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ProjectColors.body,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          ProjectProgressBar(value: progress, color: barColor, height: 4),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  final TextEditingController controller;
  final bool filterActive;
  final VoidCallback onFilter;

  const _SearchRow({
    required this.controller,
    required this.filterActive,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: ProjectColors.shadow,
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: ProjectColors.title,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Search by project, client or ref...',
                hintStyle: const TextStyle(
                  color: ProjectColors.muted,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: ProjectColors.muted,
                ),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: controller.clear,
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: ProjectColors.muted,
                        ),
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          clipBehavior: Clip.none,
          children: [
            ProjectSquareButton(
              icon: Icons.tune,
              size: 54,
              background: Colors.white,
              foreground: ProjectColors.title,
              tooltip: 'Filter by status',
              onPressed: onFilter,
            ),
            if (filterActive)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: ProjectColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? ProjectColors.primarySoft : ProjectColors.tint,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? ProjectColors.primary
                          : ProjectColors.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: ProjectColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: ProjectColors.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PipelineHeader extends StatelessWidget {
  final int count;
  final _ProjectSort sort;
  final ValueChanged<_ProjectSort> onSort;

  const _PipelineHeader({
    required this.count,
    required this.sort,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Flexible(
                child: Text(
                  'Active Pipeline',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ProjectColors.title,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ProjectPill(label: '$count Available', fontSize: 11),
            ],
          ),
        ),
        PopupMenuButton<_ProjectSort>(
          initialValue: sort,
          onSelected: onSort,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder: (_) => _ProjectSort.values
              .map(
                (value) => PopupMenuItem(
                  value: value,
                  child: Text(
                    value.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )
              .toList(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sort: ',
                  style: TextStyle(color: ProjectColors.muted, fontSize: 13),
                ),
                Text(
                  sort.label,
                  style: const TextStyle(
                    color: ProjectColors.body,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: ProjectColors.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectEntity project;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final reference = project.referenceNumber.isEmpty
        ? 'Project #${project.id}'
        : project.referenceNumber;
    final description = project.description?.trim() ?? '';
    final subtitle = description.isNotEmpty ? description : reference;
    final endDate = project.endDate;
    final createdAt = project.createdAt;
    final industry = project.industryName?.trim() ?? '';

    return ProjectSurface(
      onTap: onOpen,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProjectIconTile(
                icon: Icons.apartment_outlined,
                size: 48,
                radius: 15,
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
                            project.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ProjectColors.title,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ProjectStatusBadge(status: project.status),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ProjectColors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert, color: ProjectColors.body),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'open':
                        onOpen();
                        break;
                      case 'edit':
                        onEdit();
                        break;
                      default:
                        onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'open', child: Text('Open dashboard')),
                    PopupMenuItem(value: 'edit', child: Text('Edit project')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ProjectColors.tint,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _InfoCell(
                        icon: Icons.business_center_outlined,
                        label: 'Client',
                        value: project.clientName ?? '—',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCell(
                        icon: Icons.payments_outlined,
                        label: 'Budget',
                        value: projectMoney(project.totalAmount),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _InfoCell(
                        icon: Icons.event_busy_outlined,
                        label: 'Deadline',
                        value: endDate == null
                            ? 'No deadline'
                            : projectDateIso(endDate),
                        muted: endDate == null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCell(
                        icon: Icons.calendar_today_outlined,
                        label: 'Created',
                        value: createdAt == null
                            ? '—'
                            : projectDateIso(createdAt),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.tag, size: 16, color: ProjectColors.muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  reference,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ProjectColors.body,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (industry.isNotEmpty) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    industry,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ProjectColors.teal,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          ProjectButton(
            label: 'Open Project Dashboard',
            trailingIcon: Icons.arrow_forward,
            kind: ProjectButtonKind.tonal,
            expand: true,
            onPressed: onOpen,
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool muted;

  const _InfoCell({
    required this.icon,
    required this.label,
    required this.value,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: ProjectColors.muted),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ProjectColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: muted ? ProjectColors.muted : ProjectColors.title,
            fontSize: 15,
            fontWeight: muted ? FontWeight.w400 : FontWeight.w700,
            fontStyle: muted ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}

class _CaughtUpCard extends StatelessWidget {
  const _CaughtUpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: ProjectColors.tint,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          ProjectIconTile(
            icon: Icons.rocket_launch_outlined,
            size: 60,
            radius: 30,
          ),
          SizedBox(height: 14),
          Text(
            "You're all caught up!",
            style: TextStyle(
              color: ProjectColors.title,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Need to start another project? Tap Create Project above.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ProjectColors.body,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectEmpty extends StatelessWidget {
  final bool hasProjects;
  const _ProjectEmpty({required this.hasProjects});

  @override
  Widget build(BuildContext context) => ProjectEmptyState(
    icon: Icons.folder_off_outlined,
    message: hasProjects
        ? 'No projects match this view.'
        : 'No projects yet. Tap Create Project to get started.',
  );
}

class _ProjectError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ProjectError({required this.message, required this.onRetry});

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
