import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _sessionKey = 'logged_in_user';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<Map<String, String>> _loadUsers() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw) as Map);
  }

  Future<void> _saveUsers(Map<String, String> users) async {
    final prefs = await _prefs;
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<String?> register({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    final users = await _loadUsers();
    if (users.containsKey(username)) {
      return 'Username already exists';
    }
    users[username] = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });
    await _saveUsers(users);
    return null;
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    final users = await _loadUsers();
    final raw = users[username];
    if (raw == null) return 'User not found';
    final data = jsonDecode(raw) as Map<String, dynamic>;
    if (data['password'] != password) return 'Incorrect password';
    final prefs = await _prefs;
    await prefs.setString(_sessionKey, username);
    return null;
  }

  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
  }

  Future<String?> currentUser() async {
    final prefs = await _prefs;
    return prefs.getString(_sessionKey);
  }

  Future<Map<String, String>?> profileOf(String username) async {
    final users = await _loadUsers();
    final raw = users[username];
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return {
      'name': data['name'] as String,
      'email': data['email'] as String,
    };
  }
}
