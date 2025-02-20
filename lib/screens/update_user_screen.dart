import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UpdateUserScreen extends StatefulWidget {
  final User user;

  const UpdateUserScreen({super.key, required this.user});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Prevent overflow issue
      appBar: AppBar(
        title: const Text("Update User"),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: SingleChildScrollView( // ✅ Makes content scrollable
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircleAvatar without Hero to avoid conflicts
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueAccent,
              child: Text(
                widget.user.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField(nameController, "Name", Icons.person),
            const SizedBox(height: 10),
            _buildTextField(emailController, "Email", Icons.email),
            const SizedBox(height: 10),
            _buildTextField(ageController, "Age", Icons.calendar_today, isNumber: true),
            const SizedBox(height: 20),

            // Animated Update Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  _updateUser(userProvider);
                },
                child: const Text("Update User", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20), // ✅ Prevents overflow by adding extra space
          ],
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Update User Logic
  void _updateUser(UserProvider userProvider) {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        ageController.text.isEmpty) {
      _showSnackBar("All fields are required", Colors.redAccent);
      return;
    }

    int? age = int.tryParse(ageController.text);
    if (age == null) {
      _showSnackBar("Age must be a number", Colors.redAccent);
      return;
    }

    final updatedUser = User(
      id: widget.user.id,
      name: nameController.text,
      email: emailController.text,
      age: age,
    );

    userProvider.updateUser(updatedUser);
    _showSnackBar("User updated successfully!", Colors.green);
    Navigator.pop(context, true);
  }

  // Snackbar Notification
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
