import 'package:flutter/material.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildProfileSection(l10n, colorScheme),
              const SizedBox(height: 32),
              _buildMovieListsSection(l10n, colorScheme),
              const SizedBox(height: 32),
              _buildSettingsSection(context, l10n, colorScheme),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.surfaceVariant,
              child: Icon(
                Icons.person,
                size: 40,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 14,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AuthProvider.fullName ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              if (AuthProvider.email != null) ...[
                Text(
                  AuthProvider.email!,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMovieListsSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.myMovieLists,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildMovieListCard(
          icon: Icons.schedule,
          title: l10n.watchlist,
          subtitle: '12 ${l10n.movies}',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 12),
        _buildMovieListCard(
          icon: Icons.check_circle,
          title: l10n.watchedMovies,
          subtitle: '28 ${l10n.movies}',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 12),
        _buildMovieListCard(
          icon: Icons.favorite,
          title: l10n.favorites,
          subtitle: '8 ${l10n.movies}',
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildMovieListCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: colorScheme.onSurface.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settings,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          icon: Icons.confirmation_number,
          title: l10n.myReservations,
          subtitle: l10n.reservationsDescription,
          colorScheme: colorScheme,
          onTap: () {
            // TODO: Navigate to reservations
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.edit,
          title: l10n.editProfile,
          subtitle: l10n.editProfileDescription,
          colorScheme: colorScheme,
          onTap: () {
            // TODO: Navigate to edit profile
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.payment,
          title: l10n.paymentMethods,
          subtitle: l10n.paymentMethodsDescription,
          colorScheme: colorScheme,
          onTap: () {
            // TODO: Navigate to payment methods
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.language,
          title: l10n.language,
          subtitle: l10n.languageDescription,
          colorScheme: colorScheme,
          onTap: () {
            _showLanguageDialog(context);
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.dark_mode,
          title: l10n.theme,
          subtitle: l10n.themeDescription,
          colorScheme: colorScheme,
          onTap: () {
            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
            themeProvider.toggleTheme();
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.logout,
          title: l10n.logout,
          subtitle: l10n.logoutDescription,
          colorScheme: colorScheme,
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onSurface.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.language),
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
        _changeLanguage(context, Locale(languageCode));
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
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).colorScheme.onSurface,
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

  void _changeLanguage(BuildContext context, Locale locale) {
    Navigator.of(context).pop();
    
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
                _performLogout(context);
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

  void _performLogout(BuildContext context) {
    Navigator.of(context).pop();
    
    AuthProvider.logout();
    
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }
} 