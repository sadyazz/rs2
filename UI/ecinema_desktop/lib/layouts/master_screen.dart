import 'package:ecinema_desktop/screens/dashboard_screen.dart';
import 'package:ecinema_desktop/screens/movies_list_screen.dart';
import 'package:ecinema_desktop/screens/screenings_list_screen.dart';
import 'package:ecinema_desktop/screens/settings_screen.dart';
import 'package:ecinema_desktop/providers/language_provider.dart';
import 'package:ecinema_desktop/providers/auth_provider.dart';
import 'package:ecinema_desktop/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/main.dart' show LoginPage;

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {super.key, this.showDrawer = true, this.floatingActionButton});

  String? title;
  Widget? child;
  bool showDrawer;
  Widget? floatingActionButton;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: widget.showDrawer 
          ? Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
      ),
      drawer: widget.showDrawer ? Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF4F8593),
                const Color(0xFF4F8593).withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildListTile(
                      icon: Icons.dashboard,
                      title: l10n.dashboard,
                    ),
                    _buildListTile(
                      icon: Icons.movie,
                      title: l10n.movies,
                    ),
                    _buildListTile(
                      icon: Icons.schedule,
                      title: l10n.screenings,
                    ),
                    _buildListTile(
                      icon: Icons.event_seat,
                      title: l10n.seatsHalls,
                    ),
                    _buildListTile(
                      icon: Icons.article,
                      title: l10n.news,
                    ),
                    _buildListTile(
                      icon: Icons.people,
                      title: l10n.users,
                    ),
                    _buildListTile(
                      icon: Icons.analytics,
                      title: l10n.reports,
                    ),
                    _buildListTile(
                      icon: Icons.settings,
                      title: l10n.settings,
                    ),
                  ],
                ),
              ),
              
              _buildLanguagePicker(l10n),
              
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => themeProvider.toggleTheme(),
                        child: ListTile(
                          title: Text(
                            'Theme',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          leading: Icon(
                            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: Colors.white.withOpacity(0.8),
                            size: 24,
                          ),
                          trailing: Icon(
                            Icons.swap_horiz,
                            color: Colors.white.withOpacity(0.8),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              Divider(
                color: Colors.white.withOpacity(0.3),
                height: 32,
              ),
              
              _buildListTile(
                icon: Icons.logout,
                title: l10n.logout,
                isLogout: true,
              ),
            ],
          ),
        ),
      ) : null,
      body: widget.child,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildLanguagePicker(AppLocalizations l10n) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _showLanguageDialog(context, languageProvider),
              child: ListTile(
                title: Text(
                  l10n.language,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  languageProvider.getCurrentLanguageName(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                leading: Icon(
                  Icons.language,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                languageProvider,
                'en',
                'English',
                '🇺🇸',
              ),
              const SizedBox(height: 8),
              _buildLanguageOption(
                context,
                languageProvider,
                'bs',
                'Bosanski',
                '🇧🇦',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider languageProvider,
    String languageCode,
    String languageName,
    String flag,
  ) {
    final isSelected = languageProvider.getCurrentLanguageCode() == languageCode;
    
    return InkWell(
      onTap: () {
        languageProvider.setLanguage(languageCode);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    bool isBackButton = false,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.pop(context);
            
            if (isBackButton) {
              Navigator.pop(context);
              return;
            }
            
            if (isLogout) {
              _showLogoutDialog();
              return;
            }
            
            final l10n = AppLocalizations.of(context)!;
            
            if (title == l10n.dashboard) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
            } else if (title == l10n.movies) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MoviesListScreen()));
            } else if (title == l10n.screenings) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScreeningsListScreen()));
            } else if (title == l10n.seatsHalls) {
            } else if (title == l10n.news) {
            } else if (title == l10n.users) {
            } else if (title == l10n.reports) {
            } else if (title == l10n.settings) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            }
          },
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: isBackButton ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: isBackButton ? 20 : 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red.shade600,
                size: 24,
              ),
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
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    AuthProvider.username = '';
    AuthProvider.password = '';
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}