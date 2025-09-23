import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/screening.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/screening_provider.dart';
import 'package:ecinema_desktop/screens/edit_screening_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import 'dart:async';

class ScreeningsListScreen extends StatefulWidget {
  const ScreeningsListScreen({super.key});

  @override
  State<ScreeningsListScreen> createState() => _ScreeningsListScreenState();
}

class _ScreeningsListScreenState extends State<ScreeningsListScreen> {
  late ScreeningProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<ScreeningProvider>();
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromStartTimeController.text = now.toIso8601String();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScreenings();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _movieTitleController.dispose();
    _hallNameController.dispose();
    _screeningFormatNameController.dispose();
    _languageController.dispose();
    _minBasePriceController.dispose();
    _maxBasePriceController.dispose();
    _fromStartTimeController.dispose();
    _toStartTimeController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isEmpty) {
        _loadScreenings();
      } else {
        _searchScreenings(resetPage: true);
      }
    });
  }

  SearchResult<Screening>? result = null;
  int currentPage = 0;
  int pageSize = 12;
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _movieTitleController = TextEditingController();
  final TextEditingController _hallNameController = TextEditingController();
  final TextEditingController _screeningFormatNameController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _minBasePriceController = TextEditingController();
  final TextEditingController _maxBasePriceController = TextEditingController();
  final TextEditingController _fromStartTimeController = TextEditingController();
  final TextEditingController _toStartTimeController = TextEditingController();
  bool hasAvailableSeats = false;
  bool includeDeleted = false;
  
  Timer? _debounceTimer;

  Future<void> _loadScreenings() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      var filter = <String, dynamic>{
        'page': currentPage,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'includeDeleted': includeDeleted,
        'fromStartTime': _fromStartTimeController.text.isNotEmpty 
            ? _fromStartTimeController.text 
            : DateTime.now().toIso8601String(),
      };
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading screenings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _searchScreenings({bool resetPage = false}) async {
    try {
      setState(() {
        isLoading = true;
      });
      
      if (resetPage) {
        currentPage = 0;
      }
      
      var filter = <String, dynamic>{
        'page': currentPage,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'includeDeleted': includeDeleted,
      };
      
      if (_searchController.text.isNotEmpty) {
        filter["fts"] = _searchController.text;
      }
      if (_movieTitleController.text.isNotEmpty) {
        filter["movieTitle"] = _movieTitleController.text;
      }
      if (_hallNameController.text.isNotEmpty) {
        filter["hallName"] = _hallNameController.text;
      }
      if (_screeningFormatNameController.text.isNotEmpty) {
        filter["screeningFormatName"] = _screeningFormatNameController.text;
      }
      if (_languageController.text.isNotEmpty) {
        filter["language"] = _languageController.text;
      }
      if (_minBasePriceController.text.isNotEmpty) {
        filter["minBasePrice"] = double.tryParse(_minBasePriceController.text);
      }
      if (_maxBasePriceController.text.isNotEmpty) {
        filter["maxBasePrice"] = double.tryParse(_maxBasePriceController.text);
      }
      if (_fromStartTimeController.text.isNotEmpty) {
        try {
          final date = DateTime.parse(_fromStartTimeController.text);
          filter["fromStartTime"] = date.toIso8601String();
        } catch (e) {
          print('Invalid fromStartTime format: ${_fromStartTimeController.text}');
        }
      }
      if (_toStartTimeController.text.isNotEmpty) {
        try {
          final date = DateTime.parse(_toStartTimeController.text);
          filter["toStartTime"] = date.toIso8601String();
        } catch (e) {
          print('Invalid toStartTime format: ${_toStartTimeController.text}');
        }
      }
      
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
        currentPage = 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching screenings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToNextPage() {
    if (result != null && result!.items != null && result!.totalCount != null && 
        result!.totalCount! > (currentPage + 1) * pageSize) {
      setState(() {
        currentPage++;
      });
      _hasActiveFilters() ? _searchScreenings() : _loadScreenings();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _hasActiveFilters() ? _searchScreenings() : _loadScreenings();
    }
  }

  void _resetPagination() {
    setState(() {
      currentPage = 0;
    });
    _hasActiveFilters() ? _searchScreenings() : _loadScreenings();
  }

  bool _hasActiveFilters() {
    return _searchController.text.isNotEmpty ||
           _movieTitleController.text.isNotEmpty ||
           _hallNameController.text.isNotEmpty ||
           _screeningFormatNameController.text.isNotEmpty ||
           _languageController.text.isNotEmpty ||
           _minBasePriceController.text.isNotEmpty ||
           _maxBasePriceController.text.isNotEmpty ||
           _fromStartTimeController.text.isNotEmpty ||
           _toStartTimeController.text.isNotEmpty ||
           hasAvailableSeats;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(l10n.screenings,
      Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
        child: Column(
          children: [
            _buildSearch(),
            _BuildResultView()
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = Theme.of(context).colorScheme.primary;
    OutlineInputBorder roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
    );

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField( 
              controller: _searchController,
              onSubmitted: (_) async {
                await _searchScreenings(resetPage: true);
              },
              decoration: InputDecoration(
                labelText: l10n.search,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2.5),
                ),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              await _searchScreenings();
            },
            icon: const Icon(Icons.search, size: 18),
            label: Text(l10n.search),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              final now = DateTime.now();
              _fromStartTimeController.text = now.toIso8601String();
              showDialog(
                context: context,
                builder: (context) {
                  bool localIncludeDeleted = includeDeleted;
                  bool localHasAvailableSeats = hasAvailableSeats;
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 80),
                      content: SizedBox(
                        width: 440,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _movieTitleController,
                                decoration: InputDecoration(
                                  labelText: l10n.movieTitle,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _hallNameController,
                                decoration: InputDecoration(
                                  labelText: l10n.hallName,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _screeningFormatNameController,
                                decoration: InputDecoration(
                                  labelText: l10n.screeningFormatName,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _languageController,
                                decoration: InputDecoration(
                                  labelText: l10n.language,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _minBasePriceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: l10n.minBasePrice,
                                        border: roundedBorder,
                                        enabledBorder: roundedBorder,
                                        focusedBorder: roundedBorder,
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _maxBasePriceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: l10n.maxBasePrice,
                                        border: roundedBorder,
                                        enabledBorder: roundedBorder,
                                        focusedBorder: roundedBorder,
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _fromStartTimeController,
                                readOnly: true,
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    final dateTime = DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
                                    _fromStartTimeController.text = dateTime.toIso8601String();
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: l10n.fromStartTime,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                  suffixIcon: _fromStartTimeController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            _fromStartTimeController.clear();
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                          ),
                                        )
                                      : Icon(
                                          Icons.calendar_today,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _toStartTimeController,
                                readOnly: true,
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    final dateTime = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
                                    _toStartTimeController.text = dateTime.toIso8601String();
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: l10n.toStartTime,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                  suffixIcon: _toStartTimeController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            _fromStartTimeController.clear();
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                          ),
                                        )
                                      : Icon(
                                          Icons.calendar_today,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    l10n.hasAvailableSeats,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: localHasAvailableSeats,
                                    onChanged: (val) {
                                      setState(() => localHasAvailableSeats = val);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    l10n.includeDeleted,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: localIncludeDeleted,
                                    onChanged: (val) {
                                      setState(() => localIncludeDeleted = val);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            _searchController.clear();
                            _movieTitleController.clear();
                            _hallNameController.clear();
                            _screeningFormatNameController.clear();
                            _languageController.clear();
                            _minBasePriceController.clear();
                            _maxBasePriceController.clear();
                            _fromStartTimeController.clear();
                            _toStartTimeController.clear();
                            setState(() {
                              localHasAvailableSeats = false;
                              localIncludeDeleted = false;
                              hasAvailableSeats = false;
                              includeDeleted = false;
                            });
                            await _searchScreenings(resetPage: true);
                          },
                          child: Text(l10n.reset),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.close),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                           hasAvailableSeats = localHasAvailableSeats;
                           includeDeleted = localIncludeDeleted;
                            await _searchScreenings(resetPage: true);
                            Navigator.pop(context);
                          },
                          child: Text(l10n.apply),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt_outlined),
            label: Text(l10n.filters),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreeningScreen(),
                ),
              );
              
              if (result == true) {
                _resetPagination();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.addScreening),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
      ],
    );
  }

  Widget _BuildResultView(){
    final l10n = AppLocalizations.of(context)!;
    
    if (isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.loadingScreenings,
                style: TextStyle(
                  fontSize: 18, 
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result == null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_outlined, 
                size: 64, 
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noScreeningsLoaded,
                style: TextStyle(
                  fontSize: 18, 
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result!.items != null && result!.items!.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_outlined, 
                size: 64, 
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noScreeningsFound,
                style: TextStyle(
                  fontSize: 18, 
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.tryAdjustingSearch,
                style: TextStyle(
                  fontSize: 14, 
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 5),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 4;
                  double childAspectRatio = 0.8;

                  if (constraints.maxWidth < 1000) {
                    crossAxisCount = 3;
                    childAspectRatio = 0.85;
                  }
                  if (constraints.maxWidth < 750) {
                    crossAxisCount = 2;
                    childAspectRatio = 0.9;
                  }
                  if (constraints.maxWidth < 500) {
                    crossAxisCount = 1;
                    childAspectRatio = 1.0;
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: result!.items != null ? result!.items!.length : 0,
                    itemBuilder: (context, index) {
                      final screening = result!.items != null ? result!.items![index] : null;
                      if (screening == null) return const SizedBox.shrink();
                      return _buildScreeningCard(screening);
                    },
                  );
                },
              ),
            ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

   Widget _buildPaginationControls() {
    final l10n = AppLocalizations.of(context)!;
    
    if (result == null) return const SizedBox.shrink();
    
    final totalCount = result!.totalCount ?? 0;
    final currentItems = result!.items != null ? result!.items!.length : 0;
    final hasNextPage = totalCount > (currentPage + 1) * pageSize; 
    final hasPreviousPage = currentPage > 0;
    final totalPages = (totalCount / pageSize).ceil();
    
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: hasPreviousPage 
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasPreviousPage ? _goToPreviousPage : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 14,
                        color: hasPreviousPage 
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        l10n.previous,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: hasPreviousPage 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${currentPage + 1} / $totalPages',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$currentItems ${l10n.ofText} $totalCount',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: hasNextPage 
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasNextPage ? _goToNextPage : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.next,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: hasNextPage 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: hasNextPage 
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreeningCard(Screening screening) {
    final l10n = AppLocalizations.of(context)!;
    
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditScreeningScreen(screening: screening),
          ),
        );
        
        if (result == true) {
          _resetPagination();
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: screening.movieImage != null && screening.movieImage!.isNotEmpty
                          ? Image.memory(
                              base64Decode(screening.movieImage!),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildFallbackImage();
                              },
                            )
                          : _buildFallbackImage(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: screening.isDeleted == true
                              ? Colors.grey.withOpacity(0.9)
                              : screening.isDeleted != true 
                                  ? Colors.green.withOpacity(0.9) 
                                  : Colors.red.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          screening.isDeleted == true 
                              ? l10n.deleted
                              : screening.isDeleted != true 
                                  ? l10n.active
                                  : l10n.inactive,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (screening.hasSubtitles == true)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            "CC",
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          screening.movieTitle ?? l10n.unknownMovie,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              flex: 7, // Increased from 6 to 7 to give more vertical space
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            screening.hallName ?? l10n.unknownHall,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (screening.startTime != null)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.blue[600],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "${screening.startTime!.day.toString().padLeft(2, '0')}/${screening.startTime!.month.toString().padLeft(2, '0')}/${screening.startTime!.year}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    if (screening.startTime != null && screening.endTime != null)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.orange[600],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "${screening.startTime!.hour.toString().padLeft(2, '0')}:${screening.startTime!.minute.toString().padLeft(2, '0')} - ${screening.endTime!.hour.toString().padLeft(2, '0')}:${screening.endTime!.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.language,
                            size: 14,
                            color: Colors.purple[600],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            screening.language ?? l10n.unknown,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.movie,
                            size: 14,
                            color: Colors.teal[600],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            screening.screeningFormatName ?? l10n.unknown,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  Icons.attach_money,
                                  size: 12,
                                  color: Colors.green[600],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                screening.basePrice?.toStringAsFixed(2) ?? "N/A",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  Icons.event_seat,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${screening.availableSeats ?? 0}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditScreeningScreen(screening: screening),
                              ),
                            );
                            
                            if (result == true) {
                              _resetPagination();
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (screening.isDeleted == true)
                          InkWell(
                            onTap: () {
                              _showRestoreConfirmationDialog(screening);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.restore,
                                size: 16,
                                color: Colors.green[600],
                              ),
                            ),
                          )
                        else
                          InkWell(
                            onTap: () {
                              _showDeleteConfirmationDialog(screening);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    // final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.event_seat,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Screening screening) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeletion),
        content: Text(l10n.confirmDeleteScreeningMessage(screening.movieTitle ?? l10n.unknownMovie)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteScreening(screening);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteScreening(Screening screening) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (screening.id == null) return;
    
    try {
      await provider.softDelete(screening.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.screeningDeletedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      _resetPagination();
    } catch (e) {
      print('Error deleting screening: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToDeleteScreening),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRestoreConfirmationDialog(Screening screening) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmRestoration),
        content: Text(l10n.confirmRestoreScreeningMessage(screening.movieTitle ?? l10n.unknownMovie)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restoreScreening(screening);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.restore),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreScreening(Screening screening) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (screening.id == null) return;
    
    try {
      await provider.restore(screening.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.screeningRestoredSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      _resetPagination();
    } catch (e) {
      print('Error restoring screening: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToRestoreScreening),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
