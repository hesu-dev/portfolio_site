String two(int n) => n.toString().padLeft(2, '0');

String ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}';

String hm(int hour, int minute) => '${two(hour)}:${two(minute)}';
