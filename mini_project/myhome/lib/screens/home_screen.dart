import 'package:flutter/material.dart';
import '../widgets/responsive/responsive_layout.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/house_grid_section.dart';
import '../widgets/home/home_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: const HomeScaffold(isMobile: true),
      desktopScaffold: const HomeScaffold(isMobile: false),
    );
  }
}

class HomeScaffold extends StatelessWidget {
  final bool isMobile;

  const HomeScaffold({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HomeHeader(isMobile: isMobile),
      ),
      drawer: isMobile ? const _MobileDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(isMobile: isMobile),
            HouseGridSection(isMobile: isMobile),
            // TODO: Add other sections like Tabs, Banners, InfoGrid
            const SizedBox(height: 40),
            HomeFooter(isMobile: isMobile),
          ],
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Text('Menu', style: TextStyle(fontSize: 24)),
          ),
          ListTile(title: const Text('하우스검색'), onTap: () {}),
          ListTile(title: const Text('더컴앤스테이'), onTap: () {}),
          ListTile(title: const Text('입주후기'), onTap: () {}),
          ListTile(title: const Text('자주묻는질문'), onTap: () {}),
        ],
      ),
    );
  }
}
