import '../../core/base_enum.dart';
import '../wuxing/wu_xing_graph_type.dart';
import '../model/relation_result.dart';

/// Java Blood enum 대응
enum Blood implements BaseEnum {
  // 비겁 (same wuxing)
  biGyeon('비견', '比肩', BloodKey(WuXingGraphType.defaultType, false)),
  geobJae('겁재', '劫財', BloodKey(WuXingGraphType.defaultType, true)),

  // 식상 (내가 생함) = 상생 정방향
  sikSin('식신', '食神', BloodKey(WuXingGraphType.forwardPositive, false)),
  sangGwan('상관', '傷官', BloodKey(WuXingGraphType.forwardPositive, true)),

  // 재성 (내가 극함) = 상극 정방향
  jeongJae('정재', '正財', BloodKey(WuXingGraphType.forwardNegative, false)),
  pyeonJae('편재', '偏財', BloodKey(WuXingGraphType.forwardNegative, true)),

  // 관성 (나를 극함) = 상극 역방향
  jeongGwan('정관', '正官', BloodKey(WuXingGraphType.reverseNegative, false)),
  pyeonGwan('편관', '偏官', BloodKey(WuXingGraphType.reverseNegative, true)),

  // 인성 (나를 생함) = 상생 역방향
  jeongIn('정인', '正印', BloodKey(WuXingGraphType.reversePositive, false)),
  pyeonIn('편인', '偏印', BloodKey(WuXingGraphType.reversePositive, true));

  @override
  final String korean;
  @override
  final String chinese;

  final BloodKey key;
  const Blood(this.korean, this.chinese, this.key);

  static final Map<BloodKey, Blood> _map = {
    for (final b in Blood.values) b.key: b,
  };

  /// Java: Blood.from(WuXingRelation.Result result)
  static Blood? fromRelation(RelationResult result) {
    final samePolarity = result.isSamePolarity;
    if (samePolarity == null) return null; // GanJi 분석이 아닌 경우
    return _map[BloodKey(result.relationship, samePolarity)];
  }
}

/// Java Blood.Key 대응 (equals/hashcode 필요)
class BloodKey {
  final WuXingGraphType type;
  final bool isSamePolarity;

  const BloodKey(this.type, this.isSamePolarity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BloodKey &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          isSamePolarity == other.isSamePolarity;

  @override
  int get hashCode => Object.hash(type, isSamePolarity);
}
