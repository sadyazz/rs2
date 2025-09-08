import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/review.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/review_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import '../providers/utils.dart';

class ReviewsScreen extends StatefulWidget {
  final Movie movie;

  const ReviewsScreen({super.key, required this.movie});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late ReviewProvider provider;
  SearchResult<Review>? result;
  bool isLoading = false;
  int currentPage = 0;
  int pageSize = 15;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<ReviewProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews();
    });
  }

  Future<void> _loadReviews() async {
    if (widget.movie.id == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      var filter = <String, dynamic>{
        'movieId': widget.movie.id,
        'includeDeleted': false,
        'page': currentPage,
        'pageSize': pageSize,
        'includeTotalCount': true,
      };

      result = await provider.get(filter: filter);
      setState(() {
        result = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MasterScreen(
      "${l10n.movieReviews} - ${widget.movie.title}",
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildStatisticsCards(),
            const SizedBox(height: 32),
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.rate_review,
                              size: 40,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.loadingReviews,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : result?.items?.isEmpty == true
                      ? _buildEmptyState()
                      : Column(
                          children: [
                            Expanded(child: _buildReviewsList()),
                            _buildPaginationControls(),
                          ],
                        ),
            ),
          ],
        ),
      ),
      showDrawer: false,
    );
  }

  Widget _buildStatisticsCards() {
    final l10n = AppLocalizations.of(context)!;
    final reviews = result?.items ?? [];
    final averageRating = reviews.isNotEmpty
        ? reviews.fold(0.0, (sum, review) => sum + review.rating) /
            reviews.length
        : 0.0;
    final positiveReviews =
        reviews.where((review) => review.rating >= 4).length;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            title: l10n.averageRating,
            value: averageRating.toStringAsFixed(1),
            subtitle: l10n.outOf5,
            color: Colors.amber,
            gradient: isDark
                ? [Colors.amber.shade700, Colors.amber.shade900]
                : [Colors.amber.shade400, Colors.amber.shade600],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            icon: Icons.rate_review,
            title: l10n.totalReviews,
            value: reviews.length.toString(),
            subtitle: l10n.reviews,
            color: Theme.of(context).colorScheme.primary,
            gradient: isDark
                ? [
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    Theme.of(context).colorScheme.primary.withOpacity(0.6)
                  ]
                : [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8)
                  ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            icon: Icons.thumb_up,
            title: l10n.positiveReviews,
            value: positiveReviews.toString(),
            subtitle: l10n.stars4Plus,
            color: Colors.green,
            gradient: isDark
                ? [Colors.green.shade700, Colors.green.shade900]
                : [Colors.green.shade400, Colors.green.shade600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.noReviewsYet,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noReviewsMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      itemCount: result?.items?.length ?? 0,
      itemBuilder: (context, index) {
        final review = result!.items![index];
        return _buildReviewCard(review);
      },
    );
  }

  Widget _buildReviewCard(Review review) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
             CircleAvatar(
  radius: 20,
  backgroundColor: review.userImage != null
      ? Colors.transparent
      : Theme.of(context).colorScheme.primary,
  backgroundImage: review.userImage != null
      ? imageProviderFromString(review.userImage!)
      : null,
  child: review.userImage == null
      ? Text(
          review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        )
      : null,
),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.userName.isNotEmpty
                                ? review.userName
                                : l10n.unknownUser,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (review.isSpoiler)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red[600],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.spoiler,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        _formatDate(review.createdAt) +
                            ((review.isEdited ?? false)
                                ? ' ${l10n.edited}'
                                : ''),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      '${review.rating}/5',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (review.comment != null && review.comment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      review.comment!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _toggleSpoilerStatus(review),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: review.isSpoiler 
                            ? Colors.red.withOpacity(0.1)
                            : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: review.isSpoiler 
                              ? Colors.red.withOpacity(0.2)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        review.isSpoiler ? Icons.visibility : Icons.visibility_off,
                        size: 16,
                        color: review.isSpoiler ? Colors.red[600] : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _deleteReview(review),
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
            ] else ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _toggleSpoilerStatus(review),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: review.isSpoiler 
                            ? Colors.red.withOpacity(0.1)
                            : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: review.isSpoiler 
                              ? Colors.red.withOpacity(0.2)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        review.isSpoiler ? Icons.visibility : Icons.visibility_off,
                        size: 16,
                        color: review.isSpoiler ? Colors.red[600] : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _deleteReview(review),
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
          ],
        ),
      ),
    );
  }

  Future<void> _toggleSpoilerStatus(Review review) async {
    if (review.id == null) return;
    try {
      final success = await provider.toggleSpoilerStatus(review.id!);

      if (success) {
        await _loadReviews();
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(review.isSpoiler
                ? l10n.reviewUnmarkedAsSpoiler
                : l10n.reviewMarkedAsSpoiler),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error toggling spoiler status: $e');
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToUpdateReview),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _deleteReview(Review review) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteReview),
          content: Text(l10n.deleteReviewConfirmation(review.userName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await provider.softDelete(review.id!);
                  _resetPagination();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.reviewDeletedSuccessfully),
                      backgroundColor: Colors.green[700],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorDeletingReview(e.toString())),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  void _goToNextPage() {
    if (result != null && result!.items!.length == pageSize) {
      setState(() {
        currentPage++;
      });
      _loadReviews();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _loadReviews();
    }
  }

  void _resetPagination() {
    setState(() {
      currentPage = 0;
    });
    _loadReviews();
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        "${l10n.previous}",
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
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

class _ReviewDialog extends StatefulWidget {
  final String title;

  final Function(String, double, String) onSave;

  const _ReviewDialog({
    required this.title,
    required this.onSave,
  });

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  late TextEditingController userNameController;
  late TextEditingController commentController;
  late double rating;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: '');
    commentController = TextEditingController(text: '');
    rating = 3.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Rating: '),
                Expanded(
                  child: Slider(
                    value: rating,
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    onChanged: (value) => setState(() => rating = value),
                  ),
                ),
                Text(rating.toInt().toString()),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (userNameController.text.isNotEmpty &&
                commentController.text.isNotEmpty) {
              widget.onSave(
                  userNameController.text, rating, commentController.text);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    commentController.dispose();
    super.dispose();
  }
}
