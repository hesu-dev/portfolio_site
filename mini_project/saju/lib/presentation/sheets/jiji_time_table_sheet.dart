import 'package:flutter/material.dart';

void showJijiTimeTable(BuildContext context) {
  showModalBottomSheet(
    context: context,
    // isScrollControlled: true,
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
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '12간지 시간표',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                '간지에 맞춰 시간을 입력하실 때는 시스템 자동 보정값을 고려해 1시간 이상 늦은 시간을 쓰시는 것을 추천드립니다.\n'
                '예를 들어 ‘자시’라면 01:20, 축시라면 3:20으로 입력하시는게 좋습니다.\n',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Table(
                border: TableBorder.all(color: Colors.white54, width: 1),
                columnWidths: const {
                  0: FixedColumnWidth(80),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [_headerRow(), ..._rows()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TableRow _headerRow() {
  return TableRow(
    decoration: const BoxDecoration(color: Color(0xFF6F6862)),
    children: const [_HeaderCell('간지'), _HeaderCell('시간')],
  );
}

/// 본문 rows
List<TableRow> _rows() {
  const data = [
    ['자시', '23:30(전날)~01:30'],
    ['축시', '01:30~03:30'],
    ['인시', '03:30~05:30'],
    ['묘시', '05:30~07:30'],
    ['진시', '07:30~09:30'],
    ['사시', '09:30~11:30'],
    ['오시', '11:30~13:30'],
    ['미시', '13:30~15:30'],
    ['신시', '15:30~17:30'],
    ['유시', '17:30~19:30'],
    ['술시', '19:30~21:30'],
    ['해시', '21:30~23:30'],
  ];

  return data.map((row) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.black),
      children: [_BodyCell(row[0], bold: true), _BodyCell(row[1])],
    );
  }).toList();
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  final bool bold;
  const _BodyCell(this.text, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
