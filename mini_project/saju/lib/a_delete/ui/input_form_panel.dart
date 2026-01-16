import 'package:flutter/material.dart';
import 'package:saju/a_delete/manses/calendar/strategy/calendar_mode.dart';

class InputFormPanel extends StatefulWidget {
  final void Function(DateTime birthDateTime) onSubmit;

  const InputFormPanel({super.key, required this.onSubmit});

  @override
  State<InputFormPanel> createState() => _InputFormPanelState();
}

class _InputFormPanelState extends State<InputFormPanel> {
  DateTime? birthDate;
  TimeOfDay? birthTime;

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDate: birthDate ?? DateTime(1990, 1, 1),
    );
    if (picked != null) setState(() => birthDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: birthTime ?? const TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) setState(() => birthTime = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final date = birthDate!;
    final time = birthTime ?? const TimeOfDay(hour: 0, minute: 0);

    final birthDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // ✅ 계산은 부모에게 위임
    widget.onSubmit(birthDateTime);
  }

  @override
  Widget build(BuildContext context, {CalendarMode mode = CalendarMode.solar}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '입력',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickDate,
                      child: Text(
                        birthDate == null
                            ? '생년월일 선택'
                            : '${birthDate!.year}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      child: Text(
                        birthTime == null
                            ? '시간 선택(선택)'
                            : '${birthTime!.hour.toString().padLeft(2, '0')}:${birthTime!.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                ],
              ),

              DropdownButton<CalendarMode>(
                value: mode,
                items: const [
                  DropdownMenuItem(
                    value: CalendarMode.solar,
                    child: Text('양력 기준'),
                  ),
                  DropdownMenuItem(
                    value: CalendarMode.lunar,
                    child: Text('음력 기준'),
                  ),
                ],
                onChanged: (v) => setState(() => mode = v!),
              ),

              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: '현재 단계',
                  border: OutlineInputBorder(),
                ),
                initialValue: '입력 → 계산 → 출력 구조로 전환 중',
                validator: (_) {
                  if (birthDate == null) return '생년월일을 선택하세요.';
                  return null;
                },
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('사주 계산'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
