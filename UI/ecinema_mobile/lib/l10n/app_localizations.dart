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
    Locale('en'),
  ];

  /// Welcome text
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Help and support navigation item
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// About navigation item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation dialog text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Language setting text
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
  /// **'Bosnian'**
  String get bosnian;

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

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to eCinema!'**
  String get welcomeToEcinema;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Username validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a username (minimum 3 characters, letters and numbers only)'**
  String get pleaseEnterUsername;

  /// Username minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// Password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterPassword;

  /// Password minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Tickets label
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// Notifications navigation item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Profile navigation item
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Checkout screen title
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Screening details section title
  ///
  /// In en, this message translates to:
  /// **'Screening Details'**
  String get screeningDetails;

  /// Selected seats section title
  ///
  /// In en, this message translates to:
  /// **'Selected Seats'**
  String get selectedSeats;

  /// Price details section title
  ///
  /// In en, this message translates to:
  /// **'Price Details'**
  String get priceDetails;

  /// Price per seat label
  ///
  /// In en, this message translates to:
  /// **'Price per seat:'**
  String get pricePerSeat;

  /// Number of seats label
  ///
  /// In en, this message translates to:
  /// **'Number of seats:'**
  String get numberOfSeats;

  /// Payment method section title
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Cash payment option
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Stripe payment option
  ///
  /// In en, this message translates to:
  /// **'Stripe'**
  String get stripe;

  /// Pay with cash button text
  ///
  /// In en, this message translates to:
  /// **'Pay with Cash'**
  String get payWithCash;

  /// Pay with Stripe button text
  ///
  /// In en, this message translates to:
  /// **'Pay with Stripe'**
  String get payWithStripe;

  /// Reservation successful title
  ///
  /// In en, this message translates to:
  /// **'Reservation Successful!'**
  String get reservationSuccessful;

  /// Reservation successful message
  ///
  /// In en, this message translates to:
  /// **'Your reservation has been confirmed. Show this QR code at the cinema entrance.'**
  String get reservationSuccessfulMessage;

  /// Reservation details section title
  ///
  /// In en, this message translates to:
  /// **'Reservation Details'**
  String get reservationDetails;

  /// Seats plural form
  ///
  /// In en, this message translates to:
  /// **'seats'**
  String get seats;

  /// Go to home button text
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// View my reservations button text
  ///
  /// In en, this message translates to:
  /// **'View My Reservations'**
  String get viewMyReservations;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// Success login message
  ///
  /// In en, this message translates to:
  /// **'You have successfully logged in.'**
  String get successfullyLoggedIn;

  /// Tickets screen description
  ///
  /// In en, this message translates to:
  /// **'Book your movie tickets here!'**
  String get bookYourTickets;

  /// Notifications screen description
  ///
  /// In en, this message translates to:
  /// **'Stay updated with latest news!'**
  String get stayUpdated;

  /// Search movies placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search movies'**
  String get searchMovies;

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

  /// Movie suggestion banner title
  ///
  /// In en, this message translates to:
  /// **'Don\'t know what to watch?'**
  String get dontKnowWhatToWatch;

  /// Movie suggestion banner subtitle
  ///
  /// In en, this message translates to:
  /// **'Let us suggest a movie for you!'**
  String get letUsSuggestMovie;

  /// Loading movies text
  ///
  /// In en, this message translates to:
  /// **'Loading movies...'**
  String get loadingMovies;

  /// Filter section title
  ///
  /// In en, this message translates to:
  /// **'Filter by:'**
  String get filterBy;

  /// Genre filter label
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// All genres option
  ///
  /// In en, this message translates to:
  /// **'All genres'**
  String get allGenres;

  /// Action genre
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// Drama genre
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get drama;

  /// Comedy genre
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get comedy;

  /// Horror genre
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get horror;

  /// Sci-Fi genre
  ///
  /// In en, this message translates to:
  /// **'Sci-Fi'**
  String get scifi;

  /// Adventure genre
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventure;

  /// Animated genre
  ///
  /// In en, this message translates to:
  /// **'Animated'**
  String get animated;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Duration option
  ///
  /// In en, this message translates to:
  /// **'Up to 90 minutes'**
  String get upTo90Minutes;

  /// Minimum rating filter label
  ///
  /// In en, this message translates to:
  /// **'Minimum rating'**
  String get minimumRating;

  /// Suggest movie button
  ///
  /// In en, this message translates to:
  /// **'Suggest movie'**
  String get suggestMovie;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Duration option up to 60 minutes
  ///
  /// In en, this message translates to:
  /// **'Up to 60 minutes'**
  String get upTo60Minutes;

  /// Duration option up to 120 minutes
  ///
  /// In en, this message translates to:
  /// **'Up to 120 minutes'**
  String get upTo120Minutes;

  /// Duration option up to 150 minutes
  ///
  /// In en, this message translates to:
  /// **'Up to 150 minutes'**
  String get upTo150Minutes;

  /// Duration option up to 180 minutes
  ///
  /// In en, this message translates to:
  /// **'Up to 180 minutes'**
  String get upTo180Minutes;

  /// Duration option for any duration
  ///
  /// In en, this message translates to:
  /// **'Any duration'**
  String get anyDuration;

  /// Dialog title when no movies are found
  ///
  /// In en, this message translates to:
  /// **'No Movies Found'**
  String get noMoviesFound;

  /// Message when no movies match the search criteria
  ///
  /// In en, this message translates to:
  /// **'No movies found matching the criteria'**
  String get noMoviesFoundMessage;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Now showing movies section title
  ///
  /// In en, this message translates to:
  /// **'Now Showing'**
  String get nowShowing;

  /// Coming soon movies section title
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// View all movies button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Previous page button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Next page button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Pagination 'of' text
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// No movies available text
  ///
  /// In en, this message translates to:
  /// **'No movies available'**
  String get noMoviesAvailable;

  /// No image placeholder text
  ///
  /// In en, this message translates to:
  /// **'No Image'**
  String get noImage;

  /// Screenings screen title
  ///
  /// In en, this message translates to:
  /// **'Screenings'**
  String get showings;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Hall label
  ///
  /// In en, this message translates to:
  /// **'Hall'**
  String get hall;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Search screenings placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search screenings'**
  String get searchShowings;

  /// Loading screenings text
  ///
  /// In en, this message translates to:
  /// **'Loading screenings...'**
  String get loadingShowings;

  /// No screenings available text
  ///
  /// In en, this message translates to:
  /// **'No screenings available'**
  String get noShowingsAvailable;

  /// Screening times section title
  ///
  /// In en, this message translates to:
  /// **'Screening Times'**
  String get screeningTimes;

  /// No available dates text
  ///
  /// In en, this message translates to:
  /// **'No available dates'**
  String get noAvailableDates;

  /// No available screenings text
  ///
  /// In en, this message translates to:
  /// **'No available screenings'**
  String get noAvailableScreenings;

  /// No available times text
  ///
  /// In en, this message translates to:
  /// **'No available times'**
  String get noAvailableTimes;

  /// Reserve ticket button text
  ///
  /// In en, this message translates to:
  /// **'Reserve Ticket'**
  String get reserveTicket;

  /// Add to favorites button text
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// Description section title
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description available text
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescriptionAvailable;

  /// Actors section title
  ///
  /// In en, this message translates to:
  /// **'Actors'**
  String get actors;

  /// Actor information coming soon text
  ///
  /// In en, this message translates to:
  /// **'No actors found.'**
  String get actorInfoComingSoon;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'MON'**
  String get monday;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get tuesday;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get wednesday;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get thursday;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get friday;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get saturday;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get sunday;

  /// Subtitles label
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitles;

  /// Format label
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// Current language indicator
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentLanguage;

  /// Reviews section title
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews2;

  /// View all reviews button text
  ///
  /// In en, this message translates to:
  /// **'View All Reviews'**
  String get viewAllReviews;

  /// No reviews available text
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// And more reviews text
  ///
  /// In en, this message translates to:
  /// **'{count} more reviews'**
  String andMoreReviews(int count);

  /// Unknown user text
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// Today text
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

  /// Loading reviews text
  ///
  /// In en, this message translates to:
  /// **'Loading reviews...'**
  String get loadingReviews;

  /// Average rating label
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRating;

  /// Out of 5 stars text
  ///
  /// In en, this message translates to:
  /// **'out of 5'**
  String get outOf5;

  /// Total reviews label
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get totalReviews;

  /// Reviews text
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// Positive reviews label
  ///
  /// In en, this message translates to:
  /// **'Positive Reviews'**
  String get positiveReviews;

  /// 4+ stars text
  ///
  /// In en, this message translates to:
  /// **'4+ stars'**
  String get stars4Plus;

  /// No reviews message
  ///
  /// In en, this message translates to:
  /// **'Be the first to review this movie!'**
  String get noReviewsMessage;

  /// Spoiler warning text
  ///
  /// In en, this message translates to:
  /// **'SPOILER'**
  String get spoiler;

  /// Edited indicator text
  ///
  /// In en, this message translates to:
  /// **'(edited)'**
  String get edited;

  /// Spoiler content warning text
  ///
  /// In en, this message translates to:
  /// **'Spoiler content'**
  String get spoilerContent;

  /// My movie lists section title
  ///
  /// In en, this message translates to:
  /// **'My Movie Lists'**
  String get myMovieLists;

  /// Watchlist title
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlist;

  /// Watched movies title
  ///
  /// In en, this message translates to:
  /// **'Watched Movies'**
  String get watchedMovies;

  /// Favorites title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Movies text
  ///
  /// In en, this message translates to:
  /// **'movies'**
  String get movies;

  /// No description provided for @movie.
  ///
  /// In en, this message translates to:
  /// **'movie'**
  String get movie;

  /// No description provided for @movies2to4.
  ///
  /// In en, this message translates to:
  /// **'movies'**
  String get movies2to4;

  /// movie uppercase
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movieUppercase;

  /// My reservations title
  ///
  /// In en, this message translates to:
  /// **'My Reservations'**
  String get myReservations;

  /// Edit profile title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Payment methods title
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Reservations description
  ///
  /// In en, this message translates to:
  /// **'View and manage reservations'**
  String get reservationsDescription;

  /// Edit profile description
  ///
  /// In en, this message translates to:
  /// **'Change personal data'**
  String get editProfileDescription;

  /// Profile updated success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Tap to change photo instruction text
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// Change password button text
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Change password description
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get changePasswordDescription;

  /// Current password field label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm new password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Password changed success message
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// Password update screen title
  ///
  /// In en, this message translates to:
  /// **'Update Your Password'**
  String get updateYourPassword;

  /// Password update screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and choose a new one'**
  String get enterCurrentPasswordAndChooseNew;

  /// Password information section title
  ///
  /// In en, this message translates to:
  /// **'Password Information'**
  String get passwordInformation;

  /// Current password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get pleaseEnterCurrentPassword;

  /// New password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// Confirm password validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get pleaseConfirmNewPassword;

  /// Passwords do not match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Current password incorrect error message
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// User not found error message
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// Generic password change error message
  ///
  /// In en, this message translates to:
  /// **'Error changing password'**
  String get errorChangingPassword;

  /// Generic profile update error message
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorUpdatingProfile;

  /// Change profile photo dialog title
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Choose from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Payment methods description
  ///
  /// In en, this message translates to:
  /// **'Manage credit cards'**
  String get paymentMethodsDescription;

  /// Language description
  ///
  /// In en, this message translates to:
  /// **'Change application language'**
  String get languageDescription;

  /// Theme description
  ///
  /// In en, this message translates to:
  /// **'Change application theme'**
  String get themeDescription;

  /// Logout description
  ///
  /// In en, this message translates to:
  /// **'Sign out of application'**
  String get logoutDescription;

  /// Featured section title
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// Latest news section title
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get latestNews;

  /// Event type label
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// Promotion label
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotion;

  /// News type label
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// Read more link text
  ///
  /// In en, this message translates to:
  /// **'Read more →'**
  String get readMore;

  /// Film marathon event title
  ///
  /// In en, this message translates to:
  /// **'Film Marathon: Christopher Nolan\'s Night'**
  String get filmMarathon;

  /// Film marathon event description
  ///
  /// In en, this message translates to:
  /// **'Join us for an exclusive film marathon dedicated to director Christopher Nolan. Watch his most acclaimed films in one night with special benefits for visitors.'**
  String get filmMarathonDescription;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Movie announcements filter option
  ///
  /// In en, this message translates to:
  /// **'Movie Announcements'**
  String get movieAnnouncements;

  /// Promotions filter option
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotions;

  /// Events filter option
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// Loading notifications text
  ///
  /// In en, this message translates to:
  /// **'Loading notifications...'**
  String get loadingNotifications;

  /// Error loading data title
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// Error loading data message
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoadingDataMessage(String error);

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Discount label
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Valid from label
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get validFrom;

  /// Valid to label
  ///
  /// In en, this message translates to:
  /// **'Valid to'**
  String get validTo;

  /// Message about using promotion code
  ///
  /// In en, this message translates to:
  /// **'Use the code when booking a ticket to get a discount.'**
  String get useCodeMessage;

  /// Code label
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// Tap to view details text
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get tapToViewDetails;

  /// Add to watchlist button text
  ///
  /// In en, this message translates to:
  /// **'Add to Watchlist'**
  String get addToWatchlist;

  /// Release date label
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// January month name
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// February month name
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// March month name
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// April month name
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// May month name
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// June month name
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// July month name
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// August month name
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// September month name
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// October month name
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// November month name
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// December month name
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Invalid credentials error message
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidCredentials;

  /// Don't have account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Create account title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Join eCinema today message
  ///
  /// In en, this message translates to:
  /// **'Join eCinema today!'**
  String get joinEcinemaToday;

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

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// First name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterFirstName;

  /// Last name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterLastName;

  /// Email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Confirm password validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// Account created successfully message
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Please login.'**
  String get accountCreatedSuccessfully;

  /// Failed to create account message
  ///
  /// In en, this message translates to:
  /// **'Failed to create account. Please try again.'**
  String get failedToCreateAccount;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Success dialog title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Movie removed from list success message
  ///
  /// In en, this message translates to:
  /// **'Movie removed from {listName}'**
  String movieRemovedFromList(String listName);

  /// Error removing movie message
  ///
  /// In en, this message translates to:
  /// **'Error removing movie: {error}'**
  String errorRemovingMovie(String error);

  /// Remove movie dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove Movie'**
  String get removeMovie;

  /// Remove movie confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{movieTitle}\" from {listName}?'**
  String removeMovieConfirmation(String movieTitle, String listName);

  /// Remove button text
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Error loading movies message
  ///
  /// In en, this message translates to:
  /// **'Error loading movies'**
  String get errorLoadingMovies;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Director label
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get director;

  /// Year label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// Remove from list tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove from {listName}'**
  String removeFromList(String listName);

  /// Empty watchlist message
  ///
  /// In en, this message translates to:
  /// **'No movies in your watchlist yet'**
  String get noMoviesInWatchlist;

  /// Empty favorites message
  ///
  /// In en, this message translates to:
  /// **'No favorite movies yet'**
  String get noFavoriteMovies;

  /// Empty watched movies message
  ///
  /// In en, this message translates to:
  /// **'No watched movies yet'**
  String get noWatchedMovies;

  /// Generic empty list message
  ///
  /// In en, this message translates to:
  /// **'No movies in this list yet'**
  String get noMoviesInList;

  /// Added to watchlist success message
  ///
  /// In en, this message translates to:
  /// **'Added to watchlist'**
  String get addedToWatchlist;

  /// Removed from watchlist success message
  ///
  /// In en, this message translates to:
  /// **'Removed from watchlist'**
  String get removedFromWatchlist;

  /// Added to favorites success message
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// Removed from favorites success message
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// Remove from watchlist button text
  ///
  /// In en, this message translates to:
  /// **'Remove from Watchlist'**
  String get removeFromWatchlist;

  /// Remove from favorites button text
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// Error updating watchlist message
  ///
  /// In en, this message translates to:
  /// **'Error updating watchlist'**
  String get errorUpdatingWatchlist;

  /// Error updating favorites message
  ///
  /// In en, this message translates to:
  /// **'Error updating favorites'**
  String get errorUpdatingFavorites;

  /// Unknown title placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Title'**
  String get unknownTitle;

  /// Unknown placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Unknown director placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Director'**
  String get unknownDirector;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// To be announced abbreviation
  ///
  /// In en, this message translates to:
  /// **'TBA'**
  String get tba;

  /// Unauthorized error message
  ///
  /// In en, this message translates to:
  /// **'Unauthorized - please login again'**
  String get unauthorizedPleaseLoginAgain;

  /// Email already exists error message
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get emailAlreadyExists;

  /// Username already exists error message
  ///
  /// In en, this message translates to:
  /// **'Username already exists'**
  String get usernameAlreadyExists;

  /// Remove photo option
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// Show more button text
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Mobile access restriction message
  ///
  /// In en, this message translates to:
  /// **'Only users with user or staff role can access the mobile application.'**
  String get mobileAccessRestricted;

  /// Select seat section title
  ///
  /// In en, this message translates to:
  /// **'Select Seat'**
  String get selectSeat;

  /// Confirm reservation button text
  ///
  /// In en, this message translates to:
  /// **'Confirm Reservation'**
  String get confirmReservation;

  /// No available seats message
  ///
  /// In en, this message translates to:
  /// **'No available seats'**
  String get noAvailableSeats;

  /// Please select screening time message
  ///
  /// In en, this message translates to:
  /// **'Please select a screening time first'**
  String get pleaseSelectScreening;

  /// Currency symbol
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get currency;

  /// Upcoming tab text
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// Past tab text
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No upcoming reservations message
  ///
  /// In en, this message translates to:
  /// **'No upcoming reservations'**
  String get noUpcomingReservations;

  /// No past reservations message
  ///
  /// In en, this message translates to:
  /// **'No past reservations'**
  String get noPastReservations;

  /// No description provided for @seatsUppercase.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seatsUppercase;

  /// Seat singular form
  ///
  /// In en, this message translates to:
  /// **'seat'**
  String get seat;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Total price label
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// Payment label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Payment status label
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Reservation ID label
  ///
  /// In en, this message translates to:
  /// **'Reservation ID'**
  String get reservationId;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Yes, Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// Not available text
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Details button text
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Cancel reservation dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Reservation'**
  String get cancelReservation;

  /// Cancel reservation confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your reservation for {movieTitle}?'**
  String cancelReservationConfirmation(String movieTitle);

  /// Reservation cancelled success message
  ///
  /// In en, this message translates to:
  /// **'Reservation cancelled successfully'**
  String get reservationCancelledSuccessfully;

  /// Error loading reservations message
  ///
  /// In en, this message translates to:
  /// **'Error loading reservations'**
  String get errorLoadingReservations;

  /// Error loading QR code message
  ///
  /// In en, this message translates to:
  /// **'Error loading QR code'**
  String get errorLoadingQRCode;

  /// No QR code available message
  ///
  /// In en, this message translates to:
  /// **'No QR code available'**
  String get noQRCodeAvailable;

  /// Error decoding QR code message
  ///
  /// In en, this message translates to:
  /// **'Error decoding QR code'**
  String get errorDecodingQRCode;

  /// Seats generated successfully message
  ///
  /// In en, this message translates to:
  /// **'Seats generated successfully!'**
  String get seatsGeneratedSuccessfully;

  /// Error generating seats message
  ///
  /// In en, this message translates to:
  /// **'Error generating seats'**
  String get errorGeneratingSeats;

  /// Please select at least one seat message
  ///
  /// In en, this message translates to:
  /// **'Please select at least one seat'**
  String get pleaseSelectAtLeastOneSeat;

  /// Price summary section title
  ///
  /// In en, this message translates to:
  /// **'Price Summary'**
  String get priceSummary;

  /// Available seats label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Selected seats label
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// Reserved seats label
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reserved;

  /// Error creating reservation message
  ///
  /// In en, this message translates to:
  /// **'Error creating reservation'**
  String get errorCreatingReservation;

  /// Stripe integration coming soon message
  ///
  /// In en, this message translates to:
  /// **'Stripe integration coming soon!'**
  String get stripeIntegrationComingSoon;

  /// Generate seats for hall button text
  ///
  /// In en, this message translates to:
  /// **'Generate Seats for Hall'**
  String get generateSeatsForHall;

  /// Error loading screening message
  ///
  /// In en, this message translates to:
  /// **'Error loading screening'**
  String get errorLoadingScreening;

  /// Error loading seats message
  ///
  /// In en, this message translates to:
  /// **'Error loading seats'**
  String get errorLoadingSeats;

  /// Coming soon movies can only be added to watchlist
  ///
  /// In en, this message translates to:
  /// **'Coming soon movies can only be added to watchlist'**
  String get comingSoonWatchlistOnly;

  /// Approved reservation status
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get reservationApproved;

  /// Used reservation status
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get reservationUsed;

  /// Cancelled reservation status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get reservationCancelled;

  /// Rejected reservation status
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get reservationRejected;

  /// Expired reservation status
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get reservationExpired;

  /// Pending reservation status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reservationPending;

  /// Initial reservation status
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get reservationInitial;

  /// Cancellation deadline info with date
  ///
  /// In en, this message translates to:
  /// **'You can cancel your reservation until {date} at 23:59h. After this deadline, cancellation is not possible and no refund will be provided.'**
  String cancellationDeadlineInfo(String date);

  /// Confirm cancellation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this reservation?'**
  String get confirmCancellation;

  /// Confirm cancellation title
  ///
  /// In en, this message translates to:
  /// **'Cancel Reservation'**
  String get confirmCancellationTitle;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Error message when user tries to make duplicate reservation
  ///
  /// In en, this message translates to:
  /// **'You already have a reservation for this screening'**
  String get existingReservationError;

  /// Error message when trying to cancel a used ticket
  ///
  /// In en, this message translates to:
  /// **'Cannot cancel a used ticket'**
  String get cannotCancelUsedTicket;

  /// Message shown when user cancels payment
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get paymentCancelled;

  /// Publish date label
  ///
  /// In en, this message translates to:
  /// **'Publish date'**
  String get publishDate;

  /// Event date label
  ///
  /// In en, this message translates to:
  /// **'Event date'**
  String get eventDate;

  /// Text shown to expand promo code input
  ///
  /// In en, this message translates to:
  /// **'Have a promo code?'**
  String get havePromoCode;

  /// Placeholder text for promo code input
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get enterPromoCode;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Message shown when discount is applied
  ///
  /// In en, this message translates to:
  /// **'Discount applied: -\${amount}'**
  String discountApplied(String amount);

  /// Error message shown when promo code is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code'**
  String get invalidPromoCode;

  /// Error message shown when promo code has already been used
  ///
  /// In en, this message translates to:
  /// **'You have already used this promotion code'**
  String get promoCodeAlreadyUsed;

  /// Review prompt title
  ///
  /// In en, this message translates to:
  /// **'How was {movieTitle}?'**
  String howWasTheMovie(String movieTitle);

  /// Review prompt placeholder
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts about the movie...'**
  String get shareYourThoughts;

  /// Spoiler warning checkbox label
  ///
  /// In en, this message translates to:
  /// **'Contains spoilers'**
  String get containsSpoilers;

  /// Submit review button text
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// Rating validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get pleaseSelectRating;

  /// Review submission error message
  ///
  /// In en, this message translates to:
  /// **'Error submitting review'**
  String get errorSubmittingReview;

  /// Review submission success message
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully'**
  String get reviewSubmittedSuccessfully;

  /// Recommended movies section title
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get recommendedForYou;

  /// No recommended movies message
  ///
  /// In en, this message translates to:
  /// **'No recommended movies yet'**
  String get noRecommendedMovies;

  /// Username format requirements
  ///
  /// In en, this message translates to:
  /// **'Username must be 3-20 characters long\nand can only contain letters, numbers, and underscores'**
  String get usernameFormat;

  /// Password format requirements
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordFormat;

  /// Email format requirements
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailFormat;

  /// Phone number format requirements
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number (e.g. +387 61 123 456)'**
  String get phoneFormat;

  /// Review minimum length requirement
  ///
  /// In en, this message translates to:
  /// **'Review must be at least 10 characters long'**
  String get reviewMinLength;

  /// No description provided for @firstNameLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'First name can only contain letters'**
  String get firstNameLettersOnly;

  /// No description provided for @lastNameLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'Last name can only contain letters'**
  String get lastNameLettersOnly;
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
    'that was used.',
  );
}
