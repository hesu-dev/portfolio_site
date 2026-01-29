import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class HeroSection extends StatelessWidget {
  final bool isMobile;

  const HeroSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isMobile ? 350 : 500,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80',
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.3),
            colorBlendMode: BlendMode.darken,
          ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Where do you want to live?",
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: isMobile ? 28 : 48,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "어떤 집에서 살고 싶으신가요?",
                    style: AppTextStyles.heroSubtitle.copyWith(
                       fontSize: isMobile ? 14 : 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Search Box
                  Container(
                    width: isMobile ? double.infinity : 600,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Tabs
                        Row(
                          children: [
                            _SearchTab(text: "역세권청년주택", isSelected: false),
                            _SearchTab(text: "쉐어하우스", isSelected: true),
                            _SearchTab(text: "원룸", isSelected: false),
                          ],
                        ),
                        // Input and Button
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "지역 또는 하우스명으로 검색",
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A4A4A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SearchTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _SearchTab({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8),
            topRight: const Radius.circular(8),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
