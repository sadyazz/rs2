import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');
  bool _isInitialized = false;

  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      _currentLocale = Locale(languageCode);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _currentLocale = const Locale('en');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;
    
    _currentLocale = Locale(languageCode);
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }

  String getCurrentLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'bs':
        return 'Bosanski';
      case 'en':
      default:
        return 'English';
    }
  }

  String getCurrentLanguageCode() {
    return _currentLocale.languageCode;
  }
} 