import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:router_os_client/router_os_client.dart';

class SessionProvider extends ChangeNotifier {
  RouterOSClient? _client;
  bool _connected = false;
  String? _address;
  String? _user;
  String? _password;
  bool _useSsl = false;

  RouterOSClient? get client => _client;
  bool get isConnected => _connected;
  String? get address => _address;
  String? get user => _user;
  bool get useSsl => _useSsl;

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    _address = prefs.getString('addr');
    _user = prefs.getString('user');
    _password = prefs.getString('pass');
    _useSsl = prefs.getBool('ssl') ?? false;
    notifyListeners();
  }

  Future<bool> connect(String address, String user, String password, bool useSsl, {bool remember = true}) async {
    _client?.close();
    _client = RouterOSClient(
      address: address,
      user: user,
      password: password,
      useSsl: useSsl,
      verbose: false,
    );
    try {
      final ok = await _client!.login();
      _connected = ok;
      if (ok) {
        _address = address;
        _user = user;
        _password = password;
        _useSsl = useSsl;
        if (remember) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('addr', address);
          await prefs.setString('user', user);
          await prefs.setString('pass', password);
          await prefs.setBool('ssl', useSsl);
        }
      }
      notifyListeners();
      return ok;
    } catch (e) {
      _connected = false;
      notifyListeners();
      rethrow;
    }
  }

  void disconnect() {
    _client?.close();
    _connected = false;
    notifyListeners();
  }
}
