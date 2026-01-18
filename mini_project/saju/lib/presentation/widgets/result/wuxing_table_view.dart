import 'package:flutter/material.dart';
import 'package:saju/domain/enums/wu_xing.dart';

class WuXingTableView extends StatelessWidget {
  final Map<WuXing, double> percent;

  const WuXingTableView({super.key, required this.percent});

  String _status(double p) {
    if (p == 0) return '부족';
    if (p < 15) return '적정';
    if (p < 30) return '발달';
    return '과다';
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FixedColumnWidth(80),
        1: FixedColumnWidth(80),
        2: FixedColumnWidth(80),
      },
      children: [
        _headerRow(),
        ...WuXing.values.map((w) {
          final p = percent[w]!;
          return TableRow(
            children: [
              _cell('${w.korean}(${w.chinese})', color: w.color, bold: true),
              _cell('${p.toStringAsFixed(1)}%'),
              _cell(_status(p)),
            ],
          );
        }),
      ],
    );
  }

  TableRow _headerRow() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFE0DAD4)),
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('오행', textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('비율', textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('상태', textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _cell(String text, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
