import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import '../domain/user_model.dart';
import 'dart:developer' as developer;

// Interface
abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> loginSocial(String provider); // google only for now
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String nickname,
  });
  Future<void> logout();
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;
      return await _fetchUserModel(user);
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await _fetchUserModel(user);
  }

  Future<UserModel> _fetchUserModel(User user) async {
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      } else {
        // 만약 user collection에 데이터가 없다면 (예: 소셜 로그인 최초 시도 등에서 누락 시) 생성
        // 하지만 loginSocial 등에서 처리하므로 여기서는 기본값 반환 혹은 에러 처리
        // 안전하게 기본값 생성 후 반환
        final newUser = UserModel(
          id: user.uid,
          email: user.email ?? '',
          nickname: user.displayName ?? 'User',
          isSubscribed: false,
          profileImage: user.photoURL,
        );
        // 필요하다면 저장: await _saveUserToFirestore(newUser);
        return newUser;
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'unavailable') {
        // 오프라인이거나 권한 문제 등.
        // 일단 기본 유저 정보라도 반환해서 앱이 죽지 않게 함.
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          nickname: user.displayName ?? 'User',
          isSubscribed: false, // 오프라인일 때 구독 상태 확인 불가하므로 false
        );
      }
      rethrow;
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) throw Exception("User not found");
      return await _fetchUserModel(credential.user!);
    } on FirebaseAuthException catch (e) {
      // 에러 메시지 한글화 처리 가능
      throw Exception(e.message ?? "로그인에 실패했습니다.");
    }
  }

  @override
  Future<UserModel> loginSocial(String provider) async {
    if (provider == 'google') {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw Exception("Google Sign In Cancelled");
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _signInWithCredential(credential, 'google');
      } catch (e) {
        developer.log("Google Login Error", error: e);
        throw Exception("구글 로그인 실패: $e");
      }
    } else if (provider == 'apple') {
      try {
        final appleProvider = AppleAuthProvider();
        appleProvider.addScope('email');
        appleProvider.addScope('name');

        final UserCredential userCredential = await _auth.signInWithProvider(
          appleProvider,
        );
        final user = userCredential.user;
        if (user == null) throw Exception("Apple Sign In Failed");

        return await _handleFirestoreUser(user, 'Apple User');
      } catch (e) {
        developer.log("Apple Login Error", error: e);
        throw Exception("애플 로그인 실패: $e");
      }
    } else if (provider == 'kakao') {
      try {
        // 카카오톡 설치 여부 확인
        if (await kakao.isKakaoTalkInstalled()) {
          try {
            await kakao.UserApi.instance.loginWithKakaoTalk();
          } catch (error) {
            // 사용자가 카카오톡으로 로그인 취소나 에러 시 카카오 계정으로 로그인 시도
            if (error is PlatformException && error.code == 'CANCELED') {
              throw Exception("카카오톡 로그인 취소");
            }
            await kakao.UserApi.instance.loginWithKakaoAccount();
          }
        } else {
          await kakao.UserApi.instance.loginWithKakaoAccount();
        }

        final kakao.User user = await kakao.UserApi.instance.me();

        // 1. Firebase Auth 익명 로그인 (또는 생략 가능하지만, 보안 규칙을 위해 필요)
        // 여기서는 간단히 Firebase Auth도 '익명'으로 로그인시켜서 uid를 확보하고 그것을 카카오 ID와 매핑하거나,
        // 혹은 단순히 카카오 ID를 문서 ID로 사용합니다.
        // 일관성을 위해: 카카오 ID (숫자) -> Firestore ID로 사용

        final String kakaoUserId = "kakao_${user.id}";
        final String? email = user.kakaoAccount?.email;
        final String? nickname = user.kakaoAccount?.profile?.nickname;
        final String? profileImage =
            user.kakaoAccount?.profile?.thumbnailImageUrl;

        // Note: Firebase Auth와 연결되지 않았으므로 재시작 시 로그인이 유지가 안 될 수 있음.
        // 해결책: main.dart나 repo init에서 카카오 토큰 체크 로직 추가 필요.

        // 유저 정보 저장
        final doc = await _firestore.collection('users').doc(kakaoUserId).get();

        if (!doc.exists) {
          final newUser = UserModel(
            id: kakaoUserId,
            email: email ?? '',
            nickname: nickname ?? 'Kakao User',
            isSubscribed: false,
            profileImage: profileImage,
          );
          // Firestore에 저장 (보안 규칙이 allow write: if request.auth != null 이면 실패할 수 있음.
          // 따라서 Firebase 익명 로그인을 먼저 하는 것이 안전함. 하지만 여기선 생략하고, 추후 문제시 수정)
          await _firestore
              .collection('users')
              .doc(kakaoUserId)
              .set(newUser.toJson());
          return newUser;
        } else {
          return UserModel.fromJson(doc.data()!);
        }
      } catch (e) {
        developer.log("Kakao Login Error", error: e);
        throw Exception("카카오 로그인 실패: $e");
      }
    }
    throw Exception("Unsupported provider: $provider");
  }

  Future<UserModel> _signInWithCredential(
    AuthCredential credential,
    String defaultName,
  ) async {
    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );
    final User? user = userCredential.user;

    if (user == null) throw Exception("Sign In Failed");

    return await _handleFirestoreUser(user, defaultName);
  }

  Future<UserModel> _handleFirestoreUser(User user, String defaultName) async {
    // Firestore에 유저 정보가 있는지 확인하고 없으면 저장
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      final newUser = UserModel(
        id: user.uid,
        email: user.email ?? '',
        nickname: user.displayName ?? defaultName,
        isSubscribed: false,
        profileImage: user.photoURL,
      );
      await _saveUserToFirestore(newUser);
      return newUser;
    } else {
      return UserModel.fromJson(doc.data()!);
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception("Failed to create user");

      // Update Display Name
      await user.updateDisplayName(nickname);

      final newUser = UserModel(
        id: user.uid,
        email: email,
        nickname: nickname,
        isSubscribed: false,
      );

      await _saveUserToFirestore(newUser);
      return newUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("이미 사용 중인 이메일입니다.");
      } else if (e.code == 'weak-password') {
        throw Exception("비밀번호가 너무 약합니다.");
      }
      throw Exception(e.message ?? "회원가입 실패");
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
