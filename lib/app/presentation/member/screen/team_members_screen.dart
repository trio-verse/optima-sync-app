import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/widgets/app_drawer.dart';
import 'package:optima_sync_v2/core/widgets/app_mobile_widgets.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/presentation/member/bloc/member_bloc.dart';
import 'package:optima_sync_v2/app/presentation/member/bloc/member_event.dart';
import 'package:optima_sync_v2/app/presentation/member/bloc/member_state.dart';
import 'package:optima_sync_v2/app/presentation/member/pages/edit_member_role_sheet.dart';
import 'package:optima_sync_v2/app/presentation/member/pages/member_list_item.dart';
import 'package:optima_sync_v2/app/presentation/member/pages/member_role_style.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _searchController = TextEditingController();

  String _selectedRole = 'member';
  String _query = '';

  @override
  void initState() {
    super.initState();

    context.read<MemberBloc>().add(LoadMembers());

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _submitAddMember() {
    if (!_formKey.currentState!.validate()) return;

    context.read<MemberBloc>().add(
      AddMemberSubmitted(
        email: _emailController.text.trim(),
        role: _selectedRole,
      ),
    );
  }

  void _openChangeRoleSheet(MemberEntity member) {
    final bloc = context.read<MemberBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: EditMemberRoleSheet(member: member),
        );
      },
    );
  }

  List<MemberEntity> _filter(List<MemberEntity> members) {
    if (_query.isEmpty) return members;

    return members.where((member) {
      final email = member.email?.toLowerCase() ?? '';
      final name = member.name?.toLowerCase() ?? '';
      final role = member.role.toLowerCase();

      return email.contains(_query) ||
          name.contains(_query) ||
          role.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      appBar: AppBar(title: const Text('Team Members')),
      drawer: const AppDrawer(selectedItem: 'Member'),
      body: BlocConsumer<MemberBloc, MemberState>(
        listenWhen: (previous, current) {
          final wasSubmittingNewMember =
              previous is MemberSubmitting && previous.updatingId == null;

          return (wasSubmittingNewMember && current is MemberSuccess) ||
              (wasSubmittingNewMember && current is MemberFailure);
        },
        listener: (context, state) {
          if (state is MemberSuccess) {
            _emailController.clear();
            setState(() {
              _selectedRole = 'member';
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('The member was added successfully')),
            );
          }

          if (state is MemberFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is MemberInitial || state is MemberLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MemberFailure && state.members == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MemberBloc>().add(LoadMembers());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final members = switch (state) {
            MemberSuccess(:final members) => members,
            MemberSubmitting(:final members) => members,
            MemberFailure(:final members) => members ?? const <MemberEntity>[],
            _ => const <MemberEntity>[],
          };

          final isAdding = state is MemberSubmitting && state.updatingId == null;
          final errorMessage = state is MemberFailure ? state.message : null;

          final filteredMembers = _filter(members);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MemberBloc>().add(LoadMembers());
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              children: [
                _HeaderCard(),
                const SizedBox(height: 12),

                _MemberSummary(total: members.length),
                const SizedBox(height: 12),

                _AddMemberCard(
                  formKey: _formKey,
                  emailController: _emailController,
                  selectedRole: _selectedRole,
                  isSubmitting: isAdding,
                  errorMessage: errorMessage,
                  onRoleChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  onSubmit: _submitAddMember,
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search members by email or role...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      if (MediaQuery.sizeOf(context).width >= 600 &&
                          MediaQuery.textScalerOf(context).scale(14) <= 20) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _TableHeaderLabel('NAME'),
                            ),
                            Expanded(
                              flex: 2,
                              child: _TableHeaderLabel('ROLE'),
                            ),
                            const SizedBox(width: 44),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      ],
                      if (members.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'No members found.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else if (filteredMembers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'No members match your search.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredMembers.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];

                            final isUpdatingThisMember =
                                state is MemberSubmitting &&
                                state.updatingId == member.id;

                            return MemberListItem(
                              member: member,
                              isLoading: isUpdatingThisMember,
                              onChangeRole: () =>
                                  _openChangeRoleSheet(member),
                            );
                          },
                        ),
                    ],
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

class _TableHeaderLabel extends StatelessWidget {
  final String text;

  const _TableHeaderLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppPallete.textSecondary,
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppPallete.primary, AppPallete.primary],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(child: Text(
                      'Team Members',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    SizedBox(width: 6),
                    Icon(
                      Icons.auto_awesome,
                      color: AppPallete.primary,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage team members, roles, and access permissions.',
                  style: TextStyle(color: AppPallete.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberSummary extends StatelessWidget {
  final int total;
  const _MemberSummary({required this.total});

  @override
  Widget build(BuildContext context) => AppSurface(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        const Icon(Icons.groups_outlined, color: AppPallete.primary),
        const SizedBox(width: 10),
        const Expanded(child: Text('Total Members', style: TextStyle(fontWeight: FontWeight.w700))),
        Text('$total', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
      ]),
      const Divider(height: 24),
      const Wrap(spacing: 14, runSpacing: 8, children: [
        Text('Active & Verified', style: TextStyle(fontSize: 12, color: AppPallete.success)),
        Text('Role-Based Access', style: TextStyle(fontSize: 12, color: AppPallete.primary)),
      ]),
    ],
  ));
}

class _AddMemberCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String selectedRole;
  final bool isSubmitting;
  final String? errorMessage;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onSubmit;

  const _AddMemberCard({
    required this.formKey,
    required this.emailController,
    required this.selectedRole,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onRoleChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppPallete.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppPallete.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add New Member',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Enter member email and select their role.',
                        style: TextStyle(
                          color: AppPallete.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _TableHeaderLabel('EMAIL ADDRESS'),
            const SizedBox(height: 6),
            TextFormField(
              controller: emailController,
              enabled: !isSubmitting,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final email = value?.trim() ?? '';

                if (email.isEmpty) {
                  return 'Email address cannot be empty';
                }

                final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                if (!emailPattern.hasMatch(email)) {
                  return 'Enter a valid email address';
                }

                return null;
              },
              decoration: InputDecoration(
                hintText: 'example@company.com',
                errorText: errorMessage,
                filled: true,
                fillColor: AppPallete.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPallete.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPallete.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppPallete.primary),
                ),
              ),
            ),

            const SizedBox(height: 16),

            _TableHeaderLabel('ROLE'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: isSubmitting ? null : onRoleChanged,
              items: kMemberRoles
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(MemberRoleStyle.label(role)),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppPallete.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPallete.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPallete.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppPallete.primary),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save member',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
