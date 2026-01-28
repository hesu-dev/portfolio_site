
class AvatarConfig {
  final int skinColorIndex;
  final int hairStyleIndex;
  final int hairColorIndex;
  final int faceStyleIndex;
  final int outfitIndex;
  final int accessoryIndex;
  final int hairBackIndex; // New field for independent back hair

  AvatarConfig({
    this.skinColorIndex = 0,
    this.hairStyleIndex = 0,
    this.hairColorIndex = 0,
    this.faceStyleIndex = 0,
    this.outfitIndex = 0,
    this.accessoryIndex = 0,
    this.hairBackIndex = 0,
  });

  AvatarConfig copyWith({
    int? skinColorIndex,
    int? hairStyleIndex,
    int? hairColorIndex,
    int? faceStyleIndex,
    int? outfitIndex,
    int? accessoryIndex,
    int? hairBackIndex,
  }) {
    return AvatarConfig(
      skinColorIndex: skinColorIndex ?? this.skinColorIndex,
      hairStyleIndex: hairStyleIndex ?? this.hairStyleIndex,
      hairColorIndex: hairColorIndex ?? this.hairColorIndex,
      faceStyleIndex: faceStyleIndex ?? this.faceStyleIndex,
      outfitIndex: outfitIndex ?? this.outfitIndex,
      accessoryIndex: accessoryIndex ?? this.accessoryIndex,
      hairBackIndex: hairBackIndex ?? this.hairBackIndex,
    );
  }
}
