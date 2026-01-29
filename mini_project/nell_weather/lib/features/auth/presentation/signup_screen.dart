import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../provider/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _onSignUp() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nicknameController.text.trim(),
          );
      if (mounted) {
        final state = ref.read(authProvider);
        if (state.hasValue && state.value != null) {
          // Success -> Go Home
          context.go('/');
        } else if (state.hasError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("회원가입 실패: ${state.error}")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("회원가입"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "환영합니다!",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHighEmphasis,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 40.h),

                // Email
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: AppColors.textHighEmphasis),
                  decoration: InputDecoration(
                    labelText: "이메일",
                    labelStyle: TextStyle(color: AppColors.textMediumEmphasis),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "이메일을 입력해주세요." : null,
                ),
                SizedBox(height: 16.h),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: AppColors.textHighEmphasis),
                  decoration: InputDecoration(
                    labelText: "비밀번호",
                    labelStyle: TextStyle(color: AppColors.textMediumEmphasis),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) => value == null || value.length < 6
                      ? "비밀번호는 6자 이상이어야 합니다."
                      : null,
                ),
                SizedBox(height: 16.h),

                // Nickname
                TextFormField(
                  controller: _nicknameController,
                  style: TextStyle(color: AppColors.textHighEmphasis),
                  decoration: InputDecoration(
                    labelText: "닉네임",
                    labelStyle: TextStyle(color: AppColors.textMediumEmphasis),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "닉네임을 입력해주세요." : null,
                ),

                SizedBox(height: 40.h),
                ElevatedButton(
                  onPressed: _onSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "가입하기",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
