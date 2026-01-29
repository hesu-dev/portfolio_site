import '../models/house_model.dart';
import 'dart:math';

class DummyData {
  static List<String> imageUrls = [
    'https://picsum.photos/id/10/400/300',
    'https://picsum.photos/id/11/400/300',
    'https://picsum.photos/id/12/400/300',
    'https://picsum.photos/id/13/400/300',
    'https://picsum.photos/id/14/400/300',
    'https://picsum.photos/id/15/400/300',
    'https://picsum.photos/id/16/400/300',
    'https://picsum.photos/id/17/400/300',
  ];

  static List<HouseModel> get houses {
    final random = Random();
    return List.generate(8, (index) {
      return HouseModel(
        id: 'house_$index',
        imageUrl: imageUrls[index % imageUrls.length],
        type: index % 2 == 0 ? "쉐어하우스" : "청년주택",
        name: "더컴앤스테이 하우스 ${index + 1}호점",
        address: "서울시 마포구 연남동 123-$index",
        deposit: (random.nextInt(100) + 10) * 100000,
        monthlyRent: (random.nextInt(50) + 30) * 10000,
        tags: index % 3 == 0 ? "여성전용" : "남녀공용",
      );
    });
  }
}
