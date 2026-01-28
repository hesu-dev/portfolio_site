import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nell_weather/features/pixel_maker/presentation/widgets/avatar_preview_widget.dart';
import 'package:nell_weather/features/pixel_maker/presentation/widgets/pixel_avatar_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../weather/provider/avatar_provider.dart';

class PixelMakerScreen extends ConsumerStatefulWidget {
  const PixelMakerScreen({super.key});

  @override
  ConsumerState<PixelMakerScreen> createState() => _PixelMakerScreenState();
}

class _PixelMakerScreenState extends ConsumerState<PixelMakerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> categories = [
    "Skin",
    "Face",
    "Color", // Hair Color
    "Front", // Front Hair
    "Back", // Back Hair
    "Outfit",
    "Hat", // Accessory
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarState = ref.watch(avatarProvider);
    final avatarNotifier = ref.read(avatarProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AVATAR MAKER",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Avatar Saved!"),
                  duration: Duration(seconds: 1),
                ),
              );
              context.pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Preview Area
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color.fromARGB(
                    255,
                    156,
                    156,
                    156,
                  ).withOpacity(0.5),
                ),
              ),
              child: Center(
                child: AvatarPreviewWidget(config: avatarState, scale: 2.0),
              ),
            ),
          ),

          // 2. Category Tabs
          Container(
            height: 50.h,
            color: const Color.fromARGB(255, 145, 145, 145).withOpacity(0.5),
            child: TabBar(
              controller: _tabController,
              isScrollable: true, // Scrollable for 7 tabs
              indicatorColor: AppColors.primary,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              tabs: categories.map((c) => Tab(text: c)).toList(),
            ),
          ),

          // 3. Options Grid
          Expanded(
            flex: 3,
            child: Container(
              color: const Color.fromARGB(255, 204, 204, 204),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 0. Skin
                  _buildOptionGrid(
                    count: 5,
                    selectedIndex: avatarState.skinColorIndex,
                    onTap: avatarNotifier.updateSkinColor,
                    itemBuilder: (index, isSelected) => CircleAvatar(
                      backgroundColor: PixelAvatarAssets.getSkinColor(index),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.black45)
                          : null,
                    ),
                  ),
                  // 1. Face
                  _buildOptionGrid(
                    count: PixelAvatarAssets.faces.length,
                    selectedIndex: avatarState.faceStyleIndex,
                    onTap: avatarNotifier.updateFaceStyle,
                    itemBuilder: (index, isSelected) => Icon(
                      _getFaceIcon(index),
                      color: isSelected ? AppColors.primary : Colors.grey,
                      size: 32.sp,
                    ),
                  ),
                  // 2. Hair Color
                  _buildOptionGrid(
                    count: 10,
                    selectedIndex: avatarState.hairColorIndex,
                    onTap: avatarNotifier.updateHairColor,
                    itemBuilder: (index, isSelected) => CircleAvatar(
                      backgroundColor: PixelAvatarAssets.getHairColor(index),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                  // 3. Front Hair
                  _buildOptionGrid(
                    count: PixelAvatarAssets.hairFront.length,
                    selectedIndex: avatarState.hairStyleIndex,
                    onTap: avatarNotifier.updateHairStyle,
                    itemBuilder: (index, isSelected) =>
                        _buildTextIcon("F${index + 1}", isSelected),
                  ),
                  // 4. Back Hair
                  _buildOptionGrid(
                    count: PixelAvatarAssets.hairBack.length,
                    selectedIndex: avatarState.hairBackIndex,
                    onTap: avatarNotifier.updateHairBack,
                    itemBuilder: (index, isSelected) =>
                        _buildTextIcon("B${index + 1}", isSelected),
                  ),
                  // 5. Outfit
                  _buildOptionGrid(
                    count: PixelAvatarAssets.outfits.length,
                    selectedIndex: avatarState.outfitIndex,
                    onTap: avatarNotifier.updateOutfit,
                    itemBuilder: (index, isSelected) => Icon(
                      Icons.checkroom, // Outfit icon
                      color: isSelected ? AppColors.primary : Colors.grey,
                      size: 32.sp,
                    ),
                  ),
                  // 6. Accessory (Hat)
                  _buildOptionGrid(
                    count: PixelAvatarAssets.accessories.length,
                    selectedIndex: avatarState.accessoryIndex,
                    onTap: avatarNotifier.updateAccessory,
                    itemBuilder: (index, isSelected) => Icon(
                      index == 0 ? Icons.close : Icons.whatshot, // Hat icon
                      color: isSelected ? AppColors.primary : Colors.grey,
                      size: 32.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextIcon(String text, bool isSelected) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildOptionGrid({
    required int count,
    required int selectedIndex,
    required Function(int) onTap,
    required Widget Function(int index, bool isSelected) itemBuilder,
  }) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // More items per row
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.w,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(child: itemBuilder(index, isSelected)),
          ),
        );
      },
    );
  }

  IconData _getFaceIcon(int index) {
    const faces = [
      Icons.sentiment_satisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_very_satisfied,
      Icons.face_retouching_natural,
      Icons.mood,
      Icons.sentiment_dissatisfied,
    ];
    if (index >= faces.length) return Icons.face;
    return faces[index];
  }
}
