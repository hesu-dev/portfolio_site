import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/auth_repository.dart';
import '../domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier(ref.watch(authRepositoryProvider));
    });

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repository;
  StreamSubscription<UserModel?>? _authStateSubscription;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _authStateSubscription = _repository.authStateChanges.listen(
      (user) {
        state = AsyncValue.data(user);
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // checkAuthStatus는 이제 _init에서 스트림으로 자동 처리되므로 수동 호출이 덜 필요하지만,
  // 명시적 리프레시 용도로 남겨두거나 삭제 가능. 여기서는 호환성을 위해 유지하되 구현을 getCurrentUser로 변경.
  Future<void> checkAuthStatus() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repository.login(email: email, password: password);
      // 스트림이 자동으로 상태를 업데이트할 것이므로 여기서 state 조작 불필요 (하지만 즉각적 반응을 위해 데이터 반환값을 넣기도 함)
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loginSocial(String provider) async {
    state = const AsyncValue.loading();
    try {
      await _repository.loginSocial(provider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signUp(String email, String password, String nickname) async {
    state = const AsyncValue.loading();
    try {
      await _repository.signUp(
        email: email,
        password: password,
        nickname: nickname,
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logout();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
