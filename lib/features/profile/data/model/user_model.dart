class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String profilePicture;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
