import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.primary.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 50,
                backgroundColor: colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.welcome,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.username}: ${AuthProvider.username ?? "N/A"}',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                child: ListTile(
                  leading: Icon(Icons.settings, color: colorScheme.primary),
                  title: Text(l10n.settings),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.language, color: colorScheme.primary),
                  title: Text(l10n.language),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: colorScheme.primary,
                      );
                    },
                  ),
                  title: Text(l10n.theme),
                  subtitle: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Text(
                        themeProvider.isDarkMode ? l10n.darkMode : l10n.lightMode,
                      );
                    },
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    print('Theme toggle pressed!');
                    try {
                      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                      print('ThemeProvider found!');
                      print('Current theme mode: ${themeProvider.themeMode}');
                      print('Is dark mode: ${themeProvider.isDarkMode}');
                      themeProvider.toggleTheme();
                      print('Theme toggled! New mode: ${themeProvider.isDarkMode}');
                    } catch (e) {
                      print('Error accessing ThemeProvider: $e');
                    }
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.help, color: colorScheme.primary),
                  title: Text(l10n.helpSupport),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.info, color: colorScheme.primary),
                  title: Text(l10n.about),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to about
                  },
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: Text(l10n.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.language, color: Color(0xFF4F8593), size: 24),
              const SizedBox(width: 12),
              Text(l10n.language),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇺'),
                title: Text(l10n.english),
                onTap: () {
                  _changeLanguage(context, const Locale('en'));
                },
              ),
              ListTile(
                leading: const Text('🇧'),
                title: Text(l10n.bosnian),
                onTap: () {
                  _changeLanguage(context, const Locale('bs'));
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    Navigator.of(context).pop();
    
    // Change language using Provider
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.changeLanguage(locale);
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Text(l10n.logout),
            ],
          ),
          content: Text(l10n.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                AuthProvider.username = null;
                AuthProvider.password = null;
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }
} 