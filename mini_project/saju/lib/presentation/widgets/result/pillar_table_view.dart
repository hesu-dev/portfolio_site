import 'package:flutter/material.dart';

import '../../../domain/models/manse_result_dto.dart';

class PillarTableView extends StatelessWidget {
  final ManseResultDto result;

  const PillarTableView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final p = result.pillars;

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {0: FixedColumnWidth(64)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _headerRow(),
        _row('천간', [p.time.sky, p.day.sky, p.month.sky, p.year.sky], big: true),
        // _row('십성', [
        //   p.time.bloodSky ?? '-',
        //   p.day.bloodSky ?? '-',
        //   p.month.bloodSky ?? '-',
        //   p.year.bloodSky ?? '-',
        // ]),
        _row('지지', [
          p.time.ground,
          p.day.ground,
          p.month.ground,
          p.year.ground,
        ], big: true),
        // _row('십성', [
        //   p.time.bloodGround ?? '-',
        //   p.day.bloodGround ?? '-',
        //   p.month.bloodGround ?? '-',
        //   p.year.bloodGround ?? '-',
        // ]),
        // _row('지장간', [
        //   p.time.hidden ?? '-',
        //   p.day.hidden ?? '-',
        //   p.month.hidden ?? '-',
        //   p.year.hidden ?? '-',
        // ]),
        // _row('12운성', [
        //   p.time.twelveState ?? '-',
        //   p.day.twelveState ?? '-',
        //   p.month.twelveState ?? '-',
        //   p.year.twelveState ?? '-',
        // ]),
        // _row('12신살', [
        //   p.time.twelveGod ?? '-',
        //   p.day.twelveGod ?? '-',
        //   p.month.twelveGod ?? '-',
        //   p.year.twelveGod ?? '-',
        // ]),
      ],
    );
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      children: const [
        SizedBox(),
        _HeaderCell('생시'),
        _HeaderCell('생일'),
        _HeaderCell('생월'),
        _HeaderCell('생년'),
      ],
    );
  }

  TableRow _row(String label, List<String> values, {bool big = false}) {
    return TableRow(
      children: [
        _LabelCell(label),
        ...values.map((v) => _ValueCell(v, big: big)),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _LabelCell extends StatelessWidget {
  final String text;
  const _LabelCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String text;
  final bool big;
  const _ValueCell(this.text, {this.big = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: big ? 20 : 14,
            fontWeight: big ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
