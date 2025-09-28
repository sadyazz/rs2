import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bs'),
    Locale('en')
  ];

  /// Dashboard navigation item
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Movies navigation item
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// Screenings navigation item
  ///
  /// In en, this message translates to:
  /// **'Screenings'**
  String get screenings;

  /// Seats and halls navigation item
  ///
  /// In en, this message translates to:
  /// **'Seats & Halls'**
  String get seatsHalls;

  /// Seats label
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// News navigation item
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// Users management tile title
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// Reviews section title
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// Reports navigation item
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @downloadReport.
  ///
  /// In en, this message translates to:
  /// **'Download Report'**
  String get downloadReport;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @reservationCount.
  ///
  /// In en, this message translates to:
  /// **'Reservation Count'**
  String get reservationCount;

  /// No description provided for @occupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get occupancyRate;

  /// Reports page description
  ///
  /// In en, this message translates to:
  /// **'Track your cinema\'s performance with automatically generated reports to make informed business decisions.'**
  String get reportsDescription;

  /// Total tickets sold metric
  ///
  /// In en, this message translates to:
  /// **'Total Tickets Sold'**
  String get totalTicketsSold;

  /// Total revenue metric
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// Average occupancy metric
  ///
  /// In en, this message translates to:
  /// **'Average Occupancy'**
  String get averageOccupancy;

  /// Placeholder text for charts
  ///
  /// In en, this message translates to:
  /// **'Chart visualization coming soon'**
  String get chartComingSoon;

  /// Date range selector title
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// Daily date range option
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly date range option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly date range option
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Yearly date range option
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// Custom date range option
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// From date label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To date label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Ticket sales section title
  ///
  /// In en, this message translates to:
  /// **'Ticket Sales'**
  String get ticketSales;

  /// Total number of seats
  ///
  /// In en, this message translates to:
  /// **'Total seats'**
  String get totalSeats;

  /// Number of reserved seats
  ///
  /// In en, this message translates to:
  /// **'Reserved seats'**
  String get reservedSeats;

  /// Number of available seats
  ///
  /// In en, this message translates to:
  /// **'Available seats'**
  String get availableSeats;

  /// Average ticket price label
  ///
  /// In en, this message translates to:
  /// **'Average Ticket Price'**
  String get averageTicketPrice;

  /// Screening attendance section title
  ///
  /// In en, this message translates to:
  /// **'Screening Attendance'**
  String get screeningAttendance;

  /// Revenue by movie/hall section title
  ///
  /// In en, this message translates to:
  /// **'Revenue by Movie/Hall'**
  String get revenueByMovieHall;

  /// Filters button text
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// All movies filter option
  ///
  /// In en, this message translates to:
  /// **'All Movies'**
  String get allMovies;

  /// All halls filter option
  ///
  /// In en, this message translates to:
  /// **'All Halls'**
  String get allHalls;

  /// Settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Search button and placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Add movie button text
  ///
  /// In en, this message translates to:
  /// **'Add Movie'**
  String get addMovie;

  /// Movie management page title
  ///
  /// In en, this message translates to:
  /// **'Movie Management'**
  String get movieManagement;

  /// Movie management subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your movie catalog'**
  String get manageYourMovieCatalog;

  /// No movies found message
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get noMoviesFound;

  /// Message when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No movies match your search'**
  String get noMoviesMatchSearch;

  /// Section title for movies ready to release
  ///
  /// In en, this message translates to:
  /// **'Ready to Release'**
  String get readyToRelease;

  /// Tag for movies releasing today
  ///
  /// In en, this message translates to:
  /// **'Releases Today'**
  String get releasesToday;

  /// Tag for movies releasing in X days
  ///
  /// In en, this message translates to:
  /// **'Releases in {days} days'**
  String releasesInDays(int days);

  /// Clear search button text
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// ID column header
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// Title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Director column header
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get director;

  /// Genre field label
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Grade column header
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// Coming soon label
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Actions column header
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Minimum duration field label
  ///
  /// In en, this message translates to:
  /// **'Min Duration'**
  String get minDuration;

  /// Maximum duration field label
  ///
  /// In en, this message translates to:
  /// **'Max Duration'**
  String get maxDuration;

  /// Minimum grade field label
  ///
  /// In en, this message translates to:
  /// **'Min Grade'**
  String get minGrade;

  /// Maximum grade field label
  ///
  /// In en, this message translates to:
  /// **'Max Grade'**
  String get maxGrade;

  /// Release year label
  ///
  /// In en, this message translates to:
  /// **'Release Year'**
  String get releaseYear;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Message when no data is available
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// Language field label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Bosnian language option
  ///
  /// In en, this message translates to:
  /// **'Bosanski'**
  String get bosnian;

  /// Login page welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Username validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterUsername;

  /// Email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Password minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success dialog title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Text shown when a review has been edited
  ///
  /// In en, this message translates to:
  /// **'(edited)'**
  String get edited;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Movie reviews page title
  ///
  /// In en, this message translates to:
  /// **'Movie Reviews'**
  String get movieReviews;

  /// Average rating statistic card title
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRating;

  /// Total reviews statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get totalReviews;

  /// Positive reviews statistic card title
  ///
  /// In en, this message translates to:
  /// **'Positive Reviews'**
  String get positiveReviews;

  /// Rating out of 5 text
  ///
  /// In en, this message translates to:
  /// **'out of 5.0'**
  String get outOf5;

  /// Reviews count text
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews2;

  /// 4+ stars text
  ///
  /// In en, this message translates to:
  /// **'4+ stars'**
  String get stars4Plus;

  /// Loading reviews message
  ///
  /// In en, this message translates to:
  /// **'Loading reviews...'**
  String get loadingReviews;

  /// No reviews message
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No reviews explanation message
  ///
  /// In en, this message translates to:
  /// **'This movie hasn\'t received any reviews yet.'**
  String get noReviewsMessage;

  /// Unknown user text
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// Today subtitle
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday text
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Days ago text
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Delete review dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Review'**
  String get deleteReview;

  /// Delete review confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the review left by user {username}?'**
  String deleteReviewConfirmation(String username);

  /// Review deleted success message
  ///
  /// In en, this message translates to:
  /// **'Review deleted successfully'**
  String get reviewDeletedSuccessfully;

  /// Error deleting review message
  ///
  /// In en, this message translates to:
  /// **'Error deleting review: {error}'**
  String errorDeletingReview(String error);

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Pagination 'of' text
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// Movie details page title
  ///
  /// In en, this message translates to:
  /// **'Movie Details'**
  String get movieDetails;

  /// Loading movie details message
  ///
  /// In en, this message translates to:
  /// **'Loading movie details...'**
  String get loadingMovieDetails;

  /// No image placeholder text
  ///
  /// In en, this message translates to:
  /// **'No Image'**
  String get noImage;

  /// Edit movie page title
  ///
  /// In en, this message translates to:
  /// **'Edit Movie'**
  String get editMovie;

  /// Delete movie button text
  ///
  /// In en, this message translates to:
  /// **'Delete Movie'**
  String get deleteMovie;

  /// Unknown title placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Title'**
  String get unknownTitle;

  /// Active status text
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive status label
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Minutes text
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Release date field label
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// Genres management tile title
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// Actors management tile title
  ///
  /// In en, this message translates to:
  /// **'Actors'**
  String get actors;

  /// Trailer label
  ///
  /// In en, this message translates to:
  /// **'Trailer'**
  String get trailer;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Unknown value placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No genres assigned text
  ///
  /// In en, this message translates to:
  /// **'No genres assigned'**
  String get noGenresAssigned;

  /// No actors assigned text
  ///
  /// In en, this message translates to:
  /// **'No actors assigned'**
  String get noActorsAssigned;

  /// Be first to review message
  ///
  /// In en, this message translates to:
  /// **'Be the first to review this movie!'**
  String get beFirstToReview;

  /// View all reviews button text
  ///
  /// In en, this message translates to:
  /// **'View All Reviews'**
  String get viewAllReviews;

  /// And more reviews text
  ///
  /// In en, this message translates to:
  /// **'... and {count} more reviews'**
  String andMoreReviews(int count);

  /// Confirm deletion dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// Confirm delete movie message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String confirmDeleteMovie(String title);

  /// Movie deleted success message
  ///
  /// In en, this message translates to:
  /// **'Movie deleted successfully'**
  String get movieDeletedSuccessfully;

  /// Restore movie button text
  ///
  /// In en, this message translates to:
  /// **'Restore Movie'**
  String get restoreMovie;

  /// Movie restored success message
  ///
  /// In en, this message translates to:
  /// **'Movie restored successfully'**
  String get movieRestoredSuccessfully;

  /// Failed to restore movie message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore movie'**
  String get failedToRestoreMovie;

  /// Confirm restoration dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Restoration'**
  String get confirmRestoration;

  /// Confirm restore movie dialog content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore the movie \"{title}\"?'**
  String confirmRestoreMovie(String title);

  /// Restore button text
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Failed to delete movie message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete movie'**
  String get failedToDeleteMovie;

  /// Genre IDs field label
  ///
  /// In en, this message translates to:
  /// **'Genre IDs (e.g., 1,2,3)'**
  String get genreIds;

  /// Genre IDs field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter genre IDs separated by commas'**
  String get genreIdsHint;

  /// Is active field label
  ///
  /// In en, this message translates to:
  /// **'Is Active'**
  String get isActive;

  /// Loading movies message
  ///
  /// In en, this message translates to:
  /// **'Loading movies...'**
  String get loadingMovies;

  /// No movies loaded message
  ///
  /// In en, this message translates to:
  /// **'No movies loaded'**
  String get noMoviesLoaded;

  /// Try adjusting search message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get tryAdjustingSearch;

  /// Unknown director placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Director'**
  String get unknownDirector;

  /// Duration field label
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// Actor field label
  ///
  /// In en, this message translates to:
  /// **'Actor'**
  String get actor;

  /// Trailer URL field label
  ///
  /// In en, this message translates to:
  /// **'Trailer URL'**
  String get trailerUrl;

  /// Image URL field label
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// Movie status field label
  ///
  /// In en, this message translates to:
  /// **'Movie Status'**
  String get movieStatus;

  /// Update movie button text
  ///
  /// In en, this message translates to:
  /// **'Update Movie'**
  String get updateMovie;

  /// Error saving movie message
  ///
  /// In en, this message translates to:
  /// **'Error saving movie: {error}'**
  String errorSavingMovie(String error);

  /// Add screening page title
  ///
  /// In en, this message translates to:
  /// **'Add Screening'**
  String get addScreening;

  /// Loading screenings message
  ///
  /// In en, this message translates to:
  /// **'Loading screenings...'**
  String get loadingScreenings;

  /// No screenings loaded message
  ///
  /// In en, this message translates to:
  /// **'No screenings loaded'**
  String get noScreeningsLoaded;

  /// No screenings found message
  ///
  /// In en, this message translates to:
  /// **'No screenings found'**
  String get noScreeningsFound;

  /// Movie ID field label
  ///
  /// In en, this message translates to:
  /// **'Movie ID'**
  String get movieId;

  /// Movie title field label
  ///
  /// In en, this message translates to:
  /// **'Movie Title'**
  String get movieTitle;

  /// Hall ID field label
  ///
  /// In en, this message translates to:
  /// **'Hall ID'**
  String get hallId;

  /// Screening Format ID field label
  ///
  /// In en, this message translates to:
  /// **'Screening Format ID'**
  String get screeningFormatId;

  /// Minimum base price field label
  ///
  /// In en, this message translates to:
  /// **'Min Base Price'**
  String get minBasePrice;

  /// Maximum base price field label
  ///
  /// In en, this message translates to:
  /// **'Max Base Price'**
  String get maxBasePrice;

  /// From start time field label
  ///
  /// In en, this message translates to:
  /// **'From Start Time (YYYY-MM-DD)'**
  String get fromStartTime;

  /// To start time field label
  ///
  /// In en, this message translates to:
  /// **'To Start Time (YYYY-MM-DD)'**
  String get toStartTime;

  /// Has subtitles switch label
  ///
  /// In en, this message translates to:
  /// **'Has Subtitles'**
  String get hasSubtitles;

  /// Has available seats checkbox label
  ///
  /// In en, this message translates to:
  /// **'Has Available Seats'**
  String get hasAvailableSeats;

  /// Include deleted filter label
  ///
  /// In en, this message translates to:
  /// **'Include Deleted'**
  String get includeDeleted;

  /// Screening deleted success message
  ///
  /// In en, this message translates to:
  /// **'Screening deleted successfully'**
  String get screeningDeletedSuccessfully;

  /// Screening restored success message
  ///
  /// In en, this message translates to:
  /// **'Screening restored successfully'**
  String get screeningRestoredSuccessfully;

  /// Failed to delete screening message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete screening'**
  String get failedToDeleteScreening;

  /// Failed to restore screening message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore screening'**
  String get failedToRestoreScreening;

  /// Confirm delete screening message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the screening for \"{movieTitle}\"?'**
  String confirmDeleteScreeningMessage(String movieTitle);

  /// Confirm restore screening message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore the screening for \"{movieTitle}\"?'**
  String confirmRestoreScreeningMessage(String movieTitle);

  /// Unknown movie fallback text
  ///
  /// In en, this message translates to:
  /// **'Unknown Movie'**
  String get unknownMovie;

  /// Unknown hall fallback text
  ///
  /// In en, this message translates to:
  /// **'Unknown Hall'**
  String get unknownHall;

  /// Deleted status label
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// Screening text
  ///
  /// In en, this message translates to:
  /// **'Screening'**
  String get screening;

  /// Screening updated success message
  ///
  /// In en, this message translates to:
  /// **'Screening updated successfully'**
  String get screeningUpdatedSuccessfully;

  /// Screening created success message
  ///
  /// In en, this message translates to:
  /// **'Screening created successfully'**
  String get screeningCreatedSuccessfully;

  /// Failed to save screening message
  ///
  /// In en, this message translates to:
  /// **'Failed to save screening'**
  String get failedToSaveScreening;

  /// Edit screening page title
  ///
  /// In en, this message translates to:
  /// **'Edit Screening'**
  String get editScreening;

  /// Movie dropdown label
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// Hall dropdown label
  ///
  /// In en, this message translates to:
  /// **'Hall'**
  String get hall;

  /// Screening format dropdown label
  ///
  /// In en, this message translates to:
  /// **'Screening Format (Optional)'**
  String get screeningFormatOptional;

  /// None option text
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No format option text
  ///
  /// In en, this message translates to:
  /// **'No Format'**
  String get noFormat;

  /// Base price field label
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// Start time field label
  ///
  /// In en, this message translates to:
  /// **'Start Time (YYYY-MM-DDTHH:MM:SS)'**
  String get startTime;

  /// End time field label
  ///
  /// In en, this message translates to:
  /// **'End Time (YYYY-MM-DDTHH:MM:SS)'**
  String get endTime;

  /// Update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Movie selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a movie'**
  String get pleaseSelectMovie;

  /// Hall selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a hall'**
  String get pleaseSelectHall;

  /// Language field validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter language'**
  String get pleaseEnterLanguage;

  /// Base price field validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter base price'**
  String get pleaseEnterBasePrice;

  /// Number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// Start time field validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter start time'**
  String get pleaseEnterStartTime;

  /// End time field validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter end time'**
  String get pleaseEnterEndTime;

  /// Unknown format fallback text
  ///
  /// In en, this message translates to:
  /// **'Unknown Format'**
  String get unknownFormat;

  /// Admin profile section title
  ///
  /// In en, this message translates to:
  /// **'Admin Profile'**
  String get adminProfile;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Role field label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Last login field label
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get lastLogin;

  /// Content management section title
  ///
  /// In en, this message translates to:
  /// **'Content Management'**
  String get contentManagement;

  /// System management section title
  ///
  /// In en, this message translates to:
  /// **'System Management'**
  String get systemManagement;

  /// Screening formats management tile title
  ///
  /// In en, this message translates to:
  /// **'Screening Formats'**
  String get screeningFormats;

  /// Halls page title
  ///
  /// In en, this message translates to:
  /// **'Halls'**
  String get halls;

  /// Roles management tile title
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// News articles management tile title
  ///
  /// In en, this message translates to:
  /// **'News Articles'**
  String get newsArticles;

  /// Promotions page title
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotions;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Settings screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your application preferences and system configuration'**
  String get manageYourApplicationPreferences;

  /// Manage genres tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage movie genres and categories'**
  String get manageMovieGenres;

  /// Manage actors subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage Actors'**
  String get manageActors;

  /// Manage screening formats tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage 3D, IMAX, and other formats'**
  String get manageScreeningFormats;

  /// Manage halls tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage cinema halls'**
  String get manageHalls;

  /// Manage seats tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage seat templates and layouts'**
  String get manageSeats;

  /// Message shown when trying to add more than maximum allowed seats
  ///
  /// In en, this message translates to:
  /// **'Maximum number of seats (48) has been reached'**
  String get maxSeatsReached;

  /// Manage users tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage system users and permissions'**
  String get manageUsers;

  /// Manage roles tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage user roles and access levels'**
  String get manageRoles;

  /// Manage news articles tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage news and announcements'**
  String get manageNewsArticles;

  /// Manage promotions tile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage promotional offers and discounts'**
  String get managePromotions;

  /// Save settings button text
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// Reset to default button text
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// Genres list page title
  ///
  /// In en, this message translates to:
  /// **'Genres List'**
  String get genresList;

  /// Manage genres subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage Genres'**
  String get manageGenres;

  /// No genres found message
  ///
  /// In en, this message translates to:
  /// **'No genres found'**
  String get noGenresFound;

  /// No genres match search message
  ///
  /// In en, this message translates to:
  /// **'No genres match your search'**
  String get noGenresMatchSearch;

  /// Loading genres message
  ///
  /// In en, this message translates to:
  /// **'Loading genres...'**
  String get loadingGenres;

  /// No genres loaded message
  ///
  /// In en, this message translates to:
  /// **'No genres loaded'**
  String get noGenresLoaded;

  /// Add genre button text
  ///
  /// In en, this message translates to:
  /// **'Add Genre'**
  String get addGenre;

  /// Edit genre button text
  ///
  /// In en, this message translates to:
  /// **'Edit Genre'**
  String get editGenre;

  /// Delete genre button text
  ///
  /// In en, this message translates to:
  /// **'Delete Genre'**
  String get deleteGenre;

  /// Genre name field label
  ///
  /// In en, this message translates to:
  /// **'Genre Name'**
  String get genreName;

  /// Genre description field label
  ///
  /// In en, this message translates to:
  /// **'Genre Description'**
  String get genreDescription;

  /// Genre name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter genre name'**
  String get pleaseEnterGenreName;

  /// Genre description validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter genre description'**
  String get pleaseEnterGenreDescription;

  /// Genre created success message
  ///
  /// In en, this message translates to:
  /// **'Genre created successfully'**
  String get genreCreatedSuccessfully;

  /// Genre updated success message
  ///
  /// In en, this message translates to:
  /// **'Genre updated successfully'**
  String get genreUpdatedSuccessfully;

  /// Genre deleted success message
  ///
  /// In en, this message translates to:
  /// **'Genre deleted successfully'**
  String get genreDeletedSuccessfully;

  /// Genre restored success message
  ///
  /// In en, this message translates to:
  /// **'Genre restored successfully'**
  String get genreRestoredSuccessfully;

  /// Failed to save genre message
  ///
  /// In en, this message translates to:
  /// **'Failed to save genre'**
  String get failedToSaveGenre;

  /// Failed to delete genre message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete genre'**
  String get failedToDeleteGenre;

  /// Failed to restore genre message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore genre'**
  String get failedToRestoreGenre;

  /// Confirm delete genre message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteGenre(String name);

  /// Confirm restore genre dialog content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore the genre \"{name}\"?'**
  String confirmRestoreGenre(String name);

  /// Unnamed genre placeholder
  ///
  /// In en, this message translates to:
  /// **'Unnamed Genre'**
  String get unnamedGenre;

  /// Actors list page title
  ///
  /// In en, this message translates to:
  /// **'Actors List'**
  String get actorsList;

  /// No actors found message
  ///
  /// In en, this message translates to:
  /// **'No actors found'**
  String get noActorsFound;

  /// No actors match search message
  ///
  /// In en, this message translates to:
  /// **'No actors match your search'**
  String get noActorsMatchSearch;

  /// Loading actors message
  ///
  /// In en, this message translates to:
  /// **'Loading actors...'**
  String get loadingActors;

  /// No actors loaded message
  ///
  /// In en, this message translates to:
  /// **'No actors loaded'**
  String get noActorsLoaded;

  /// Add actor button text
  ///
  /// In en, this message translates to:
  /// **'Add Actor'**
  String get addActor;

  /// Edit actor button text
  ///
  /// In en, this message translates to:
  /// **'Edit Actor'**
  String get editActor;

  /// Delete actor button text
  ///
  /// In en, this message translates to:
  /// **'Delete Actor'**
  String get deleteActor;

  /// Actor first name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get actorFirstName;

  /// Actor last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get actorLastName;

  /// Actor biography field label
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get actorBiography;

  /// Actor first name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter first name'**
  String get pleaseEnterActorFirstName;

  /// Actor last name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter last name'**
  String get pleaseEnterActorLastName;

  /// Actor biography validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter biography'**
  String get pleaseEnterActorBiography;

  /// Actor created success message
  ///
  /// In en, this message translates to:
  /// **'Actor created successfully'**
  String get actorCreatedSuccessfully;

  /// Actor updated success message
  ///
  /// In en, this message translates to:
  /// **'Actor updated successfully'**
  String get actorUpdatedSuccessfully;

  /// Actor deleted success message
  ///
  /// In en, this message translates to:
  /// **'Actor deleted successfully'**
  String get actorDeletedSuccessfully;

  /// Actor restored success message
  ///
  /// In en, this message translates to:
  /// **'Actor restored successfully'**
  String get actorRestoredSuccessfully;

  /// Failed to save actor message
  ///
  /// In en, this message translates to:
  /// **'Failed to save actor'**
  String get failedToSaveActor;

  /// Failed to delete actor message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete actor'**
  String get failedToDeleteActor;

  /// Failed to restore actor message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore actor'**
  String get failedToRestoreActor;

  /// Confirm delete actor message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteActor(String name);

  /// Confirm restore actor dialog content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore the actor \"{name}\"?'**
  String confirmRestoreActor(String name);

  /// Unnamed actor placeholder
  ///
  /// In en, this message translates to:
  /// **'Unnamed Actor'**
  String get unnamedActor;

  /// Date of birth field label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Add screening format button text
  ///
  /// In en, this message translates to:
  /// **'Add Screening Format'**
  String get addScreeningFormat;

  /// Edit screening format button text
  ///
  /// In en, this message translates to:
  /// **'Edit Screening Format'**
  String get editScreeningFormat;

  /// Delete screening format button text
  ///
  /// In en, this message translates to:
  /// **'Delete Screening Format'**
  String get deleteScreeningFormat;

  /// Screening format name field label
  ///
  /// In en, this message translates to:
  /// **'Screening Format Name'**
  String get screeningFormatName;

  /// Screening format description field label
  ///
  /// In en, this message translates to:
  /// **'Screening Format Description'**
  String get screeningFormatDescription;

  /// Screening format name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter screening format name'**
  String get pleaseEnterScreeningFormatName;

  /// Screening format description validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter screening format description'**
  String get pleaseEnterScreeningFormatDescription;

  /// Price multiplier field label
  ///
  /// In en, this message translates to:
  /// **'Price Multiplier'**
  String get priceMultiplier;

  /// Price multiplier validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter price multiplier'**
  String get pleaseEnterPriceMultiplier;

  /// Screening format created success message
  ///
  /// In en, this message translates to:
  /// **'Screening format created successfully'**
  String get screeningFormatCreatedSuccessfully;

  /// Screening format updated success message
  ///
  /// In en, this message translates to:
  /// **'Screening format updated successfully'**
  String get screeningFormatUpdatedSuccessfully;

  /// Screening format deleted success message
  ///
  /// In en, this message translates to:
  /// **'Screening format deleted successfully'**
  String get screeningFormatDeletedSuccessfully;

  /// Screening format restored success message
  ///
  /// In en, this message translates to:
  /// **'Screening format restored successfully'**
  String get screeningFormatRestoredSuccessfully;

  /// Failed to save screening format message
  ///
  /// In en, this message translates to:
  /// **'Failed to save screening format'**
  String get failedToSaveScreeningFormat;

  /// Failed to delete screening format message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete screening format'**
  String get failedToDeleteScreeningFormat;

  /// Failed to restore screening format message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore screening format'**
  String get failedToRestoreScreeningFormat;

  /// Confirm delete screening format message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteScreeningFormat(String name);

  /// Confirm restore screening format dialog content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore the screening format \"{name}\"?'**
  String confirmRestoreScreeningFormat(String name);

  /// Unnamed screening format placeholder
  ///
  /// In en, this message translates to:
  /// **'Unnamed Screening Format'**
  String get unnamedScreeningFormat;

  /// Loading screening formats message
  ///
  /// In en, this message translates to:
  /// **'Loading screening formats...'**
  String get loadingScreeningFormats;

  /// No screening formats loaded message
  ///
  /// In en, this message translates to:
  /// **'No screening formats loaded'**
  String get noScreeningFormatsLoaded;

  /// No screening formats found message
  ///
  /// In en, this message translates to:
  /// **'No screening formats found'**
  String get noScreeningFormatsFound;

  /// Edit screening format screen coming soon message
  ///
  /// In en, this message translates to:
  /// **'Edit screening format screen - Coming soon'**
  String get editScreeningFormatScreenComingSoon;

  /// Halls and Seats page title
  ///
  /// In en, this message translates to:
  /// **'Halls'**
  String get hallsAndSeats;

  /// Management System subtitle
  ///
  /// In en, this message translates to:
  /// **'Management System'**
  String get managementSystem;

  /// Loading halls message
  ///
  /// In en, this message translates to:
  /// **'Loading halls...'**
  String get loadingHalls;

  /// No halls loaded message
  ///
  /// In en, this message translates to:
  /// **'No halls loaded'**
  String get noHallsLoaded;

  /// No halls found message
  ///
  /// In en, this message translates to:
  /// **'No halls found'**
  String get noHallsFound;

  /// Hall capacity field label
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// Default name for unnamed hall
  ///
  /// In en, this message translates to:
  /// **'Unnamed Hall'**
  String get unnamedHall;

  /// Delete hall dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Hall'**
  String get deleteHall;

  /// Confirm delete hall message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the hall \"{hallName}\"?'**
  String confirmDeleteHall(Object hallName);

  /// Hall deleted successfully message
  ///
  /// In en, this message translates to:
  /// **'Hall deleted successfully'**
  String get hallDeletedSuccessfully;

  /// Failed to delete hall message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete hall'**
  String get failedToDeleteHall;

  /// Confirm restore hall message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore the hall \"{hallName}\"?'**
  String confirmRestoreHall(Object hallName);

  /// Hall restored successfully message
  ///
  /// In en, this message translates to:
  /// **'Hall restored successfully'**
  String get hallRestoredSuccessfully;

  /// Failed to restore hall message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore hall'**
  String get failedToRestoreHall;

  /// Edit hall screen coming soon message
  ///
  /// In en, this message translates to:
  /// **'Edit hall screen - Coming soon'**
  String get editHallScreenComingSoon;

  /// Add hall button text
  ///
  /// In en, this message translates to:
  /// **'Add Hall'**
  String get addHall;

  /// Edit hall screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Hall'**
  String get editHall;

  /// Add new hall screen title
  ///
  /// In en, this message translates to:
  /// **'Add New Hall'**
  String get addNewHall;

  /// Hall name field label
  ///
  /// In en, this message translates to:
  /// **'Hall Name'**
  String get hallName;

  /// Hall location field label
  ///
  /// In en, this message translates to:
  /// **'Hall Location'**
  String get hallLocation;

  /// Hall capacity field label
  ///
  /// In en, this message translates to:
  /// **'Hall Capacity'**
  String get hallCapacity;

  /// Hall screen type field label
  ///
  /// In en, this message translates to:
  /// **'Screen Type'**
  String get hallScreenType;

  /// Hall sound system field label
  ///
  /// In en, this message translates to:
  /// **'Sound System'**
  String get hallSoundSystem;

  /// Hall name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter hall name'**
  String get pleaseEnterHallName;

  /// Hall location validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter hall location'**
  String get pleaseEnterHallLocation;

  /// Hall capacity validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter hall capacity'**
  String get pleaseEnterHallCapacity;

  /// Hall screen type validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter screen type'**
  String get pleaseEnterHallScreenType;

  /// Hall sound system validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter sound system'**
  String get pleaseEnterHallSoundSystem;

  /// Hall saved successfully message
  ///
  /// In en, this message translates to:
  /// **'Hall saved successfully'**
  String get hallSavedSuccessfully;

  /// Failed to save hall message
  ///
  /// In en, this message translates to:
  /// **'Failed to save hall'**
  String get failedToSaveHall;

  /// Edit hall description
  ///
  /// In en, this message translates to:
  /// **'Update hall information and settings'**
  String get editHallDescription;

  /// Add new hall description
  ///
  /// In en, this message translates to:
  /// **'Create a new hall with required information'**
  String get addNewHallDescription;

  /// Capacity validation message
  ///
  /// In en, this message translates to:
  /// **'Capacity must be at least 1'**
  String get capacityMustBeAtLeastOne;

  /// Screen type hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., Regular, IMAX, 3D'**
  String get screenTypeHint;

  /// Sound system hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., Dolby Digital, SDDS'**
  String get soundSystemHint;

  /// Saving in progress message
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Edit news article screen title
  ///
  /// In en, this message translates to:
  /// **'Edit News Article'**
  String get editNewsArticle;

  /// Add news article screen title
  ///
  /// In en, this message translates to:
  /// **'Add News Article'**
  String get addNewsArticle;

  /// Update news article button text
  ///
  /// In en, this message translates to:
  /// **'Update News Article'**
  String get updateNewsArticle;

  /// Content field label
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Publish date field label
  ///
  /// In en, this message translates to:
  /// **'Publish Date'**
  String get publishDate;

  /// Title validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// Content validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter content'**
  String get pleaseEnterContent;

  /// Title length validation message
  ///
  /// In en, this message translates to:
  /// **'Title must be less than 100 characters'**
  String get titleTooLong;

  /// News article created success message
  ///
  /// In en, this message translates to:
  /// **'News article created successfully'**
  String get newsArticleCreatedSuccessfully;

  /// News article updated success message
  ///
  /// In en, this message translates to:
  /// **'News article updated successfully'**
  String get newsArticleUpdatedSuccessfully;

  /// Failed to save news article message
  ///
  /// In en, this message translates to:
  /// **'Failed to save news article'**
  String get failedToSaveNewsArticle;

  /// Delete news article dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete News Article'**
  String get deleteNewsArticle;

  /// Confirm delete news article message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete news article \"{title}\"?'**
  String confirmDeleteNewsArticle(String title);

  /// News article deleted success message
  ///
  /// In en, this message translates to:
  /// **'News article deleted successfully'**
  String get newsArticleDeletedSuccessfully;

  /// Failed to delete news article message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete news article'**
  String get failedToDeleteNewsArticle;

  /// Restore news article dialog title
  ///
  /// In en, this message translates to:
  /// **'Restore News Article'**
  String get restoreNewsArticle;

  /// Confirm restore news article message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore news article \"{title}\"?'**
  String confirmRestoreNewsArticle(String title);

  /// News article restored success message
  ///
  /// In en, this message translates to:
  /// **'News article restored successfully'**
  String get newsArticleRestoredSuccessfully;

  /// Failed to restore news article message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore news article'**
  String get failedToRestoreNewsArticle;

  /// Add news button text
  ///
  /// In en, this message translates to:
  /// **'Add News'**
  String get addNews;

  /// Loading news articles message
  ///
  /// In en, this message translates to:
  /// **'Loading news articles...'**
  String get loadingNewsArticles;

  /// No news articles loaded message
  ///
  /// In en, this message translates to:
  /// **'No news articles loaded'**
  String get noNewsArticlesLoaded;

  /// No news articles found message
  ///
  /// In en, this message translates to:
  /// **'No news articles found'**
  String get noNewsArticlesFound;

  /// Try adjusting search criteria message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get tryAdjustingSearchCriteria;

  /// From publish date filter label
  ///
  /// In en, this message translates to:
  /// **'From Publish Date'**
  String get fromPublishDate;

  /// To publish date filter label
  ///
  /// In en, this message translates to:
  /// **'To Publish Date'**
  String get toPublishDate;

  /// Select date button text
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No content placeholder
  ///
  /// In en, this message translates to:
  /// **'No content'**
  String get noContent;

  /// Make article visible switch label
  ///
  /// In en, this message translates to:
  /// **'Make this article visible'**
  String get makeArticleVisible;

  /// Edit promotion screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Promotion'**
  String get editPromotion;

  /// Add promotion screen title
  ///
  /// In en, this message translates to:
  /// **'Add Promotion'**
  String get addPromotion;

  /// Update promotion button text
  ///
  /// In en, this message translates to:
  /// **'Update Promotion'**
  String get updatePromotion;

  /// Code field label
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// Discount percentage field label
  ///
  /// In en, this message translates to:
  /// **'Discount Percentage'**
  String get discountPercentage;

  /// Start date field label
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// End date field label
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// Name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// Description validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get pleaseEnterDescription;

  /// Code validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter code'**
  String get pleaseEnterCode;

  /// Discount percentage validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter discount percentage (0-100)'**
  String get pleaseEnterDiscountPercentage;

  /// Start date validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter start date'**
  String get pleaseEnterStartDate;

  /// End date validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter end date'**
  String get pleaseEnterEndDate;

  /// Name length validation message
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 100 characters'**
  String get nameTooLong;

  /// Description length validation message
  ///
  /// In en, this message translates to:
  /// **'Description must be less than 500 characters'**
  String get descriptionTooLong;

  /// Code length validation message
  ///
  /// In en, this message translates to:
  /// **'Code must be less than 20 characters'**
  String get codeTooLong;

  /// Discount percentage range validation message
  ///
  /// In en, this message translates to:
  /// **'Discount percentage must be between 0 and 100'**
  String get discountPercentageInvalid;

  /// End date validation message
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endDateMustBeAfterStartDate;

  /// No description provided for @endTimeMustBeAfterStartTime.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endTimeMustBeAfterStartTime;

  /// Promotion created success message
  ///
  /// In en, this message translates to:
  /// **'Promotion created successfully'**
  String get promotionCreatedSuccessfully;

  /// Promotion updated success message
  ///
  /// In en, this message translates to:
  /// **'Promotion updated successfully'**
  String get promotionUpdatedSuccessfully;

  /// Failed to save promotion message
  ///
  /// In en, this message translates to:
  /// **'Failed to save promotion'**
  String get failedToSavePromotion;

  /// Delete promotion dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Promotion'**
  String get deletePromotion;

  /// Confirm delete promotion message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete promotion \"{name}\"?'**
  String confirmDeletePromotion(String name);

  /// Promotion deleted success message
  ///
  /// In en, this message translates to:
  /// **'Promotion deleted successfully'**
  String get promotionDeletedSuccessfully;

  /// Failed to delete promotion message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete promotion'**
  String get failedToDeletePromotion;

  /// Restore promotion dialog title
  ///
  /// In en, this message translates to:
  /// **'Restore Promotion'**
  String get restorePromotion;

  /// Confirm restore promotion message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore promotion \"{name}\"?'**
  String confirmRestorePromotion(String name);

  /// Promotion restored success message
  ///
  /// In en, this message translates to:
  /// **'Promotion restored successfully'**
  String get promotionRestoredSuccessfully;

  /// Failed to restore promotion message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore promotion'**
  String get failedToRestorePromotion;

  /// Loading promotions message
  ///
  /// In en, this message translates to:
  /// **'Loading promotions...'**
  String get loadingPromotions;

  /// No promotions loaded message
  ///
  /// In en, this message translates to:
  /// **'No promotions loaded'**
  String get noPromotionsLoaded;

  /// No promotions found message
  ///
  /// In en, this message translates to:
  /// **'No promotions found'**
  String get noPromotionsFound;

  /// From start date filter label
  ///
  /// In en, this message translates to:
  /// **'From Start Date'**
  String get fromStartDate;

  /// To start date filter label
  ///
  /// In en, this message translates to:
  /// **'To Start Date'**
  String get toStartDate;

  /// From end date filter label
  ///
  /// In en, this message translates to:
  /// **'From End Date'**
  String get fromEndDate;

  /// To end date filter label
  ///
  /// In en, this message translates to:
  /// **'To End Date'**
  String get toEndDate;

  /// Minimum discount filter label
  ///
  /// In en, this message translates to:
  /// **'Min Discount'**
  String get minDiscount;

  /// Maximum discount filter label
  ///
  /// In en, this message translates to:
  /// **'Max Discount'**
  String get maxDiscount;

  /// No description placeholder
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// Make promotion visible switch label
  ///
  /// In en, this message translates to:
  /// **'Make this promotion visible'**
  String get makePromotionVisible;

  /// Delete user dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// Delete user confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete user {userName}?'**
  String confirmDeleteUser(String userName);

  /// User deleted success message
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeletedSuccessfully;

  /// Failed to delete user message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete user'**
  String get failedToDeleteUser;

  /// Restore user dialog title
  ///
  /// In en, this message translates to:
  /// **'Restore User'**
  String get restoreUser;

  /// Restore user confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore user {userName}?'**
  String confirmRestoreUser(String userName);

  /// User restored success message
  ///
  /// In en, this message translates to:
  /// **'User restored successfully'**
  String get userRestoredSuccessfully;

  /// Failed to restore user message
  ///
  /// In en, this message translates to:
  /// **'Failed to restore user'**
  String get failedToRestoreUser;

  /// Loading users message
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loadingUsers;

  /// No users loaded message
  ///
  /// In en, this message translates to:
  /// **'No users loaded'**
  String get noUsersLoaded;

  /// No users found message
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// Admin role label
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Total movies statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total Movies'**
  String get totalMovies;

  /// Total actors statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total Actors'**
  String get totalActors;

  /// Total genres statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total Genres'**
  String get totalGenres;

  /// Total users statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// Total halls statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total Halls'**
  String get totalHalls;

  /// Total shows statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total projections'**
  String get totalShows;

  /// Total reservations statistic card title
  ///
  /// In en, this message translates to:
  /// **'Total Reservations'**
  String get totalReservations;

  /// Active Screenings statistic card title
  ///
  /// In en, this message translates to:
  /// **'Active Screenings'**
  String get activeShows;

  /// Today's screenings section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Screenings'**
  String get todayScreenings;

  /// In catalog subtitle
  ///
  /// In en, this message translates to:
  /// **'In catalog'**
  String get inCatalog;

  /// Registered subtitle
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// All time subtitle
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// Dashboard welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to eCinema Management System'**
  String get welcomeToECinema;

  /// Movie poster section title
  ///
  /// In en, this message translates to:
  /// **'Movie Poster'**
  String get moviePoster;

  /// Text to prompt user to select movie image
  ///
  /// In en, this message translates to:
  /// **'Select movie'**
  String get selectMovie;

  /// Dashboard subtitle
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s happening with your cinema today'**
  String get heresWhatHappening;

  /// Spoiler label
  ///
  /// In en, this message translates to:
  /// **'Spoiler'**
  String get spoiler;

  /// Mark as spoiler button text
  ///
  /// In en, this message translates to:
  /// **'Mark as Spoiler'**
  String get markAsSpoiler;

  /// Unmark as spoiler button text
  ///
  /// In en, this message translates to:
  /// **'Unmark as Spoiler'**
  String get unmarkAsSpoiler;

  /// Review marked as spoiler success message
  ///
  /// In en, this message translates to:
  /// **'Review marked as spoiler'**
  String get reviewMarkedAsSpoiler;

  /// Review unmarked as spoiler success message
  ///
  /// In en, this message translates to:
  /// **'Review unmarked as spoiler'**
  String get reviewUnmarkedAsSpoiler;

  /// Failed to update review error message
  ///
  /// In en, this message translates to:
  /// **'Failed to update review'**
  String get failedToUpdateReview;

  /// Cinema reports title
  ///
  /// In en, this message translates to:
  /// **'Cinema Reports'**
  String get cinemaReports;

  /// Total income label
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// Top 5 watched movies section title
  ///
  /// In en, this message translates to:
  /// **'Top 5 Watched Movies'**
  String get top5WatchedMovies;

  /// Revenue by movie section title
  ///
  /// In en, this message translates to:
  /// **'Revenue by Movie'**
  String get revenueByMovie;

  /// Top 5 customers section title
  ///
  /// In en, this message translates to:
  /// **'Top 5 Customers'**
  String get top5Customers;

  /// Revenue label
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// Total spent label
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// Refresh button label
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No data available message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Reservations label
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get reservations;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark mode option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Don't have admin account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an admin account?'**
  String get dontHaveAdminAccount;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Admin registration page title
  ///
  /// In en, this message translates to:
  /// **'Admin Registration'**
  String get adminRegistration;

  /// Admin registration subtitle
  ///
  /// In en, this message translates to:
  /// **'Create a new administrator account'**
  String get createNewAdminAccount;

  /// Phone number field label (optional)
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get phoneNumberOptional;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// First name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter first name'**
  String get pleaseEnterFirstName;

  /// Last name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter last name'**
  String get pleaseEnterLastName;

  /// Email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email'**
  String get pleaseEnterValidEmail;

  /// Username minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// Password confirmation validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseConfirmPassword;

  /// Password mismatch validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Account created success message
  ///
  /// In en, this message translates to:
  /// **'Admin account created successfully! Redirecting to login...'**
  String get accountCreatedSuccessfully;

  /// Failed to create account message
  ///
  /// In en, this message translates to:
  /// **'Failed to create admin account'**
  String get failedToCreateAccount;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Invalid credentials error message
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// Admin access required error message
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to use this application. Only administrators can access the desktop application.'**
  String get adminAccessRequired;

  /// Add role button text
  ///
  /// In en, this message translates to:
  /// **'Add Role'**
  String get addRole;

  /// Edit role button text
  ///
  /// In en, this message translates to:
  /// **'Edit Role'**
  String get editRole;

  /// Role name field label
  ///
  /// In en, this message translates to:
  /// **'Role Name'**
  String get roleName;

  /// Role name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter role name'**
  String get enterRoleName;

  /// Role name validation message
  ///
  /// In en, this message translates to:
  /// **'Role name is required'**
  String get roleNameRequired;

  /// Role name length validation message
  ///
  /// In en, this message translates to:
  /// **'Role name must be less than 50 characters'**
  String get roleNameTooLong;

  /// Role created success message
  ///
  /// In en, this message translates to:
  /// **'Role created successfully'**
  String get roleCreatedSuccessfully;

  /// Role updated success message
  ///
  /// In en, this message translates to:
  /// **'Role updated successfully'**
  String get roleUpdatedSuccessfully;

  /// Role deleted success message
  ///
  /// In en, this message translates to:
  /// **'Role deleted successfully'**
  String get roleDeletedSuccessfully;

  /// Failed to delete role message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete role'**
  String get failedToDeleteRole;

  /// Role deletion confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this role? This action is permanent and cannot be undone.'**
  String get confirmDeleteRole;

  /// Delete role button text
  ///
  /// In en, this message translates to:
  /// **'Delete Role'**
  String get deleteRole;

  /// Loading roles message
  ///
  /// In en, this message translates to:
  /// **'Loading roles...'**
  String get loadingRoles;

  /// No roles loaded message
  ///
  /// In en, this message translates to:
  /// **'No roles loaded'**
  String get noRolesLoaded;

  /// No roles found message
  ///
  /// In en, this message translates to:
  /// **'No roles found'**
  String get noRolesFound;

  /// Search roles placeholder
  ///
  /// In en, this message translates to:
  /// **'Search roles...'**
  String get searchRoles;

  /// Total roles count message
  ///
  /// In en, this message translates to:
  /// **'Total: {count} roles'**
  String totalRoles(int count);

  /// Default role name when name is missing
  ///
  /// In en, this message translates to:
  /// **'Unnamed Role'**
  String get unnamedRole;

  /// Edit user screen title
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// Add user button text
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// User label
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// User updated success message
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdatedSuccessfully;

  /// User created success message
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccessfully;

  /// Failed to save user message
  ///
  /// In en, this message translates to:
  /// **'Failed to save user: {error}'**
  String failedToSaveUser(String error);

  /// Edit profile button text
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Profile information section title
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// Profile updated success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// Failed to update profile error message
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String failedToUpdateProfile(String error);

  /// Capacity mismatch dialog title
  ///
  /// In en, this message translates to:
  /// **'Capacity Mismatch'**
  String get capacityMismatch;

  /// Message when seat count doesn't match hall capacity
  ///
  /// In en, this message translates to:
  /// **'Seat count mismatch: {seats} / {capacity}'**
  String seatCountMismatch(int seats, int capacity);

  /// Auto-generate seats dialog title
  ///
  /// In en, this message translates to:
  /// **'Auto-generate Seats'**
  String get autoGenerateSeats;

  /// Auto-generate seats confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will create {capacity} seats for the hall. Existing seats will be replaced. Continue?'**
  String autoGenerateSeatsMessage(int capacity);

  /// Generate button text
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// Success message when seats are generated
  ///
  /// In en, this message translates to:
  /// **'Seats generated successfully'**
  String get seatsGeneratedSuccessfully;

  /// Error message when seat generation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to generate seats'**
  String get failedToGenerateSeats;

  /// Seats management section title
  ///
  /// In en, this message translates to:
  /// **'Seats Management'**
  String get seatsManagement;

  /// Add seat button text
  ///
  /// In en, this message translates to:
  /// **'Add Seat'**
  String get addSeat;

  /// Message when no seats are found for a hall
  ///
  /// In en, this message translates to:
  /// **'No seats found for this hall'**
  String get noSeatsFound;

  /// Edit seat dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Seat'**
  String get editSeat;

  /// Seat number field label
  ///
  /// In en, this message translates to:
  /// **'Seat Number'**
  String get seatNumber;

  /// Row number field label
  ///
  /// In en, this message translates to:
  /// **'Row Number'**
  String get rowNumber;

  /// Validation message for seat number
  ///
  /// In en, this message translates to:
  /// **'Please enter seat number'**
  String get pleaseEnterSeatNumber;

  /// Validation message for row number
  ///
  /// In en, this message translates to:
  /// **'Please enter row number'**
  String get pleaseEnterRowNumber;

  /// Delete seat dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Seat'**
  String get confirmDeleteSeat;

  /// Delete seat confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this seat?'**
  String get areYouSureDeleteSeat;

  /// Seat updated success message
  ///
  /// In en, this message translates to:
  /// **'Seat updated successfully'**
  String get seatUpdatedSuccessfully;

  /// Failed to update seat message
  ///
  /// In en, this message translates to:
  /// **'Failed to update seat'**
  String get failedToUpdateSeat;

  /// Seat deleted success message
  ///
  /// In en, this message translates to:
  /// **'Seat deleted successfully'**
  String get seatDeletedSuccessfully;

  /// Failed to delete seat message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete seat'**
  String get failedToDeleteSeat;

  /// Add new seat dialog title
  ///
  /// In en, this message translates to:
  /// **'Add New Seat'**
  String get addNewSeat;

  /// Success message when seat is saved
  ///
  /// In en, this message translates to:
  /// **'Seat saved successfully'**
  String get seatSavedSuccessfully;

  /// Error message when seat save fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save seat'**
  String get failedToSaveSeat;

  /// Message when seat count matches hall capacity
  ///
  /// In en, this message translates to:
  /// **'Seat count matches capacity: {seats} / {capacity}'**
  String seatCountMatchesCapacity(int seats, int capacity);

  /// Error message when trying to add more seats than hall capacity
  ///
  /// In en, this message translates to:
  /// **'Cannot add more seats. Hall capacity is {capacity} and current seat count is {seats}.'**
  String cannotAddMoreSeats(int capacity, int seats);

  /// Error message when trying to move seat to hall that's at capacity
  ///
  /// In en, this message translates to:
  /// **'Cannot move seat to this hall. Hall capacity is {capacity} and current seat count is {seats}.'**
  String cannotMoveSeatToHall(int capacity, int seats);

  /// Tooltip for auto-generate seats button
  ///
  /// In en, this message translates to:
  /// **'Auto-generate seats for this capacity'**
  String get autoGenerateSeatsTooltip;

  /// Seat name field label
  ///
  /// In en, this message translates to:
  /// **'Seat Name'**
  String get seatName;

  /// Seat name format helper text
  ///
  /// In en, this message translates to:
  /// **'Format: Letter (A-F) + Number (1-8)'**
  String get seatNameFormat;

  /// Seat name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter seat name'**
  String get pleaseEnterSeatName;

  /// Invalid seat format validation message
  ///
  /// In en, this message translates to:
  /// **'Invalid format. Use A1-F8 format (e.g., A1, B5, F8)'**
  String get invalidSeatFormat;

  /// Seat already exists validation message
  ///
  /// In en, this message translates to:
  /// **'Seat {name} already exists'**
  String seatAlreadyExists(String name);

  /// Seat added success message
  ///
  /// In en, this message translates to:
  /// **'Seat added successfully'**
  String get seatAddedSuccessfully;

  /// Failed to add seat message
  ///
  /// In en, this message translates to:
  /// **'Failed to add seat'**
  String get failedToAddSeat;

  /// Add button text
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Regenerate all button text
  ///
  /// In en, this message translates to:
  /// **'Regenerate All'**
  String get regenerateAll;

  /// Message shown when all seats already exist
  ///
  /// In en, this message translates to:
  /// **'All seats already exist'**
  String get allSeatsAlreadyExist;

  /// Available seats label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Reserved seats label
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reserved;

  /// Select date range button text
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// Tooltip for date range selector
  ///
  /// In en, this message translates to:
  /// **'Select a date range to filter data'**
  String get selectDateRangeTooltip;

  /// Occupancy label
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// Type field label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Event type option
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// Event date field label
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDate;

  /// Type selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select type'**
  String get pleaseSelectType;

  /// Event date validation message
  ///
  /// In en, this message translates to:
  /// **'Please select event date'**
  String get pleaseSelectEventDate;

  /// Error message when publish date is in the future
  ///
  /// In en, this message translates to:
  /// **'Please select a publish date that is not in the future'**
  String get publishDateCannotBeInFuture;

  /// Error message when event date is missing for event type
  ///
  /// In en, this message translates to:
  /// **'Event date is required for events'**
  String get eventDateRequired;

  /// Error message when news type has event date
  ///
  /// In en, this message translates to:
  /// **'News articles cannot have an event date'**
  String get newsCannotHaveEventDate;

  /// Movie title validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter movie title'**
  String get pleaseEnterMovieTitle;

  /// Movie title length validation message
  ///
  /// In en, this message translates to:
  /// **'Title must be less than 200 characters'**
  String get movieTitleTooLong;

  /// Movie description validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter movie description'**
  String get pleaseEnterMovieDescription;

  /// Movie description length validation message
  ///
  /// In en, this message translates to:
  /// **'Description must be less than 1000 characters'**
  String get movieDescriptionTooLong;

  /// Movie director validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter movie director'**
  String get pleaseEnterMovieDirector;

  /// Movie director length validation message
  ///
  /// In en, this message translates to:
  /// **'Director name must be less than 100 characters'**
  String get movieDirectorTooLong;

  /// Movie duration validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter movie duration'**
  String get pleaseEnterMovieDuration;

  /// Movie duration minimum validation message
  ///
  /// In en, this message translates to:
  /// **'Duration must be at least 1 minute'**
  String get movieDurationTooShort;

  /// Movie duration maximum validation message
  ///
  /// In en, this message translates to:
  /// **'Duration cannot exceed 600 minutes (10 hours)'**
  String get movieDurationTooLong;

  /// Movie duration help text
  ///
  /// In en, this message translates to:
  /// **'Enter duration in minutes (1-600)'**
  String get durationMinutesHelp;

  /// Release date validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter release date'**
  String get pleaseEnterReleaseDate;

  /// Invalid release year validation message
  ///
  /// In en, this message translates to:
  /// **'Invalid release year. Must be between 1888 and next year'**
  String get invalidReleaseYear;

  /// Trailer URL help text
  ///
  /// In en, this message translates to:
  /// **'Enter valid YouTube or other video URL'**
  String get trailerUrlHelp;

  /// URL validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get pleaseEnterValidUrl;

  /// Genre selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select at least one genre'**
  String get pleaseSelectAtLeastOneGenre;

  /// Actor selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select at least one actor'**
  String get pleaseSelectAtLeastOneActor;

  /// Movie created success message
  ///
  /// In en, this message translates to:
  /// **'Movie created successfully'**
  String get movieCreatedSuccessfully;

  /// Movie updated success message
  ///
  /// In en, this message translates to:
  /// **'Movie updated successfully'**
  String get movieUpdatedSuccessfully;

  /// Username format validation message
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters, numbers and underscores'**
  String get usernameInvalid;

  /// Phone number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneNumberInvalid;

  /// Phone number format help text
  ///
  /// In en, this message translates to:
  /// **'Format: +123 45 678 910'**
  String get phoneNumberFormat;

  /// No description provided for @confirmDeletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletionTitle;

  /// No description provided for @confirmDeleteSeatMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the seat \"{seatName}\"? This will remove the seat from all existing screenings.'**
  String confirmDeleteSeatMessage(Object seatName);

  /// No description provided for @deleteButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButtonLabel;

  /// No description provided for @cancelButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonLabel;

  /// Seat layout section title
  ///
  /// In en, this message translates to:
  /// **'Seat Layout'**
  String get seatLayout;

  /// Search placeholder text for various fields
  ///
  /// In en, this message translates to:
  /// **'Search {label}...'**
  String searchPlaceholder(String label);

  /// Search placeholder text for genres
  ///
  /// In en, this message translates to:
  /// **'Search genres...'**
  String get searchGenresPlaceholder;

  /// Search placeholder text for actors
  ///
  /// In en, this message translates to:
  /// **'Search actors...'**
  String get searchActorsPlaceholder;

  /// Search button label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButtonLabel;

  /// Message shown when there are no screenings today
  ///
  /// In en, this message translates to:
  /// **'No screenings today'**
  String get noScreeningsToday;

  /// Success message when PDF is exported
  ///
  /// In en, this message translates to:
  /// **'PDF exported successfully!'**
  String get pdfExportedSuccessfully;

  /// Error message when PDF export fails
  ///
  /// In en, this message translates to:
  /// **'Failed to export PDF. Please try again.'**
  String get failedToExportPdf;

  /// Title for seats overview section
  ///
  /// In en, this message translates to:
  /// **'Seats Overview'**
  String get seatsOverview;

  /// Tooltip for refresh seats button
  ///
  /// In en, this message translates to:
  /// **'Refresh seats'**
  String get refreshSeats;

  /// Button label for generating seats
  ///
  /// In en, this message translates to:
  /// **'Generate Seats'**
  String get generateSeats;

  /// Screen label in seat layout
  ///
  /// In en, this message translates to:
  /// **'SCREEN'**
  String get screen;

  /// Message when no seats are available
  ///
  /// In en, this message translates to:
  /// **'No seats available'**
  String get noSeatsAvailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bs':
      return AppLocalizationsBs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
