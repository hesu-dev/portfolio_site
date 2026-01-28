import 'package:flutter_riverpod/legacy.dart';
import '../domain/models/avatar_config.dart';

class AvatarNotifier extends StateNotifier<AvatarConfig> {
  AvatarNotifier() : super(AvatarConfig());

  void updateSkinColor(int index) {
    state = state.copyWith(skinColorIndex: index);
  }

  void updateHairStyle(int index) {
    state = state.copyWith(hairStyleIndex: index);
  }

  void updateHairColor(int index) {
    state = state.copyWith(hairColorIndex: index);
  }

  void updateFaceStyle(int index) {
    state = state.copyWith(faceStyleIndex: index);
  }

  void updateOutfit(int index) {
    state = state.copyWith(outfitIndex: index);
  }

  void updateAccessory(int index) {
    state = state.copyWith(accessoryIndex: index);
  }

  void updateHairBack(int index) {
    state = state.copyWith(hairBackIndex: index);
  }
}

final avatarProvider = StateNotifierProvider<AvatarNotifier, AvatarConfig>((
  ref,
) {
  return AvatarNotifier();
});
