class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
  });

  factory UserModel.fromFirebase(dynamic user) {
    return UserModel(
      uid: user?.uid,
      email: user?.email,
      displayName: user?.displayName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
    );
  }
} 