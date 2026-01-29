import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';

class HomeFooter extends StatelessWidget {
  final bool isMobile;

  const HomeFooter({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(
          vertical: 40, horizontal: isMobile ? 20 : 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("THE COME & STAY",
                  style:
                      AppTextStyles.headerLogo.copyWith(color: Colors.grey[500])),
              if (!isMobile)
                Row(
                  children: [
                    _FooterLink("회사소개"),
                    _FooterLink("이용약관"),
                    _FooterLink("개인정보처리방침"),
                  ],
                )
            ],
          ),
          const SizedBox(height: 20),
          if (isMobile) ...[
            _FooterLink("회사소개"),
            _FooterLink("이용약관"),
            _FooterLink("개인정보처리방침"),
            const SizedBox(height: 20),
          ],
          Text(
            "상호: 더컴앤스테이 | 대표: 김대표\n주소: 서울특별시 마포구\n사업자등록번호: 000-00-00000\n통신판매업신고: 2026-서울마포-0000\n이메일: help@thecomenstay.com",
            style: AppTextStyles.caption.copyWith(height: 1.5),
          ),
          const SizedBox(height: 20),
          Text(
            "Copyright © THE COME & STAY. All Rights Reserved.",
            style: AppTextStyles.caption.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 5),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
