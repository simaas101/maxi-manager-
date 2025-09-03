import 'package:router_os_client/router_os_client.dart';
import '../models/user.dart';

class RouterService {
  final RouterOSClient client;
  RouterService(this.client);

  Future<List<HotspotUser>> fetchUsers() async {
    final res = await client.talk('/ip/hotspot/user/print', {
      '.proplist': '.id,name,password,profile,uptime,comment,disabled',
    });
    return res.map((e) => HotspotUser.fromMap(Map<String, String>.from(e))).toList();
  }

  Future<List<Map<String, String>>> fetchActive() async {
    final res = await client.talk('/ip/hotspot/active/print', {
      '.proplist': '.id,user,address,mac-address,uptime,login-by',
    });
    return res.map((e) => Map<String, String>.from(e)).toList();
  }

  Future<void> addUser({
    required String name,
    required String password,
    String? profile,
    String? comment,
  }) async {
    final params = {
      'name': name,
      'password': password,
      if (profile != null && profile.isNotEmpty) 'profile': profile,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    };
    await client.talk('/ip/hotspot/user/add', params);
  }

  Future<void> setUserDisabled(String id, bool disabled) async {
    await client.talk('/ip/hotspot/user/set', {
      '.id': id,
      'disabled': disabled ? 'true' : 'false',
    });
  }

  Future<void> setUserComment(String id, String comment) async {
    await client.talk('/ip/hotspot/user/set', {
      '.id': id,
      'comment': comment,
    });
  }

  Future<void> setUserPassword(String id, String password) async {
    await client.talk('/ip/hotspot/user/set', {
      '.id': id,
      'password': password,
    });
  }

  Future<void> setUserProfile(String id, String profile) async {
    await client.talk('/ip/hotspot/user/set', {
      '.id': id,
      'profile': profile,
    });
  }

  Future<void> removeUser(String id) async {
    await client.talk('/ip/hotspot/user/remove', {
      '.id': id,
    });
  }
}
