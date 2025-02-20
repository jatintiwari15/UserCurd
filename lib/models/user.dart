class User {
  String id;
  String name;
  String email;
  int age;

  User({required this.id, required this.name, required this.email, required this.age});

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "age": age,
    };
  }
}
