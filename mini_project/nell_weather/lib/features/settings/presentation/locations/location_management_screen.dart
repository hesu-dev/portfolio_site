import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../data/models/juso_model.dart';
import '../../../../../data/sources/remote/juso_api_service.dart';
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
  final JusoApiService _jusoService = JusoApiService();

  List<JusoModel> _searchResults = [];
  bool _isSearching = false;
  String? _errorMsg;

  void _searchJuso() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _errorMsg = null;
      _searchResults = [];
    });

    try {
      final results = await _jusoService.searchAddress(query);
      setState(() {
        _searchResults = results;
        if (results.isEmpty) _errorMsg = "No results found.";
      });
    } catch (e) {
      // Check for missing key error specifically to guide user
      if (e.toString().contains("JUSO_API_KEY")) {
        setState(
          () => _errorMsg = "API Key Error: JUSO_API_KEY missing in .env",
        );
      } else {
        setState(() => _errorMsg = "Error: $e");
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _onLocationTap(JusoModel juso) {
    // Show Dialog for Nickname
    final nicknameController = TextEditingController(
      text: juso.bdNm.isNotEmpty ? juso.bdNm : juso.roadAddr,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            "Add Location",
            style: TextStyle(color: AppColors.textHighEmphasis),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                juso.roadAddr,
                style: TextStyle(
                  color: AppColors.textMediumEmphasis,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                  labelText: "Nickname (e.g. Home)",
                  labelStyle: TextStyle(color: AppColors.textMediumEmphasis),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textLowEmphasis),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                style: TextStyle(color: AppColors.textHighEmphasis),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColors.textMediumEmphasis),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await _saveLocation(juso, nicknameController.text.trim());
              },
              child: Text(
                "Save",
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

  Future<void> _saveLocation(JusoModel juso, String nickname) async {
    // 1. Loading Indicator via SnackBar or Overlay?
    // Let's use SnackBar for simplicity
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Processing location data...")),
    );

    try {
      // 2. Geocoding to get Lat/Lng
      // JusoModel provides address strings. We use `locationFromAddress` from geocoding package.
      // Use roadAddr for best results.
      List<Location> locations = await locationFromAddress(juso.roadAddr);

      if (locations.isNotEmpty) {
        final loc = locations.first;
        final nameToSave = nickname.isEmpty ? juso.roadAddr : nickname;

        final newLocation = CustomLocation(
          id: const Uuid().v4(),
          name: nameToSave,
          lat: loc.latitude,
          lng: loc.longitude,
          isActive:
              true, // Auto-activate on add? User wanted "Select to change". Let's auto-activate for convenience.
        );

        // Add & Activate
        await ref.read(settingsProvider.notifier).addLocation(newLocation);
        // Ensure single activation logic if needed (provider toggle handles logic?)
        // Provider's `addLocation` just adds. `toggleLocationActive` handles exclusive active.
        // Let's manually toggle it active to be sure and deactivate others if that's the desired flow.
        await ref
            .read(settingsProvider.notifier)
            .toggleLocationActive(newLocation.id);

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Saved: $nameToSave")));
          // Optional: Go back or clear search?
          // User might want to manage list. So stay on screen but maybe clear search.
          setState(() {
            _searchController.clear();
            _searchResults = [];
          });
        }
      } else {
        throw Exception("Could not determine coordinates for this address.");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save: $e"),
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

    return Scaffold(
      backgroundColor: AppColors.background,
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
            // 1. Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textMediumEmphasis),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: AppColors.textHighEmphasis),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "주소를 검색하세요",
                        hintStyle: TextStyle(color: AppColors.textLowEmphasis),
                      ),
                      onSubmitted: (_) => _searchJuso(),
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
                        : Icon(Icons.send, color: AppColors.primary),
                    onPressed: _searchJuso,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // 2. Content Area (Search Results OR Saved List)
            Expanded(
              child:
                  _searchResults.isNotEmpty || _searchController.text.isNotEmpty
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
        child: Text(_errorMsg!, style: TextStyle(color: AppColors.error)),
      );
    }
    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      // User searched but no results
      return Center(
        child: Text(
          "저장된 위치가 없습니다.",
          style: TextStyle(color: AppColors.textMediumEmphasis),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final juso = _searchResults[index];
        return ListTile(
          onTap: () => _onLocationTap(juso),
          leading: Icon(
            Icons.location_on_outlined,
            color: AppColors.textMediumEmphasis,
          ),
          title: Text(
            juso.roadAddr,
            style: TextStyle(color: AppColors.textHighEmphasis),
          ),
          subtitle: Text(
            juso.jibunAddr,
            style: TextStyle(color: AppColors.textLowEmphasis),
          ),
        );
      },
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
              "Add your favorite places\nlike Home, Office, etc.",
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
                  color: AppColors.error,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref.read(settingsProvider.notifier).removeLocation(loc.id);
                },
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleLocationActive(loc.id);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: loc.isActive
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
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
                                      : AppColors.textHighEmphasis,
                                ),
                              ),
                              if (loc.name != "Seoul" &&
                                  loc.name !=
                                      "Current Location") // Simple check
                                Text(
                                  "${loc.lat.toStringAsFixed(4)}, ${loc.lng.toStringAsFixed(4)}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textMediumEmphasis,
                                  ),
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
