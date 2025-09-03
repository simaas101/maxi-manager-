import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addr = TextEditingController(text: '192.168.88.1');
  final _user = TextEditingController(text: 'admin');
  final _pass = TextEditingController();
  bool _ssl = false;
  bool _remember = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().loadSaved().then((_) {
        final sp = context.read<SessionProvider>();
        if (sp.address != null) _addr.text = sp.address!;
        if (sp.user != null) _user.text = sp.user!;
        _ssl = sp.useSsl;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Connect to RouterOS')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _addr,
                    decoration: const InputDecoration(labelText: 'Address (IP or hostname)'),
                    validator: (v) => (v==null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _user,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (v) => (v==null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _pass,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => (v==null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Use SSL (port 8729)'),
                    value: _ssl,
                    onChanged: (v) => setState(() => _ssl = v),
                  ),
                  CheckboxListTile(
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v ?? true),
                    title: const Text('Remember credentials on this device'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _busy ? null : () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() => _busy = true);
                      try {
                        final ok = await session.connect(_addr.text.trim(), _user.text.trim(), _pass.text, _ssl, remember: _remember);
                        if (ok && context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/users');
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to connect')));
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      } finally {
                        if (mounted) setState(() => _busy = false);
                      }
                    },
                    icon: _busy ? const SizedBox(height: 16, width:16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login),
                    label: const Text('Connect'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
