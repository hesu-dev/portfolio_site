import 'package:flutter/material.dart';

void showJijiTimeTable(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF5B524B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const JijiTimeTableSheet(),
  );
}

class JijiTimeTableSheet extends StatelessWidget {
  const JijiTimeTableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('12간지 시간표', style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 12),
          Text(
            '자시: 23:30~01:30\n축시: 01:30~03:30\n...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
