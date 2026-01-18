import 'package:flutter/material.dart';
import '../../domain/models/manse_request_dto.dart';
import '../../core/utils/date_time_utils.dart';

class InputDateTimeForm extends StatefulWidget {
  final Future<void> Function(ManseRequestDto req) onSubmit;
  final bool loading;

  const InputDateTimeForm({
    super.key,
    required this.onSubmit,
    required this.loading,
  });

  @override
  State<InputDateTimeForm> createState() => _InputDateTimeFormState();
}

class _InputDateTimeFormState extends State<InputDateTimeForm> {
  DateTime? _date;
  TimeOfDay? _time;
  CalendarType _type = CalendarType.solar;
  bool _leap = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: _date ?? now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    if (_date == null || _time == null) return;

    final req = ManseRequestDto(
      calendarType: _type,
      date: _date!,
      hour: _time!.hour,
      minute: _time!.minute,
      isLeapMonth: _leap,
    );

    await widget.onSubmit(req);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _date == null ? '미선택' : ymd(_date!);
    final timeText = _time == null ? '미선택' : hm(_time!.hour, _time!.minute);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '입력',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: widget.loading ? null : _pickDate,
                  child: Text('날짜 선택: $dateText'),
                ),
                OutlinedButton(
                  onPressed: widget.loading ? null : _pickTime,
                  child: Text('시간 선택: $timeText'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SegmentedButton<CalendarType>(
              segments: const [
                ButtonSegment(value: CalendarType.solar, label: Text('양력')),
                ButtonSegment(value: CalendarType.lunar, label: Text('음력')),
              ],
              selected: {_type},
              onSelectionChanged: widget.loading
                  ? null
                  : (s) => setState(() => _type = s.first),
            ),

            const SizedBox(height: 8),

            if (_type == CalendarType.lunar)
              Row(
                children: [
                  const Text('윤달'),
                  const SizedBox(width: 8),
                  Switch(
                    value: _leap,
                    onChanged: widget.loading
                        ? null
                        : (v) => setState(() => _leap = v),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: widget.loading ? null : _submit,
              child: widget.loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('계산하기'),
            ),
          ],
        ),
      ),
    );
  }
}
