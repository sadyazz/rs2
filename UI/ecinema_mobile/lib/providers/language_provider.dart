import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecinema_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/l10n.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');
  bool _isInitialized = false;

  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;

  LanguageProvider() {
    _isInitialized = true;
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      _currentLocale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      _currentLocale = const Locale('en');
      notifyListeners();
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (_currentLocale.languageCode == newLocale.languageCode) return;
    
    _currentLocale = newLocale;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, newLocale.languageCode);
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

  List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  List<Locale> get supportedLocales => L10n.all;
} 
