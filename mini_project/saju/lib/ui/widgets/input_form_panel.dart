import 'package:flutter/material.dart';

class InputFormPanel extends StatefulWidget {
  const InputFormPanel({super.key});

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

    // ⚠️ 여기서 실제 사주 계산 API를 호출해야 합니다.
    // 하지만 현재 제공된 엔드포인트는 /v1/manses/base 뿐이라
    // 계산 API 스펙 없이 임의 호출/DTO를 만들면 "가짜 코드"가 됩니다.
    //
    // -> 아래 2개만 주면 즉시 연결합니다:
    // 1) 사주 계산 컨트롤러 엔드포인트 + Request/Response DTO
    // 2) 필요한 입력값(양력/음력, 성별, 윤달, 표준시 등)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사주 계산 API 스펙이 아직 없습니다. 계산 컨트롤러/DTO를 주면 연결합니다.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: '현재 단계',
                  border: OutlineInputBorder(),
                ),
                initialValue: '기본 데이터(/v1/manses/base) 연동 완료. 계산 API 대기 중.',
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
