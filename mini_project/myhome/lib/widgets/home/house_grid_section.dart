import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../data/dummy_data.dart';
import 'house_card.dart';

class HouseGridSection extends StatelessWidget {
  final bool isMobile;

  const HouseGridSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // Determine crossAxisCount based on screen width more granularly if needed,
    // but we use isMobile flag for simplicity.
    // Desktop: 4, Mobile: 1 (very small) or 2.
    int crossAxisCount = isMobile ? 2 : 4;
    double padding = isMobile ? 16 : 100;

    return Container(
      color: AppColors.backgroundLight,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's 인기하우스",
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              // Adjust for very small screens
              if (constraints.maxWidth < 350) {
                 crossAxisCount = 1;
              }
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: DummyData.houses.length,
                itemBuilder: (context, index) {
                  return HouseCard(house: DummyData.houses[index]);
                },
              );
            },
          ),
          const SizedBox(height: 30),
          Center(
             child: OutlinedButton(
               onPressed: (){},
               style: OutlinedButton.styleFrom(
                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                 side: const BorderSide(color: AppColors.primary),
               ),
               child: const Text("더 많은 하우스 보기", style: TextStyle(color: AppColors.primary)),
             ),
          )
        ],
      ),
    );
  }
}
