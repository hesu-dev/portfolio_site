import 'package:flutter/material.dart';

void showYajaJojaInfo(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF5B524B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        '야자시/조자시\n\n'
        '사주에서 하루가 바뀌는 자시는 저녁 11:30에 해당합니다. 그런데 야자시는 이 자시를 둘로 나눠 12시에 날짜가 변경되는 현대 시간 개념을 적용하는 것입니다.\n'
        '예를 들어 서울 기준, 저녁 11:30~00:00 사이에 태어난 경우, 시간 값은 그대로 두고 일자를 전날로 변환하여 해석하는 방식입니다.\n\n'
        '일반적인 해석방법은 아니나 포스텔러에서는 다양한 풀이방식을 제공하고자 야자시/조자시를 선택하실 수 있도록 하였습니다.',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
