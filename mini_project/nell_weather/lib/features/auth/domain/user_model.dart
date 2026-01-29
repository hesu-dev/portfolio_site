class UserModel {
  final String id;
  final String email;
  final String nickname;
  final bool isSubscribed;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.isSubscribed = false,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      isSubscribed: json['isSubscribed'] as bool? ?? false,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'isSubscribed': isSubscribed,
      'profileImage': profileImage,
    };
  }
}
