import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/presentation/member/bloc/member_bloc.dart';
import 'package:optima_sync_v2/app/presentation/member/bloc/member_event.dart';
import 'package:optima_sync_v2/app/presentation/member/bloc/member_state.dart';
import 'package:optima_sync_v2/app/presentation/member/pages/member_role_style.dart';

class EditMemberRoleSheet extends StatefulWidget {
  final MemberEntity member;

  const EditMemberRoleSheet({super.key, required this.member});

  @override
  State<EditMemberRoleSheet> createState() => _EditMemberRoleSheetState();
}

class _EditMemberRoleSheetState extends State<EditMemberRoleSheet> {
  late String _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.member.role;
  }

  void _submit() {
    context.read<MemberBloc>().add(
      UpdateMemberRoleSubmitted(
        memberId: widget.member.id,
        role: _selectedRole,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MemberBloc, MemberState>(
      listener: (context, state) {
        if (state is MemberSuccess) {
          Navigator.of(context).pop();
        }

        if (state is MemberFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Change Role',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.member.displayName,
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: kMemberRoles
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(MemberRoleStyle.label(role)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedRole = value;
                });
              },
            ),

            const SizedBox(height: 16),

            BlocBuilder<MemberBloc, MemberState>(
              builder: (context, state) {
                final isSubmitting =
                    state is MemberSubmitting &&
                    state.updatingId == widget.member.id;

                return SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isSubmitting ? null : _submit,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save changes'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
