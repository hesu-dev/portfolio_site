import '../enums/animal_title_type.dart';
import '../models/animal_title.dart';
import '../enums/sky.dart';
import '../enums/ground.dart';

class AnimalTitleService {
  /// ✅ enum 기반 해석
  AnimalTitle resolve(Sky sky, Ground ground) {
    final color = _colorBySky(sky);
    final animal = _animalByGround(ground);
    final type = _typeByGround(ground);

    return AnimalTitle(
      korean: '${color.koreanWord} ${animal.koreanWord}',
      koreanHanja: '${color.koreanHanja}${animal.koreanHanja}',
      chinese: '${color.chinese} ${animal.chinese}',
      meaning: _meaningByType(color, animal, type),
      type: type.name,
    );
  }

  // =========================
  // 천간 → 색 / 오행
  // =========================
  _ColorInfo _colorBySky(Sky sky) {
    switch (sky) {
      case Sky.byeong:
      case Sky.jeong:
        return const _ColorInfo('붉은', '적', '赤', '화(火)');

      case Sky.gap:
      case Sky.eul:
        return const _ColorInfo('푸른', '청', '靑', '목(木)');

      case Sky.gyeong:
      case Sky.sin:
        return const _ColorInfo('흰', '백', '白', '금(金)');

      case Sky.im:
      case Sky.gye:
        return const _ColorInfo('검은', '흑', '黑', '수(水)');

      case Sky.mu:
      case Sky.gi:
        return const _ColorInfo('황금', '황', '黃', '토(土)');
    }
  }

  // =========================
  // 지지 → 동물
  // =========================
  _AnimalInfo _animalByGround(Ground ground) {
    switch (ground) {
      case Ground.zi:
        return const _AnimalInfo('쥐', '서', '鼠');
      case Ground.chou:
        return const _AnimalInfo('소', '우', '牛');
      case Ground.yin:
        return const _AnimalInfo('호랑이', '호', '虎');
      case Ground.mao:
        return const _AnimalInfo('토끼', '토', '兔');
      case Ground.chen:
        return const _AnimalInfo('용', '용', '龍');
      case Ground.si:
        return const _AnimalInfo('뱀', '사', '蛇');
      case Ground.wu:
        return const _AnimalInfo('말', '마', '馬');
      case Ground.wei:
        return const _AnimalInfo('양', '양', '羊');
      case Ground.shen:
        return const _AnimalInfo('원숭이', '원', '猴');
      case Ground.you:
        return const _AnimalInfo('닭', '계', '鷄');
      case Ground.xu:
        return const _AnimalInfo('개', '견', '犬');
      case Ground.hai:
        return const _AnimalInfo('돼지', '저', '豬');
    }
  }

  // =========================
  // 지지 → 성향 타입
  // =========================
  AnimalTitleType _typeByGround(Ground ground) {
    switch (ground) {
      case Ground.chen:
      case Ground.yin:
        return AnimalTitleType.leader;

      case Ground.wu:
        return AnimalTitleType.runner;

      case Ground.zi:
      case Ground.shen:
        return AnimalTitleType.strategist;

      case Ground.chou:
      case Ground.wei:
        return AnimalTitleType.stabilizer;

      case Ground.mao:
      case Ground.si:
        return AnimalTitleType.observer;

      case Ground.xu:
        return AnimalTitleType.guardian;

      case Ground.hai:
        return AnimalTitleType.accumulator;
      case Ground.you:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  // =========================
  // 해석 문장
  // =========================
  String _meaningByType(
    _ColorInfo color,
    _AnimalInfo animal,
    AnimalTitleType type,
  ) {
    switch (type) {
      case AnimalTitleType.leader:
        return '${color.element} 기운을 바탕으로 '
            '강한 주도성과 상징성을 지닌 중심형입니다';

      case AnimalTitleType.runner:
        return '${color.element}의 추진력이 강해 '
            '행동이 빠르고 실행력이 뛰어납니다';

      case AnimalTitleType.strategist:
        return '${color.element}의 지혜로 '
            '판단이 빠르고 기회를 잘 포착합니다';

      case AnimalTitleType.stabilizer:
        return '${color.element} 기운으로 '
            '안정과 유지를 중시하는 성향입니다';

      case AnimalTitleType.observer:
        return '${color.element}의 섬세함으로 '
            '신중하고 감각적인 성향입니다';

      case AnimalTitleType.guardian:
        return '${color.element}의 책임감이 강해 '
            '맡은 역할을 끝까지 지킵니다';

      case AnimalTitleType.accumulator:
        return '${color.element}의 인내력이 강해 '
            '시간이 갈수록 힘을 축적합니다';
    }
  }
}

// =========================
// 내부 DTO (유지)
// =========================
class _ColorInfo {
  final String koreanWord; // 흰
  final String koreanHanja; // 백
  final String chinese; // 白
  final String element; // 금(金)

  const _ColorInfo(
    this.koreanWord,
    this.koreanHanja,
    this.chinese,
    this.element,
  );
}

class _AnimalInfo {
  final String koreanWord; // 말
  final String koreanHanja; // 마
  final String chinese; // 馬

  const _AnimalInfo(this.koreanWord, this.koreanHanja, this.chinese);
}
