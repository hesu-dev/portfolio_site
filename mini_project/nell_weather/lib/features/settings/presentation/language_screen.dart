import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nell_weather/core/constants/app_colors.dart';
import 'package:nell_weather/features/settings/provider/settings_provider.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  // 임시 리스트. 실제로는 Provider 상태에 따라 초기화됨.
  late List<Locale> _orderedLocales;

  @override
  void initState() {
    super.initState();
    // 초기 상태 로드 (현재 설정된 로케일이 최상단에 오도록)
    final currentLocale = ref.read(settingsProvider).locale;
    if (currentLocale.languageCode == 'ko') {
      _orderedLocales = const [Locale('ko'), Locale('en')];
    } else {
      _orderedLocales = const [Locale('en'), Locale('ko')];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("언어 설정"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "언어 우선순위를 변경하려면 항목을 길게 눌러 드래그하세요.\n가장 위에 있는 언어가 기본 언어로 설정됩니다.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMediumEmphasis,
                    height: 1.5,
                  ),
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                proxyDecorator: (child, index, animation) {
                   return Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface, // 드래그 중 배경색
                         borderRadius: BorderRadius.circular(16),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.1),
                             blurRadius: 10,
                             offset: const Offset(0,4)
                           )
                         ]
                      ),
                      child: child,
                    ),
                  );
                },
                children: [
                  for (final locale in _orderedLocales)
                    _buildLanguageItem(locale, Key(locale.languageCode)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(Locale locale, Key key) {
    String name = locale.languageCode == 'ko' ? "한국어" : "English";
    String flag = locale.languageCode == 'ko' ? "🇰🇷" : "🇺🇸";

    return Container(
      key: key,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cloudy), // 통일된 테두리
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        leading: Text(flag, style: TextStyle(fontSize: 24.sp)),
        title: Text(
          name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: Icon(Icons.drag_handle, color: AppColors.textMediumEmphasis),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _orderedLocales.removeAt(oldIndex);
      _orderedLocales.insert(newIndex, item);
    });

    // 최상단 언어로 설정 변경
    final topLocale = _orderedLocales.first;
    ref.read(settingsProvider.notifier).setLocale(topLocale);
  }
}
