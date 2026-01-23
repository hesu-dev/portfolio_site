import 'package:flutter/material.dart';

void showYongshinInfo(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF5B524B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        '용신은 내가 사용하는 신, 혹은 기운이라는 뜻으로 내 인생에 도움을 주는 기운을 뜻합니다. 용신에는 여러 종류가 있으며 자신의 사주에 맞추어 적절한 용신을 사용합니다.\n\n'
        '억부용신 : 과한 기운을 억눌러주는 용신\n'
        '통관용신 : 막혀있는 기운을 통하게 해주는 용신\n'
        '조후용신 : 기후를 보아 온도의 균형을 잡는 용신\n'
        '종용신 : 극단적으로 치우친 사주를 위한 용신',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
