import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/users_provider.dart';

class UserCard extends StatelessWidget {
  final HotspotUser user;
  final UsersProvider vm;
  const UserCard({super.key, required this.user, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(user.disabled ? Icons.person_off : Icons.person),
                const SizedBox(width: 8),
                Expanded(child: Text(user.name, style: Theme.of(context).textTheme.titleMedium)),
                IconButton(
                  tooltip: user.disabled ? 'Enable' : 'Disable',
                  onPressed: () => vm.toggleDisabled(user),
                  icon: Icon(user.disabled ? Icons.toggle_off : Icons.toggle_on),
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                if (user.profile != null && user.profile!.isNotEmpty) _kv('Profile', user.profile!),
                if (user.uptime != null && user.uptime!.isNotEmpty) _kv('Uptime', user.uptime!),
                _kv('Disabled', user.disabled ? 'yes' : 'no'),
              ],
            ),
            if (user.comment != null && user.comment!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Comment: ${user.comment!}'),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _editComment(context),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Edit comment'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () => _changePassword(context),
                  icon: const Icon(Icons.key),
                  label: const Text('Change password'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Chip(label: Text('$k: $v'));

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove user'),
        content: Text('Remove ${user.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
        ],
      ),
    );
    if (ok == true) {
      await vm.remove(user.id);
    }
  }

  Future<void> _editComment(BuildContext context) async {
    final ctrl = TextEditingController(text: user.comment ?? '');
    final newVal = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit comment'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Comment')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Save')),
        ],
      ),
    );
    if (newVal != null) {
      await vm.updateComment(user.id, newVal);
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change password'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'New password'), obscureText: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Change')),
        ],
      ),
    );
    if (ok == true) {
      await vm.service.setUserPassword(user.id, ctrl.text);
      await vm.refresh();
    }
  }
}
