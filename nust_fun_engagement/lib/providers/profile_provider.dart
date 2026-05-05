import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];
  bool _isLoading = false;
  String _error = '';

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchUserProfile(int userId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await ApiService.getUserById(userId);
      _currentUser = User.fromJson(data);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await ApiService.getUsers();
      _users = (data as List).map((item) => User.fromJson(item)).toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (_currentUser == null) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final updatedData = await ApiService.updateUserProfile(
        _currentUser!.id,
        updates,
      );
      _currentUser = User.fromJson(updatedData);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await ApiService.createUser(userData);
      final newUser = User.fromJson(data);
      _users.add(newUser);
      _currentUser = newUser;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
