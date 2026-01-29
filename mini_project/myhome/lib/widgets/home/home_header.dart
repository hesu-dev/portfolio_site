import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class HomeHeader extends StatelessWidget {
  final bool isMobile;

  const HomeHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: isMobile
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo placeholder (Text for now)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Text("THE COME & STAY", style: AppTextStyles.headerLogo.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      actions: isMobile
          ? [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black)),
            ]
          : [
              // Desktop Menu Items
              _DesktopMenuItem(text: "하우스검색"),
              _DesktopMenuItem(text: "더컴앤스테이"),
              _DesktopMenuItem(text: "입주후기"),
              _DesktopMenuItem(text: "자주묻는질문"),
              const SizedBox(width: 20),
              TextButton(onPressed: () {}, child: Text("로그인", style: AppTextStyles.navItem)),
              TextButton(onPressed: () {}, child: Text("회원가입", style: AppTextStyles.navItem)),
              const SizedBox(width: 20),
            ],
    );
  }
}

class _DesktopMenuItem extends StatelessWidget {
  final String text;
  
  const _DesktopMenuItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () {},
        child: Text(text, style: AppTextStyles.navItem),
      ),
    );
  }
}
