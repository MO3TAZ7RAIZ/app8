import 'package:fluttertoast/fluttertoast.dart';
import 'database_helper.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<bool> signUp(Map<String, dynamic> userData) async {
    try {
      final existingUser = await _dbHelper.getUser(userData['username']);
      if (existingUser != null) {
        Fluttertoast.showToast(msg: 'Username already exists');
        return false;
      }

      await _dbHelper.insertUser(userData);
      Fluttertoast.showToast(msg: 'Registration successful!');
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error during sign up: $e');
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = await _dbHelper.getUser(username);
      if (user == null) {
        Fluttertoast.showToast(msg: 'User not found');
        return false;
      }

      if (user['password'] != password) {
        Fluttertoast.showToast(msg: 'Incorrect password');
        return false;
      }

      Fluttertoast.showToast(msg: 'Login successful!');
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error during login: $e');
      return false;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> userData) async {
    try {
      final rowsAffected = await _dbHelper.updateUser(userData);
      if (rowsAffected > 0) {
        Fluttertoast.showToast(msg: 'Profile updated successfully!');
        return true;
      } else {
        Fluttertoast.showToast(msg: 'No changes made to profile');
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error updating profile: $e');
      return false;
    }
  }
}