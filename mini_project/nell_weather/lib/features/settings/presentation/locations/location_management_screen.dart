import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../provider/settings_provider.dart';

class LocationManagementScreen extends ConsumerStatefulWidget {
  const LocationManagementScreen({super.key});

  @override
  ConsumerState<LocationManagementScreen> createState() =>
      _LocationManagementScreenState();
}

class _LocationManagementScreenState
    extends ConsumerState<LocationManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Store search results as Pairs of (Location, Placemark)
  List<({Location location, Placemark placemark})> _searchResults = [];
  bool _isSearching = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    // Rebuild to update icon color when text changes
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchPressed() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("검색어를 입력해주세요."),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isSearching = true;
      _errorMsg = null;
      _searchResults = [];
    });

    try {
      // 1. Get Locations from address query
      // locationFromAddress returns a list of candidate locations.
      // We'll limit to top 5 to keep it simple.
      List<Location> locations = await locationFromAddress(query);

      if (locations.isEmpty) {
        setState(() {
          _errorMsg = "검색 결과가 없습니다.";
        });
        return;
      }

      // 2. Reverse Geocode to get readable names (Placemarks)
      List<({Location location, Placemark placemark})> results = [];

      // Limit processing to prevent spamming the geocoder
      final processCount = locations.length > 5 ? 5 : locations.length;

      for (int i = 0; i < processCount; i++) {
        final loc = locations[i];
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            loc.latitude,
            loc.longitude,
          );
          if (placemarks.isNotEmpty) {
            results.add((location: loc, placemark: placemarks.first));
          }
        } catch (e) {
          // If reverse geocoding fails for one, skip it
          continue;
        }
      }

      setState(() {
        _searchResults = results;
        if (results.isEmpty) {
          _errorMsg = "상세 주소 정보를 찾을 수 없습니다.";
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = "위치 검색 중 오류가 발생했습니다.\n다른 검색어(예: 서울, New York)로 시도해보세요.";
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  /// Format Placemark into a readable string
  String _formatPlacemark(Placemark p) {
    // Priority: Locality (City) -> SubLocality -> AdministrativeArea -> Country
    List<String> parts = [];
    if (p.locality != null && p.locality!.isNotEmpty) parts.add(p.locality!);
    if (p.subLocality != null &&
        p.subLocality!.isNotEmpty &&
        p.subLocality != p.locality) {
      parts.add(p.subLocality!);
    }
    if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) {
      parts.add(p.administrativeArea!);
    }
    if (p.country != null && p.country!.isNotEmpty) parts.add(p.country!);

    // If we have useful info, join it. Otherwise fallback to name or street.
    if (parts.isNotEmpty) {
      return parts.join(", ");
    }
    return p.name ?? p.street ?? "Unknown Location";
  }

  void _onLocationTap(Location loc, Placemark p) {
    final defaultName = _formatPlacemark(p);
    final nicknameController = TextEditingController(text: defaultName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("위치 추가"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("이 위치를 추가하시겠습니까?", style: TextStyle(fontSize: 12.sp)),
              SizedBox(height: 8.h),
              Text(
                defaultName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                  labelText: "별칭 (선택 사항)",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textLowEmphasis),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "취소",
                style: TextStyle(color: AppColors.textMediumEmphasis),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await _saveLocation(loc, nicknameController.text.trim());
              },
              child: Text(
                "저장",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveLocation(Location loc, String nickname) async {
    final nameToSave = nickname.isEmpty
        ? "Unknown"
        : nickname; // Should maintain dialog value

    try {
      final newLocation = CustomLocation(
        id: const Uuid().v4(),
        name: nameToSave,
        lat: loc.latitude,
        lng: loc.longitude,
        isActive: true, // Auto-activate
      );

      // Add
      await ref.read(settingsProvider.notifier).addLocation(newLocation);
      // Toggle Active
      await ref
          .read(settingsProvider.notifier)
          .toggleLocationActive(newLocation.id);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("저장되었습니다: $nameToSave")));
        setState(() {
          _searchController.clear();
          _searchResults = [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("저장 실패: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final savedLocations = settings.customLocations;
    final hasText = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("내 주소 목록"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            // 1. Simple Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textMediumEmphasis),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _onSearchPressed(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "도시 이름 (예: Seoul, Tokyo)",
                        hintStyle: TextStyle(color: AppColors.textLowEmphasis),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isSearching
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            Icons.send,
                            // Gray if empty, Primary if not
                            color: hasText ? AppColors.primary : Colors.grey,
                          ),
                    onPressed: _onSearchPressed,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // 2. Content Area (Search Results OR Saved List)
            Expanded(
              child:
                  _searchResults.isNotEmpty ||
                      (_isSearching || _errorMsg != null)
                  ? _buildSearchResults()
                  : _buildSavedList(savedLocations),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_errorMsg != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            _errorMsg!,
            style: TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Results
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            "검색 결과",
            style: TextStyle(
              color: AppColors.textMediumEmphasis,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final item = _searchResults[index];
              return ListTile(
                onTap: () => _onLocationTap(item.location, item.placemark),
                leading: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textMediumEmphasis,
                ),
                title: Text(
                  _formatPlacemark(item.placemark),
                  style: TextStyle(color: AppColors.textLowEmphasis),
                ),
                subtitle: Text(
                  "${item.location.latitude.toStringAsFixed(4)}, ${item.location.longitude.toStringAsFixed(4)}",
                  style: TextStyle(
                    color: AppColors.textLowEmphasis,
                    fontSize: 12.sp,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSavedList(List<CustomLocation> locations) {
    if (locations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 48.sp,
              color: AppColors.surfaceVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              "자주 가는 지역을 추가해보세요.\n(예: 집, 회사, 여행지 등)",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMediumEmphasis),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "내 주소 목록",
          style: TextStyle(
            color: AppColors.textMediumEmphasis,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.separated(
            itemCount: locations.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final loc = locations[index];
              return Dismissible(
                key: Key(loc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref.read(settingsProvider.notifier).removeLocation(loc.id);
                },
                child: GestureDetector(
                  onTap: () async {
                    await ref
                        .read(settingsProvider.notifier)
                        .toggleLocationActive(loc.id);

                    // Optional: Show snackbar
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("'${loc.name}'(으)로 위치가 설정되었습니다."),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: loc.isActive
                          ? Border.all(color: AppColors.primary, width: 2)
                          : Border.all(
                              color: const Color.fromARGB(255, 142, 142, 142),
                              width: 1,
                            ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: loc.isActive
                                      ? AppColors.primary
                                      : AppColors.background,
                                ),
                              ),
                              Text(
                                "${loc.lat.toStringAsFixed(4)}, ${loc.lng.toStringAsFixed(4)}",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                        if (loc.isActive)
                          Icon(Icons.check_circle, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
