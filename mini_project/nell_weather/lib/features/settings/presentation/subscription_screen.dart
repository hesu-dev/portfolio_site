import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nell_weather/core/constants/app_colors.dart';
import 'package:nell_weather/features/auth/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isLoading = false;

  // 실제 백엔드 사용시 변경 필요
  // Firebase Extension 사용 시, Firestore에 문서를 쓰면 자동으로 checkout session이 생성됨
  // 혹은, 커스텀 백엔드 호출
  Future<void> _startSubscription() async {
    final user = ref.read(authProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      context.go('/login');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. (옵션 A) Firebase Extension - Run Payments with Stripe 방식
      // Firestore 'customers/{uid}/checkout_sessions'에 문서 생성 -> Extension이 처리 -> url 반환
      /*
      final docRef = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user.id)
          .collection('checkout_sessions')
          .add({
        'price': 'price_1234567890', // Stripe Dashboard에서 생성한 Price ID
        'success_url': 'https://your-app-link/success',
        'cancel_url': 'https://your-app-link/cancel',
      });
      
      // Extension이 응답할 때까지 대기
      docRef.snapshots().listen((snap) {
        if (snap.data()!.containsKey('url')) {
           // 웹뷰 등으로 리다이렉트
        }
      });
      */

      // 2. (옵션 B) 커스텀 백엔드 또는 Cloud Functions 호출 방식 (가장 일반적 모바일 플로우)
      // 여기서는 예시로 PaymentSheet를 띄우는 코드를 작성합니다.
      // 백엔드에서 client_secret, ephemeralKey, customerId를 받아와야 합니다.
      
      // MOCK: 백엔드 호출 시뮬레이션
      // 실제로는 Dio().post('YOUR_BACKEND_URL/payment-sheet') 사용
      await Future.delayed(const Duration(seconds: 1)); 
      
      /*
      // 실제 연동 시 주석 해제 및 백엔드 스펙에 맞게 수정
      final response = await Dio().post(
        'YOUR_BACKEND_URL/payment-sheet',
        data: {
          'email': user.email,
          'userId': user.id,
        }
      );
      final json = response.data;
      
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Nell Weather',
          paymentIntentClientSecret: json['paymentIntent'],
          customerEphemeralKeySecret: json['ephemeralKey'],
          customerId: json['customer'],
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구독이 완료되었습니다!')),
      );
      */
      
      // DEMO: UI 확인용 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('백엔드 연동이 필요합니다. 코드를 확인해주세요.')),
      );

    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제 취소 또는 실패: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Premium 구독"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B4DFF), Color(0xFF9F83FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4DFF).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.diamond_outlined, size: 60.w, color: Colors.white),
                    SizedBox(height: 16.h),
                    Text(
                      "Nell Weather Premium",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "모든 기능을 제한 없이 즐기세요",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "₩4,900 / 월",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              _BenefitRow(icon: Icons.check_circle, text: "무제한 도트 아트 생성"),
              SizedBox(height: 16.h),
              _BenefitRow(icon: Icons.check_circle, text: "광고 없는 쾌적한 환경"),
              SizedBox(height: 16.h),
              _BenefitRow(icon: Icons.check_circle, text: "다크 모드 전용 테마"),
              
              const Spacer(),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _startSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "구독 시작하기",
                      style: TextStyle(
                        fontSize: 18.sp, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
              ),
              SizedBox(height: 16.h),
              Text(
                "언제든지 취소할 수 있습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLowEmphasis, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24.sp),
        SizedBox(width: 12.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textHighEmphasis,
          ),
        ),
      ],
    );
  }
}
