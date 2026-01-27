import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialType { instagram, linkedin, blog, twitter }

Future<void> openSocialLink(SocialType type) async {
  final url = switch (type) {
    SocialType.instagram => 'https://instagram.com/nelll_014/',
    SocialType.linkedin =>
      'https://www.linkedin.com/in/%ED%9D%AC%EC%88%98-%EB%AF%BC-938105237/',
    SocialType.blog => 'https://velog.io/@hs0647/posts',
    SocialType.twitter => 'https://twitter.com/your_account',
  };

  final uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('링크를 열 수 없습니다: $url');
  }
}

Widget socialIcon({required IconData icon, required SocialType type}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => openSocialLink(type),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.black12,
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    ),
  );
}
