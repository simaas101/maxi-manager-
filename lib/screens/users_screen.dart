import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../services/router_service.dart';
import '../providers/users_provider.dart';
import '../widgets/user_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late UsersProvider usersProvider;

  @override
  void initState() {
    super.initState();
    final session = context.read<SessionProvider>();
    final service = RouterService(session.client!);
    usersProvider = UsersProvider(service);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usersProvider.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: usersProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hotspot Users'),
          actions: [
            IconButton(
              onPressed: () => usersProvider.refresh(),
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddUserDialog(context),
          icon: const Icon(Icons.person_add),
          label: const Text('Add'),
        ),
        body: Consumer<UsersProvider>(
          builder: (context, vm, _) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text('Error: ${vm.error}'));
            }
            if (vm.users.isEmpty) {
              return const Center(child: Text('No users'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.users.length,
              itemBuilder: (_, i) => UserCard(user: vm.users[i], vm: vm),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    final name = TextEditingController();
    final pass = TextEditingController();
    final profile = TextEditingController();
    final comment = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add hotspot user'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Username')),
              TextField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              TextField(controller: profile, decoration: const InputDecoration(labelText: 'Profile (optional)')),
              TextField(controller: comment, decoration: const InputDecoration(labelText: 'Comment (optional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () async {
            await usersProvider.add(name.text.trim(), pass.text, profile.text.trim().isEmpty? null: profile.text.trim(), comment.text.trim().isEmpty? null: comment.text.trim());
            if (context.mounted) Navigator.pop(context);
          }, child: const Text('Add')),
        ],
      ),
    );
  }
}
