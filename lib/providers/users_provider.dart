import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/router_service.dart';

class UsersProvider extends ChangeNotifier {
  final RouterService service;
  UsersProvider(this.service);

  List<HotspotUser> _users = [];
  bool _loading = false;
  String? _error;

  List<HotspotUser> get users => _users;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> refresh() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await service.fetchUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDisabled(HotspotUser u) async {
    await service.setUserDisabled(u.id, !u.disabled);
    await refresh();
  }

  Future<void> remove(String id) async {
    await service.removeUser(id);
    await refresh();
  }

  Future<void> updateComment(String id, String comment) async {
    await service.setUserComment(id, comment);
    await refresh();
  }

  Future<void> add(String name, String password, String? profile, String? comment) async {
    await service.addUser(name: name, password: password, profile: profile, comment: comment);
    await refresh();
  }
}
