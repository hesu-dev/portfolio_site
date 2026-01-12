class YinYang {
  final String korean;
  final String chinese;

  YinYang({required this.korean, required this.chinese});

  factory YinYang.fromJson(Map<String, dynamic> json) {
    return YinYang(
      korean: json['korean'] as String,
      chinese: json['chinese'] as String,
    );
  }
}
