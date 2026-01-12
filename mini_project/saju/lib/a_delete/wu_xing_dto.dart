class WuXingDto {
  final String korean;
  final String chinese;
  final String color;

  WuXingDto({required this.korean, required this.chinese, required this.color});

  factory WuXingDto.fromJson(Map<String, dynamic> json) {
    return WuXingDto(
      korean: json['korean'] as String,
      chinese: json['chinese'] as String,
      color: json['color'] as String,
    );
  }
}
