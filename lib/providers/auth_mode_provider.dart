import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthMode { signIn, signUp, forgotPassword }

final authModeProvider = NotifierProvider<AuthModeNotifier, AuthMode>(
  AuthModeNotifier.new,
);

class AuthModeNotifier extends Notifier<AuthMode> {
  @override
  AuthMode build() {
    return AuthMode.signIn;
  }

  void setMode(AuthMode mode) {
    state = mode;
  }
}
