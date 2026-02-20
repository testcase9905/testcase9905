import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  Future<void> handleRegister() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await apiService.register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),

            // Icon
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person_add,
                size: 50,
                color: Colors.blue,
              ),
            ),

            SizedBox(height: 30),

            // Registration Form
            CustomTextField(
              controller: nameController,
              label: 'Full Name',
              icon: Icons.person,
            ),

            CustomTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),

            CustomTextField(
              controller: passwordController,
              label: 'Password',
              icon: Icons.lock,
              isPassword: !isPasswordVisible,
            ),

            CustomTextField(
              controller: confirmPasswordController,
              label: 'Confirm Password',
              icon: Icons.lock,
              isPassword: !isConfirmPasswordVisible,
            ),

            SizedBox(height: 30),

            // Register Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: isLoading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Register',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            SizedBox(height: 20),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
