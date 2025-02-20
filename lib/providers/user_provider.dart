import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  void fetchUsers() {
    // Simulate fetching users from a database or API
    _users = [
      User(id: '1', name: 'John Doe', email: 'john@example.com', age: 25),
      User(id: '2', name: 'Jane Smith', email: 'jane@example.com', age: 30),
    ];
    notifyListeners(); // ✅ Updates UI
  }

  void addUser(User user) {
    _users.add(user);
    notifyListeners(); // ✅ Ensures UI updates when a new user is added
  }

  void updateUser(User updatedUser) {
    int index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners(); // ✅ Updates UI when a user is updated
    }
  }

  void deleteUser(String userId) {
    _users.removeWhere((user) => user.id == userId);
    notifyListeners(); // ✅ Ensures UI updates after deleting a user
  }
}
