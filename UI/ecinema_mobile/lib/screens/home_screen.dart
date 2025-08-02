import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'randomizer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              _buildSearchBar(l10n, colorScheme),
              const SizedBox(height: 16),
              _buildMovieSuggestionBanner(l10n, colorScheme),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_creation_rounded,
                        size: 100,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.welcomeToEcinema,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.successfullyLoggedIn,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.searchMovies,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 16,
          ),
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.primary,
            size: 20,
          ),
          suffixIcon: Icon(
            Icons.tune,
            color: colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
        ),
        onSubmitted: (value) {
          // Handle search submission
          print('Search submitted: $value');
        },
      ),
    );
  }

  Widget _buildMovieSuggestionBanner(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF4F8593)
                : colorScheme.primary,
            Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF4F8593).withOpacity(0.7)
                : colorScheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RandomizerScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.casino,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontKnowWhatToWatch,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.letUsSuggestMovie,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
