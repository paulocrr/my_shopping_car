class User {
  final String id;
  final String? email;
  final String? name;
  final String? photoUrl;

  User({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['uid'],
        email: map['email'],
        name: map['name'],
        photoUrl: map['avatarUrl'],
      );

  Map<String, dynamic> toMap() => {
        'uid': id,
        'email': email,
        'name': name,
        'avatarUrl': photoUrl,
      };
}
