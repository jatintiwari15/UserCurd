import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'update_user_screen.dart';
import 'add_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  void _refreshUsers() {
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: userProvider.users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final user = userProvider.users[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user.email, style: TextStyle(color: Colors.grey[700])),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () async {
                              bool? isUpdated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateUserScreen(user: user)),
                              );
                              if (isUpdated == true) {
                                _refreshUsers();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              _deleteUserWithAnimation(userProvider, user.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isUserAdded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          );
          if (isUserAdded == true) {
            _refreshUsers();
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  void _deleteUserWithAnimation(UserProvider userProvider, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              userProvider.deleteUser(userId);
              _refreshUsers();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("User deleted successfully"),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
