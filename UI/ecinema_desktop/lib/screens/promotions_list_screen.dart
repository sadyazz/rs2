import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/promotion.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/promotion_provider.dart';
import 'package:ecinema_desktop/screens/edit_promotion_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';

class PromotionsListScreen extends StatefulWidget {
  const PromotionsListScreen({super.key});

  @override
  State<PromotionsListScreen> createState() => _PromotionsListScreenState();
}

class _PromotionsListScreenState extends State<PromotionsListScreen> {
  late PromotionProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<PromotionProvider>();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPromotions();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isEmpty) {
        _loadPromotions();
      } else {
        _searchPromotions();
      }
    });
  }

  SearchResult<Promotion>? result;
  int currentPage = 0;
  int pageSize = 18;
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  bool includeDeleted = false;
  DateTime? fromStartDate;
  DateTime? toStartDate;
  DateTime? fromEndDate;
  DateTime? toEndDate;
  double? minDiscount;
  double? maxDiscount;
  
  Timer? _debounceTimer;

  Future<void> _loadPromotions() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      var filter = <String, dynamic>{
        'page': currentPage,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'includeDeleted': includeDeleted,
      };
      
      if (fromStartDate != null) {
        filter['fromStartDate'] = fromStartDate!.toIso8601String();
      }
      
      if (toStartDate != null) {
        filter['toStartDate'] = toStartDate!.toIso8601String();
      }
      
      if (fromEndDate != null) {
        filter['fromEndDate'] = fromEndDate!.toIso8601String();
      }
      
      if (toEndDate != null) {
        filter['toEndDate'] = toEndDate!.toIso8601String();
      }
      
      if (minDiscount != null) {
        filter['minDiscount'] = minDiscount;
      }
      
      if (maxDiscount != null) {
        filter['maxDiscount'] = maxDiscount;
      }
      
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading promotions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _searchPromotions() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      var filter = <String, dynamic>{
        'page': 0,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'includeDeleted': includeDeleted,
      };
      
      if (_searchController.text.isNotEmpty) {
        filter["name"] = _searchController.text;
      }
      
      if (fromStartDate != null) {
        filter['fromStartDate'] = fromStartDate!.toIso8601String();
      }
      
      if (toStartDate != null) {
        filter['toStartDate'] = toStartDate!.toIso8601String();
      }
      
      if (fromEndDate != null) {
        filter['fromEndDate'] = fromEndDate!.toIso8601String();
      }
      
      if (toEndDate != null) {
        filter['toEndDate'] = toEndDate!.toIso8601String();
      }
      
      if (minDiscount != null) {
        filter['minDiscount'] = minDiscount;
      }
      
      if (maxDiscount != null) {
        filter['maxDiscount'] = maxDiscount;
      }
      
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
        currentPage = 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching promotions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToNextPage() {
    if (result != null && result!.items!.length == pageSize) {
      setState(() {
        currentPage++;
      });
      _loadPromotions();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _loadPromotions();
    }
  }

  void _resetPagination() {
    setState(() {
      currentPage = 0;
      fromStartDate = null;
      toStartDate = null;
      fromEndDate = null;
      toEndDate = null;
      minDiscount = null;
      maxDiscount = null;
    });
    _loadPromotions();
  }

  void _deletePromotion(Promotion promotion) async {
    final l10n = AppLocalizations.of(context)!;
    final promotionName = promotion.name;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deletePromotion),
        content: Text(l10n.confirmDeletePromotion(promotionName ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.close),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.softDelete(promotion.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.promotionDeletedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        _resetPagination();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToDeletePromotion),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _restorePromotion(Promotion promotion) async {
    final l10n = AppLocalizations.of(context)!;
    final promotionName = promotion.name;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restorePromotion),
        content: Text(l10n.confirmRestorePromotion(promotionName ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.close),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.restore),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.restore(promotion.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.promotionRestoredSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        _resetPagination();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToRestorePromotion),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(l10n.promotions,
      Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
        child: Column(
          children: [
            _buildSearch(),
            _buildResultView()
          ],
        ),
      ),
      showDrawer: false,
    );
  }

  Widget _buildSearch() {
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField( 
              controller: _searchController,
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
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              await _searchPromotions();
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  bool localIncludeDeleted = includeDeleted;
                  DateTime? localFromStartDate = fromStartDate;
                  DateTime? localToStartDate = toStartDate;
                  DateTime? localFromEndDate = fromEndDate;
                  DateTime? localToEndDate = toEndDate;
                  double? localMinDiscount = minDiscount;
                  double? localMaxDiscount = maxDiscount;
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 80),
                      content: SizedBox(
                        width: 400,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: FormBuilderDateTimePicker(
                                    name: 'fromStartDate',
                                    decoration: InputDecoration(
                                      labelText: l10n.fromStartDate,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.calendar_today),
                                    ),
                                    inputType: InputType.date,
                                    initialValue: localFromStartDate,
                                    onChanged: (value) {
                                      setState(() => localFromStartDate = value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: FormBuilderDateTimePicker(
                                    name: 'toStartDate',
                                    decoration: InputDecoration(
                                      labelText: l10n.toStartDate,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.calendar_today),
                                    ),
                                    inputType: InputType.date,
                                    initialValue: localToStartDate,
                                    onChanged: (value) {
                                      setState(() => localToStartDate = value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: FormBuilderDateTimePicker(
                                    name: 'fromEndDate',
                                    decoration: InputDecoration(
                                      labelText: l10n.fromEndDate,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.calendar_today),
                                    ),
                                    inputType: InputType.date,
                                    initialValue: localFromEndDate,
                                    onChanged: (value) {
                                      setState(() => localFromEndDate = value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: FormBuilderDateTimePicker(
                                    name: 'toEndDate',
                                    decoration: InputDecoration(
                                      labelText: l10n.toEndDate,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.calendar_today),
                                    ),
                                    inputType: InputType.date,
                                    initialValue: localToEndDate,
                                    onChanged: (value) {
                                      setState(() => localToEndDate = value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Min Discount',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.percent),
                                      hintText: '0.0',
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    onChanged: (value) {
                                      setState(() {
                                        localMinDiscount = double.tryParse(value);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Max Discount',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.percent),
                                      hintText: '100.0',
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    onChanged: (value) {
                                      setState(() {
                                        localMaxDiscount = double.tryParse(value);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              localIncludeDeleted = false;
                              includeDeleted = false;
                              localFromStartDate = null;
                              fromStartDate = null;
                              localToStartDate = null;
                              toStartDate = null;
                              localFromEndDate = null;
                              fromEndDate = null;
                              localToEndDate = null;
                              toEndDate = null;
                              localMinDiscount = null;
                              minDiscount = null;
                              localMaxDiscount = null;
                              maxDiscount = null;
                            });
                          },
                          child: Text(l10n.reset),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.close),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              includeDeleted = localIncludeDeleted;
                              fromStartDate = localFromStartDate;
                              toStartDate = localToStartDate;
                              fromEndDate = localFromEndDate;
                              toEndDate = localToEndDate;
                              minDiscount = localMinDiscount;
                              maxDiscount = localMaxDiscount;
                            });
                            await _searchPromotions();
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
                  builder: (context) => const EditPromotionScreen(),
                ),
              );
              if (result == true) {
                _resetPagination();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.addPromotion),
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

  Widget _buildResultView() {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                l10n.loadingPromotions,
                style: TextStyle(fontSize: 18, color: Colors.grey),
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
              Icon(Icons.local_offer, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                l10n.noPromotionsLoaded,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result!.items!.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_offer, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                l10n.noPromotionsFound,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                l10n.tryAdjustingSearchCriteria,
                style: TextStyle(fontSize: 14, color: Colors.grey),
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: result!.items!.length,
                itemBuilder: (context, index) {
                  final promotion = result!.items![index];
                  return _buildPromotionCard(promotion);
                },
              ),
            ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(Promotion promotion) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPromotionScreen(promotion: promotion),
          ),
        );
        if (result == true) {
          _resetPagination();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.local_offer,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  if (promotion.isDeleted == true)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.deleted,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promotion.name ?? 'Untitled',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    if (promotion.code != null) ...[
                      Text(
                        'Code: ${promotion.code}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: promotion.isDeleted != true 
                                ? Colors.green[100] 
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            promotion.isDeleted != true ? l10n.active : l10n.inactive,
                            style: TextStyle(
                              color: promotion.isDeleted != true 
                                  ? Colors.green[700] 
                                  : Colors.red[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPromotionScreen(promotion: promotion),
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
                            if (promotion.isDeleted == true)
                              InkWell(
                                onTap: () {
                                  _restorePromotion(promotion);
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
                                  _deletePromotion(promotion);
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final l10n = AppLocalizations.of(context)!;
    if (result == null) return const SizedBox.shrink();
    
    final totalCount = result!.totalCount ?? 0;
    final currentItems = result!.items!.length;
    final hasNextPage = currentItems == pageSize;
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
                '$currentItems of $totalCount',
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
} 
