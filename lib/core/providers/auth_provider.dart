import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final String? username;

  const AuthState({
    this.isAuthenticated = false,
    this.username,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  bool login(String username, String password) {
    if (username == 'admin' && password == '123') {
      state = AuthState(isAuthenticated: true, username: username);
      return true;
    }
    return false;
  }

  void logout() {
    state = const AuthState();
  }
}
