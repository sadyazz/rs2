import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/home_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import 'package:ecinema_mobile/providers/language_provider.dart';
import 'package:provider/provider.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {
    super.key,
    this.showAppBar = true,
    this.showBackButton = false,
    this.transparentAppBar = false,
    this.showBottomNav = true,
    this.floatingActionButton,
  });

  final String? title;
  final Widget? child;
  final bool showAppBar;
  final bool showBackButton;
  final bool transparentAppBar;
  final bool showBottomNav;
  final Widget? floatingActionButton;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    // const TicketsScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    
    if (l10n == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      if (!languageProvider.isInitialized) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    } catch (e) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final List<String> _titles = [
      'eCinema',
      l10n.notifications,
      l10n.profile,
    ];
    
    return Scaffold(
      appBar: widget.showAppBar
    ? PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: widget.transparentAppBar && !widget.showBackButton
              ? const SizedBox.shrink()
              : Text(
                  widget.title ?? _titles[_currentIndex],
                  style: TextStyle(
                    color: widget.transparentAppBar
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
          backgroundColor: widget.transparentAppBar ? Colors.transparent : colorScheme.surface,
          elevation: widget.transparentAppBar ? 0 : 4,
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: widget.showBackButton
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                                      color: widget.transparentAppBar
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
        ),
      )
    : null,

      body: widget.child ?? IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
       extendBody: true,
      bottomNavigationBar: widget.showBottomNav ? ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  child: Container(
    height: 80,
    decoration: BoxDecoration(
      color: colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavItem(0, Icons.home_outlined, Icons.home, colorScheme),
        _buildNavItem(1, Icons.notifications_outlined, Icons.notifications, colorScheme),
        _buildNavItem(2, Icons.person_outline, Icons.person, colorScheme),
      ],
    ),
  ),
) : null,

      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, ColorScheme colorScheme) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 80,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6),
          size: 28,
        ),
      ),
    );
  }
} 