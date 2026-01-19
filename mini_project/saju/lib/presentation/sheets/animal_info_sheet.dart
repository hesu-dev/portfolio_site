import 'package:flutter/material.dart';

void AnimalInfoTable(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF5B524B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const AnimalInfoSheet(),
  );
}

class AnimalInfoSheet extends StatelessWidget {
  const AnimalInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('일주동물', style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 12),
          Text(
            '내가 태어난 날짜를 비유하는 동물로써 나의 본성과 정체성을 나타냅니다. 5가지 색상의 12가지 동물로 총 60개의 일주동물이 존재합니다.\n...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
