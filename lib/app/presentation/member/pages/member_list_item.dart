import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/presentation/member/pages/member_role_style.dart';

class MemberListItem extends StatelessWidget {
  final MemberEntity member;
  final VoidCallback? onChangeRole;
  final bool isLoading;

  const MemberListItem({
    super.key,
    required this.member,
    this.onChangeRole,
    this.isLoading = false,
  });

  String get _initials {
    final source = member.displayName.trim();
    if (source.isEmpty) return '?';
    return source.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEEF2FF),
            child: Text(
              _initials,
              style: const TextStyle(
                color: Color(0xFF4F46E5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                if (member.email != null && member.name != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      member.email!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: MemberRoleStyle.background(member.role),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              MemberRoleStyle.label(member.role),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MemberRoleStyle.foreground(member.role),
              ),
            ),
          ),

          const SizedBox(width: 4),

          isLoading
              ? const SizedBox(
                  width: 36,
                  height: 36,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Change role',
                  onPressed: onChangeRole,
                ),
        ],
      ),
    );
  }
}
