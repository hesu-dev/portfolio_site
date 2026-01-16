import '../wuxing/wu_xing_graph_type.dart';

class RelationResult {
  WuXingGraphType relationship;
  bool? isSamePolarity;

  RelationResult({required this.relationship, this.isSamePolarity});

  @override
  String toString() =>
      'relationship=${relationship.name}, samePolarity=$isSamePolarity';
}
