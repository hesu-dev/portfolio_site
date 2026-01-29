import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/house_model.dart';
import 'package:intl/intl.dart';

class HouseCard extends StatelessWidget {
  final HouseModel house;

  const HouseCard({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###", "ko_KR");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.4,
                child: Image.network(
                  house.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    house.type,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house.name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  house.address,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                 const SizedBox(height: 8),
                   Text(
                   "보증금 ${currencyFormat.format(house.deposit ~/ 10000)} / 월 ${currencyFormat.format(house.monthlyRent ~/ 10000)}",
                   style: AppTextStyles.price,
                 ),
                 const SizedBox(height: 4),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey[300]!),
                     borderRadius: BorderRadius.circular(4)
                   ),
                   child: Text(
                     house.tags,
                     style: const TextStyle(fontSize: 10, color: Colors.grey),
                   ),
                 )
              ],
            ),
          )
        ],
      ),
    );
  }
}
