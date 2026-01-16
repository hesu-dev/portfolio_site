enum WuXingGraphType {
  defaultType(0),

  forwardPositive(1), // 상생 ->
  reversePositive(-1), // 상생 <-

  forwardNegative(2), // 상극 ->
  reverseNegative(-2); // 상극 <-

  final int weight;
  const WuXingGraphType(this.weight);
}
