import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com'; // Demo API

  // Login API - Now validates against locally stored users
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('registered_users') ?? [];
      
      // Check if user exists in local storage
      for (String userJson in usersJson) {
        Map<String, dynamic> userData = json.decode(userJson);
        if (userData['email'] == email && userData['password'] == password) {
          return {
            'success': true,
            'user': User(
              id: userData['id'],
              name: userData['name'],
              email: userData['email'],
            ),
            'message': 'Login successful',
          };
        }
      }
      
      // If not found in local storage, return error
      return {
        'success': false,
        'message': 'Invalid email or password',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Registration API - Stores user locally
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('registered_users') ?? [];
      
      // Check if email already exists
      for (String userJson in usersJson) {
        Map<String, dynamic> userData = json.decode(userJson);
        if (userData['email'] == email) {
          return {
            'success': false,
            'message': 'Email already registered',
          };
        }
      }
      
      // Create new user
      Map<String, dynamic> newUser = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'email': email,
        'password': password,
      };
      
      // Save to local storage
      usersJson.add(json.encode(newUser));
      await prefs.setStringList('registered_users', usersJson);
      
      return {
        'success': true,
        'message': 'Registration successful',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Get Users Data (Demo data show) - Now gets from local storage
  Future<List<User>> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('registered_users') ?? [];
      
      List<User> users = [];
      for (String userJson in usersJson) {
        Map<String, dynamic> userData = json.decode(userJson);
        users.add(User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
        ));
      }
      
      return users;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
