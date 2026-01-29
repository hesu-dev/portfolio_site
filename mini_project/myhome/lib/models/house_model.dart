class HouseModel {
  final String id;
  final String imageUrl;
  final String type; // e.g. "쉐어하우스", "청년주택"
  final String name;
  final String address;
  final int deposit; // 보증금
  final int monthlyRent; // 월세
  final String tags; // e.g., "여성전용", "남녀공용"

  HouseModel({
    required this.id,
    required this.imageUrl,
    required this.type,
    required this.name,
    required this.address,
    required this.deposit,
    required this.monthlyRent,
    required this.tags,
  });
}
