import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (mounted) {
        final state = ref.read(authProvider);
        if (state.hasValue && state.value != null) {
          context.go('/');
        } else if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("로그인 실패: ${state.error}")),
          );
        }
      }
    }
  }

  void _onSocialLogin(String provider) async {
    await ref.read(authProvider.notifier).loginSocial(provider);
    if (mounted) {
      final state = ref.read(authProvider);
      if (state.hasValue && state.value != null) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 100,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40.h),
                  // Logo
                  Text(
                    "NELL WEATHER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: AppColors.textHighEmphasis,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "오늘의 날씨, 당신의 스타일",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textMediumEmphasis,
                    ),
                  ),
                  SizedBox(height: 50.h),

                  // ID
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: AppColors.textHighEmphasis),
                    decoration: InputDecoration(
                      labelText: "이메일",
                      labelStyle: TextStyle(color: AppColors.textMediumEmphasis),
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMediumEmphasis),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "이메일을 입력해주세요." : null,
                  ),
                  SizedBox(height: 16.h),

                  // PW
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: AppColors.textHighEmphasis),
                    decoration: InputDecoration(
                      labelText: "비밀번호",
                      labelStyle: TextStyle(color: AppColors.textMediumEmphasis),
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.textMediumEmphasis),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "비밀번호를 입력해주세요." : null,
                  ),
                  SizedBox(height: 24.h),

                  // Login Button
                  ElevatedButton(
                    onPressed: _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "로그인",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Guest Button
                  TextButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: Text(
                      "건너뛰기 (로그인 없이 시작)",
                      style: TextStyle(color: AppColors.textMediumEmphasis),
                    ),
                  ),

                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.textLowEmphasis)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text("간편 로그인", style: TextStyle(color: AppColors.textLowEmphasis)),
                      ),
                      Expanded(child: Divider(color: AppColors.textLowEmphasis)),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialButton(
                        asset: "assets/images/google_logo.png", // Demo: handle assets later or use Icon
                        icon: Icons.g_mobiledata,
                        color: Colors.white,
                        iconColor: Colors.black, // Google Red
                        onTap: () => _onSocialLogin("google"),
                      ),
                      SizedBox(width: 20.w),
                      _SocialButton(
                        icon: Icons.apple,
                        color: Colors.black,
                        iconColor: Colors.white,
                        onTap: () => _onSocialLogin("apple"),
                      ),
                       SizedBox(width: 20.w),
                      _SocialButton(
                        icon: Icons.chat_bubble, // Kakao approximation
                        color: const Color(0xFFFEE500),
                        iconColor: Colors.black,
                        onTap: () => _onSocialLogin("kakao"),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("계정이 없으신가요? ", style: TextStyle(color: AppColors.textMediumEmphasis)),
                      GestureDetector(
                        onTap: () => context.push('/signup'),
                        child: Text(
                          "회원가입",
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final String? asset;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: color, // Colors.white
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: 28.sp),
        ),
      ),
    );
  }
}
