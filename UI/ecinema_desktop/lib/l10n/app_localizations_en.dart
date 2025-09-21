// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get movies => 'Movies';

  @override
  String get screenings => 'Screenings';

  @override
  String get seatsHalls => 'Seats & Halls';

  @override
  String get seats => 'Seats';

  @override
  String get news => 'News';

  @override
  String get users => 'Users';

  @override
  String get reviews => 'Reviews';

  @override
  String get reports => 'Reports';

  @override
  String get downloadReport => 'Download Report';

  @override
  String get keyMetrics => 'Key Metrics';

  @override
  String get date => 'Date';

  @override
  String get reservationCount => 'Reservation Count';

  @override
  String get occupancyRate => 'Occupancy Rate';

  @override
  String get reportsDescription =>
      'Track your cinema\'s performance with automatically generated reports to make informed business decisions.';

  @override
  String get totalTicketsSold => 'Total Tickets Sold';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get averageOccupancy => 'Average Occupancy';

  @override
  String get chartComingSoon => 'Chart visualization coming soon';

  @override
  String get dateRange => 'Date Range';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get custom => 'Custom';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get ticketSales => 'Ticket Sales';

  @override
  String get totalSeats => 'Total seats';

  @override
  String get reservedSeats => 'Reserved seats';

  @override
  String get availableSeats => 'Available seats';

  @override
  String get averageTicketPrice => 'Average Ticket Price';

  @override
  String get screeningAttendance => 'Screening Attendance';

  @override
  String get revenueByMovieHall => 'Revenue by Movie/Hall';

  @override
  String get filters => 'Filters';

  @override
  String get allMovies => 'All Movies';

  @override
  String get allHalls => 'All Halls';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get back => 'Back';

  @override
  String get search => 'Search';

  @override
  String get addMovie => 'Add Movie';

  @override
  String get movieManagement => 'Movie Management';

  @override
  String get manageYourMovieCatalog => 'Manage your movie catalog';

  @override
  String get noMoviesFound => 'No movies found';

  @override
  String get noMoviesMatchSearch => 'No movies match your search';

  @override
  String get readyToRelease => 'Ready to Release';

  @override
  String get releasesToday => 'Releases Today';

  @override
  String releasesInDays(int days) {
    return 'Releases in $days days';
  }

  @override
  String get clearSearch => 'Clear search';

  @override
  String get id => 'ID';

  @override
  String get title => 'Title';

  @override
  String get director => 'Director';

  @override
  String get genre => 'Genre';

  @override
  String get duration => 'Duration';

  @override
  String get grade => 'Grade';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get actions => 'Actions';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get minDuration => 'Min Duration';

  @override
  String get maxDuration => 'Max Duration';

  @override
  String get minGrade => 'Min Grade';

  @override
  String get maxGrade => 'Max Grade';

  @override
  String get releaseYear => 'Release Year';

  @override
  String get reset => 'Reset';

  @override
  String get close => 'Close';

  @override
  String get apply => 'Apply';

  @override
  String get noData => 'No data';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get bosnian => 'Bosanski';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Login';

  @override
  String get pleaseEnterUsername => 'Please enter your username';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get ok => 'OK';

  @override
  String get edited => '(edited)';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get movieReviews => 'Movie Reviews';

  @override
  String get averageRating => 'Average Rating';

  @override
  String get totalReviews => 'Total Reviews';

  @override
  String get positiveReviews => 'Positive Reviews';

  @override
  String get outOf5 => 'out of 5.0';

  @override
  String get reviews2 => 'Reviews';

  @override
  String get stars4Plus => '4+ stars';

  @override
  String get loadingReviews => 'Loading reviews...';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get noReviewsMessage => 'This movie hasn\'t received any reviews yet.';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get deleteReview => 'Delete Review';

  @override
  String deleteReviewConfirmation(String username) {
    return 'Are you sure you want to delete the review left by user $username?';
  }

  @override
  String get reviewDeletedSuccessfully => 'Review deleted successfully';

  @override
  String errorDeletingReview(String error) {
    return 'Error deleting review: $error';
  }

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get ofText => 'of';

  @override
  String get movieDetails => 'Movie Details';

  @override
  String get loadingMovieDetails => 'Loading movie details...';

  @override
  String get noImage => 'No Image';

  @override
  String get editMovie => 'Edit Movie';

  @override
  String get deleteMovie => 'Delete Movie';

  @override
  String get unknownTitle => 'Unknown Title';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get minutes => 'minutes';

  @override
  String get releaseDate => 'Release Date';

  @override
  String get genres => 'Genres';

  @override
  String get actors => 'Actors';

  @override
  String get trailer => 'Trailer';

  @override
  String get description => 'Description';

  @override
  String get unknown => 'Unknown';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get noGenresAssigned => 'No genres assigned';

  @override
  String get noActorsAssigned => 'No actors assigned';

  @override
  String get beFirstToReview => 'Be the first to review this movie!';

  @override
  String get viewAllReviews => 'View All Reviews';

  @override
  String andMoreReviews(int count) {
    return '... and $count more reviews';
  }

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String confirmDeleteMovie(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get movieDeletedSuccessfully => 'Movie deleted successfully';

  @override
  String get restoreMovie => 'Restore Movie';

  @override
  String get movieRestoredSuccessfully => 'Movie restored successfully';

  @override
  String get failedToRestoreMovie => 'Failed to restore movie';

  @override
  String get confirmRestoration => 'Confirm Restoration';

  @override
  String confirmRestoreMovie(String title) {
    return 'Are you sure you want to restore the movie \"$title\"?';
  }

  @override
  String get restore => 'Restore';

  @override
  String get failedToDeleteMovie => 'Failed to delete movie';

  @override
  String get genreIds => 'Genre IDs (e.g., 1,2,3)';

  @override
  String get genreIdsHint => 'Enter genre IDs separated by commas';

  @override
  String get isActive => 'Is Active';

  @override
  String get loadingMovies => 'Loading movies...';

  @override
  String get noMoviesLoaded => 'No movies loaded';

  @override
  String get tryAdjustingSearch => 'Try adjusting your search criteria';

  @override
  String get unknownDirector => 'Unknown Director';

  @override
  String get durationMinutes => 'Duration (minutes)';

  @override
  String get actor => 'Actor';

  @override
  String get trailerUrl => 'Trailer URL';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get movieStatus => 'Movie Status';

  @override
  String get updateMovie => 'Update Movie';

  @override
  String errorSavingMovie(String error) {
    return 'Error saving movie: $error';
  }

  @override
  String get addScreening => 'Add Screening';

  @override
  String get loadingScreenings => 'Loading screenings...';

  @override
  String get noScreeningsLoaded => 'No screenings loaded';

  @override
  String get noScreeningsFound => 'No screenings found';

  @override
  String get movieId => 'Movie ID';

  @override
  String get movieTitle => 'Movie Title';

  @override
  String get hallId => 'Hall ID';

  @override
  String get screeningFormatId => 'Screening Format ID';

  @override
  String get minBasePrice => 'Min Base Price';

  @override
  String get maxBasePrice => 'Max Base Price';

  @override
  String get fromStartTime => 'From Start Time (YYYY-MM-DD)';

  @override
  String get toStartTime => 'To Start Time (YYYY-MM-DD)';

  @override
  String get hasSubtitles => 'Has Subtitles';

  @override
  String get hasAvailableSeats => 'Has Available Seats';

  @override
  String get includeDeleted => 'Include Deleted';

  @override
  String get screeningDeletedSuccessfully => 'Screening deleted successfully';

  @override
  String get screeningRestoredSuccessfully => 'Screening restored successfully';

  @override
  String get failedToDeleteScreening => 'Failed to delete screening';

  @override
  String get failedToRestoreScreening => 'Failed to restore screening';

  @override
  String confirmDeleteScreeningMessage(String movieTitle) {
    return 'Are you sure you want to delete the screening for \"$movieTitle\"?';
  }

  @override
  String confirmRestoreScreeningMessage(String movieTitle) {
    return 'Are you sure you want to restore the screening for \"$movieTitle\"?';
  }

  @override
  String get unknownMovie => 'Unknown Movie';

  @override
  String get unknownHall => 'Unknown Hall';

  @override
  String get deleted => 'Deleted';

  @override
  String get screening => 'Screening';

  @override
  String get screeningUpdatedSuccessfully => 'Screening updated successfully';

  @override
  String get screeningCreatedSuccessfully => 'Screening created successfully';

  @override
  String get failedToSaveScreening => 'Failed to save screening';

  @override
  String get editScreening => 'Edit Screening';

  @override
  String get movie => 'Movie';

  @override
  String get hall => 'Hall';

  @override
  String get screeningFormatOptional => 'Screening Format (Optional)';

  @override
  String get none => 'None';

  @override
  String get noFormat => 'No Format';

  @override
  String get basePrice => 'Base Price';

  @override
  String get startTime => 'Start Time (YYYY-MM-DDTHH:MM:SS)';

  @override
  String get endTime => 'End Time (YYYY-MM-DDTHH:MM:SS)';

  @override
  String get update => 'Update';

  @override
  String get create => 'Create';

  @override
  String get pleaseSelectMovie => 'Please select a movie';

  @override
  String get pleaseSelectHall => 'Please select a hall';

  @override
  String get pleaseEnterLanguage => 'Please enter language';

  @override
  String get pleaseEnterBasePrice => 'Please enter base price';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get pleaseEnterStartTime => 'Please enter start time';

  @override
  String get pleaseEnterEndTime => 'Please enter end time';

  @override
  String get unknownFormat => 'Unknown Format';

  @override
  String get adminProfile => 'Admin Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get role => 'Role';

  @override
  String get lastLogin => 'Last Login';

  @override
  String get contentManagement => 'Content Management';

  @override
  String get systemManagement => 'System Management';

  @override
  String get screeningFormats => 'Screening Formats';

  @override
  String get halls => 'Halls';

  @override
  String get roles => 'Roles';

  @override
  String get newsArticles => 'News Articles';

  @override
  String get promotions => 'Promotions';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get manageYourApplicationPreferences =>
      'Manage your application preferences and system configuration';

  @override
  String get manageMovieGenres => 'Manage movie genres and categories';

  @override
  String get manageActors => 'Manage Actors';

  @override
  String get manageScreeningFormats => 'Manage 3D, IMAX, and other formats';

  @override
  String get manageHalls => 'Manage cinema halls';

  @override
  String get manageSeats => 'Manage seat templates and layouts';

  @override
  String get maxSeatsReached => 'Maximum number of seats (48) has been reached';

  @override
  String get manageUsers => 'Manage system users and permissions';

  @override
  String get manageRoles => 'Manage user roles and access levels';

  @override
  String get manageNewsArticles => 'Manage news and announcements';

  @override
  String get managePromotions => 'Manage promotional offers and discounts';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get genresList => 'Genres List';

  @override
  String get manageGenres => 'Manage Genres';

  @override
  String get noGenresFound => 'No genres found';

  @override
  String get noGenresMatchSearch => 'No genres match your search';

  @override
  String get loadingGenres => 'Loading genres...';

  @override
  String get noGenresLoaded => 'No genres loaded';

  @override
  String get addGenre => 'Add Genre';

  @override
  String get editGenre => 'Edit Genre';

  @override
  String get deleteGenre => 'Delete Genre';

  @override
  String get genreName => 'Genre Name';

  @override
  String get genreDescription => 'Genre Description';

  @override
  String get pleaseEnterGenreName => 'Please enter genre name';

  @override
  String get pleaseEnterGenreDescription => 'Please enter genre description';

  @override
  String get genreCreatedSuccessfully => 'Genre created successfully';

  @override
  String get genreUpdatedSuccessfully => 'Genre updated successfully';

  @override
  String get genreDeletedSuccessfully => 'Genre deleted successfully';

  @override
  String get genreRestoredSuccessfully => 'Genre restored successfully';

  @override
  String get failedToSaveGenre => 'Failed to save genre';

  @override
  String get failedToDeleteGenre => 'Failed to delete genre';

  @override
  String get failedToRestoreGenre => 'Failed to restore genre';

  @override
  String confirmDeleteGenre(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String confirmRestoreGenre(String name) {
    return 'Are you sure you want to restore the genre \"$name\"?';
  }

  @override
  String get unnamedGenre => 'Unnamed Genre';

  @override
  String get actorsList => 'Actors List';

  @override
  String get noActorsFound => 'No actors found';

  @override
  String get noActorsMatchSearch => 'No actors match your search';

  @override
  String get loadingActors => 'Loading actors...';

  @override
  String get noActorsLoaded => 'No actors loaded';

  @override
  String get addActor => 'Add Actor';

  @override
  String get editActor => 'Edit Actor';

  @override
  String get deleteActor => 'Delete Actor';

  @override
  String get actorFirstName => 'First Name';

  @override
  String get actorLastName => 'Last Name';

  @override
  String get actorBiography => 'Biography';

  @override
  String get pleaseEnterActorFirstName => 'Please enter first name';

  @override
  String get pleaseEnterActorLastName => 'Please enter last name';

  @override
  String get pleaseEnterActorBiography => 'Please enter biography';

  @override
  String get actorCreatedSuccessfully => 'Actor created successfully';

  @override
  String get actorUpdatedSuccessfully => 'Actor updated successfully';

  @override
  String get actorDeletedSuccessfully => 'Actor deleted successfully';

  @override
  String get actorRestoredSuccessfully => 'Actor restored successfully';

  @override
  String get failedToSaveActor => 'Failed to save actor';

  @override
  String get failedToDeleteActor => 'Failed to delete actor';

  @override
  String get failedToRestoreActor => 'Failed to restore actor';

  @override
  String confirmDeleteActor(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String confirmRestoreActor(String name) {
    return 'Are you sure you want to restore the actor \"$name\"?';
  }

  @override
  String get unnamedActor => 'Unnamed Actor';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get addScreeningFormat => 'Add Screening Format';

  @override
  String get editScreeningFormat => 'Edit Screening Format';

  @override
  String get deleteScreeningFormat => 'Delete Screening Format';

  @override
  String get screeningFormatName => 'Screening Format Name';

  @override
  String get screeningFormatDescription => 'Screening Format Description';

  @override
  String get pleaseEnterScreeningFormatName =>
      'Please enter screening format name';

  @override
  String get pleaseEnterScreeningFormatDescription =>
      'Please enter screening format description';

  @override
  String get priceMultiplier => 'Price Multiplier';

  @override
  String get pleaseEnterPriceMultiplier => 'Please enter price multiplier';

  @override
  String get screeningFormatCreatedSuccessfully =>
      'Screening format created successfully';

  @override
  String get screeningFormatUpdatedSuccessfully =>
      'Screening format updated successfully';

  @override
  String get screeningFormatDeletedSuccessfully =>
      'Screening format deleted successfully';

  @override
  String get screeningFormatRestoredSuccessfully =>
      'Screening format restored successfully';

  @override
  String get failedToSaveScreeningFormat => 'Failed to save screening format';

  @override
  String get failedToDeleteScreeningFormat =>
      'Failed to delete screening format';

  @override
  String get failedToRestoreScreeningFormat =>
      'Failed to restore screening format';

  @override
  String confirmDeleteScreeningFormat(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String confirmRestoreScreeningFormat(String name) {
    return 'Are you sure you want to restore the screening format \"$name\"?';
  }

  @override
  String get unnamedScreeningFormat => 'Unnamed Screening Format';

  @override
  String get loadingScreeningFormats => 'Loading screening formats...';

  @override
  String get noScreeningFormatsLoaded => 'No screening formats loaded';

  @override
  String get noScreeningFormatsFound => 'No screening formats found';

  @override
  String get editScreeningFormatScreenComingSoon =>
      'Edit screening format screen - Coming soon';

  @override
  String get hallsAndSeats => 'Halls';

  @override
  String get managementSystem => 'Management System';

  @override
  String get loadingHalls => 'Loading halls...';

  @override
  String get noHallsLoaded => 'No halls loaded';

  @override
  String get noHallsFound => 'No halls found';

  @override
  String get capacity => 'Capacity';

  @override
  String get unnamedHall => 'Unnamed Hall';

  @override
  String get deleteHall => 'Delete Hall';

  @override
  String confirmDeleteHall(Object hallName) {
    return 'Are you sure you want to delete the hall \"$hallName\"?';
  }

  @override
  String get hallDeletedSuccessfully => 'Hall deleted successfully';

  @override
  String get failedToDeleteHall => 'Failed to delete hall';

  @override
  String confirmRestoreHall(Object hallName) {
    return 'Are you sure you want to restore the hall \"$hallName\"?';
  }

  @override
  String get hallRestoredSuccessfully => 'Hall restored successfully';

  @override
  String get failedToRestoreHall => 'Failed to restore hall';

  @override
  String get editHallScreenComingSoon => 'Edit hall screen - Coming soon';

  @override
  String get addHall => 'Add Hall';

  @override
  String get editHall => 'Edit Hall';

  @override
  String get addNewHall => 'Add New Hall';

  @override
  String get hallName => 'Hall Name';

  @override
  String get hallLocation => 'Hall Location';

  @override
  String get hallCapacity => 'Hall Capacity';

  @override
  String get hallScreenType => 'Screen Type';

  @override
  String get hallSoundSystem => 'Sound System';

  @override
  String get pleaseEnterHallName => 'Please enter hall name';

  @override
  String get pleaseEnterHallLocation => 'Please enter hall location';

  @override
  String get pleaseEnterHallCapacity => 'Please enter hall capacity';

  @override
  String get pleaseEnterHallScreenType => 'Please enter screen type';

  @override
  String get pleaseEnterHallSoundSystem => 'Please enter sound system';

  @override
  String get hallSavedSuccessfully => 'Hall saved successfully';

  @override
  String get failedToSaveHall => 'Failed to save hall';

  @override
  String get editHallDescription => 'Update hall information and settings';

  @override
  String get addNewHallDescription =>
      'Create a new hall with required information';

  @override
  String get capacityMustBeAtLeastOne => 'Capacity must be at least 1';

  @override
  String get screenTypeHint => 'e.g., Regular, IMAX, 3D';

  @override
  String get soundSystemHint => 'e.g., Dolby Digital, SDDS';

  @override
  String get saving => 'Saving...';

  @override
  String get save => 'Save';

  @override
  String get editNewsArticle => 'Edit News Article';

  @override
  String get addNewsArticle => 'Add News Article';

  @override
  String get updateNewsArticle => 'Update News Article';

  @override
  String get content => 'Content';

  @override
  String get publishDate => 'Publish Date';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get pleaseEnterContent => 'Please enter content';

  @override
  String get titleTooLong => 'Title must be less than 100 characters';

  @override
  String get newsArticleCreatedSuccessfully =>
      'News article created successfully';

  @override
  String get newsArticleUpdatedSuccessfully =>
      'News article updated successfully';

  @override
  String get failedToSaveNewsArticle => 'Failed to save news article';

  @override
  String get deleteNewsArticle => 'Delete News Article';

  @override
  String confirmDeleteNewsArticle(String title) {
    return 'Are you sure you want to delete news article \"$title\"?';
  }

  @override
  String get newsArticleDeletedSuccessfully =>
      'News article deleted successfully';

  @override
  String get failedToDeleteNewsArticle => 'Failed to delete news article';

  @override
  String get restoreNewsArticle => 'Restore News Article';

  @override
  String confirmRestoreNewsArticle(String title) {
    return 'Are you sure you want to restore news article \"$title\"?';
  }

  @override
  String get newsArticleRestoredSuccessfully =>
      'News article restored successfully';

  @override
  String get failedToRestoreNewsArticle => 'Failed to restore news article';

  @override
  String get addNews => 'Add News';

  @override
  String get loadingNewsArticles => 'Loading news articles...';

  @override
  String get noNewsArticlesLoaded => 'No news articles loaded';

  @override
  String get noNewsArticlesFound => 'No news articles found';

  @override
  String get tryAdjustingSearchCriteria => 'Try adjusting your search criteria';

  @override
  String get fromPublishDate => 'From Publish Date';

  @override
  String get toPublishDate => 'To Publish Date';

  @override
  String get selectDate => 'Select Date';

  @override
  String get noContent => 'No content';

  @override
  String get makeArticleVisible => 'Make this article visible';

  @override
  String get editPromotion => 'Edit Promotion';

  @override
  String get addPromotion => 'Add Promotion';

  @override
  String get updatePromotion => 'Update Promotion';

  @override
  String get code => 'Code';

  @override
  String get discountPercentage => 'Discount Percentage';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get pleaseEnterDescription => 'Please enter description';

  @override
  String get pleaseEnterCode => 'Please enter code';

  @override
  String get pleaseEnterDiscountPercentage =>
      'Please enter discount percentage (0-100)';

  @override
  String get pleaseEnterStartDate => 'Please enter start date';

  @override
  String get pleaseEnterEndDate => 'Please enter end date';

  @override
  String get nameTooLong => 'Name must be less than 100 characters';

  @override
  String get descriptionTooLong =>
      'Description must be less than 500 characters';

  @override
  String get codeTooLong => 'Code must be less than 20 characters';

  @override
  String get discountPercentageInvalid =>
      'Discount percentage must be between 0 and 100';

  @override
  String get endDateMustBeAfterStartDate => 'End time must be after start time';

  @override
  String get endTimeMustBeAfterStartTime => 'End time must be after start time';

  @override
  String get promotionCreatedSuccessfully => 'Promotion created successfully';

  @override
  String get promotionUpdatedSuccessfully => 'Promotion updated successfully';

  @override
  String get failedToSavePromotion => 'Failed to save promotion';

  @override
  String get deletePromotion => 'Delete Promotion';

  @override
  String confirmDeletePromotion(String name) {
    return 'Are you sure you want to delete promotion \"$name\"?';
  }

  @override
  String get promotionDeletedSuccessfully => 'Promotion deleted successfully';

  @override
  String get failedToDeletePromotion => 'Failed to delete promotion';

  @override
  String get restorePromotion => 'Restore Promotion';

  @override
  String confirmRestorePromotion(String name) {
    return 'Are you sure you want to restore promotion \"$name\"?';
  }

  @override
  String get promotionRestoredSuccessfully => 'Promotion restored successfully';

  @override
  String get failedToRestorePromotion => 'Failed to restore promotion';

  @override
  String get loadingPromotions => 'Loading promotions...';

  @override
  String get noPromotionsLoaded => 'No promotions loaded';

  @override
  String get noPromotionsFound => 'No promotions found';

  @override
  String get fromStartDate => 'From Start Date';

  @override
  String get toStartDate => 'To Start Date';

  @override
  String get fromEndDate => 'From End Date';

  @override
  String get toEndDate => 'To End Date';

  @override
  String get minDiscount => 'Min Discount';

  @override
  String get maxDiscount => 'Max Discount';

  @override
  String get noDescription => 'No description';

  @override
  String get makePromotionVisible => 'Make this promotion visible';

  @override
  String get deleteUser => 'Delete User';

  @override
  String confirmDeleteUser(String userName) {
    return 'Are you sure you want to delete user $userName?';
  }

  @override
  String get userDeletedSuccessfully => 'User deleted successfully';

  @override
  String get failedToDeleteUser => 'Failed to delete user';

  @override
  String get restoreUser => 'Restore User';

  @override
  String confirmRestoreUser(String userName) {
    return 'Are you sure you want to restore user $userName?';
  }

  @override
  String get userRestoredSuccessfully => 'User restored successfully';

  @override
  String get failedToRestoreUser => 'Failed to restore user';

  @override
  String get loadingUsers => 'Loading users...';

  @override
  String get noUsersLoaded => 'No users loaded';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get admin => 'Admin';

  @override
  String get totalMovies => 'Total Movies';

  @override
  String get totalActors => 'Total Actors';

  @override
  String get totalGenres => 'Total Genres';

  @override
  String get totalUsers => 'Total Users';

  @override
  String get totalHalls => 'Total Halls';

  @override
  String get totalShows => 'Total projections';

  @override
  String get totalReservations => 'Total Reservations';

  @override
  String get activeShows => 'Active Screenings';

  @override
  String get todayScreenings => 'Today\'s Screenings';

  @override
  String get inCatalog => 'In catalog';

  @override
  String get registered => 'Registered';

  @override
  String get allTime => 'All time';

  @override
  String get welcomeToECinema => 'Welcome to eCinema Management System';

  @override
  String get moviePoster => 'Movie Poster';

  @override
  String get selectMovie => 'Select movie';

  @override
  String get heresWhatHappening =>
      'Here\'s what\'s happening with your cinema today';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get markAsSpoiler => 'Mark as Spoiler';

  @override
  String get unmarkAsSpoiler => 'Unmark as Spoiler';

  @override
  String get reviewMarkedAsSpoiler => 'Review marked as spoiler';

  @override
  String get reviewUnmarkedAsSpoiler => 'Review unmarked as spoiler';

  @override
  String get failedToUpdateReview => 'Failed to update review';

  @override
  String get cinemaReports => 'Cinema Reports';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get top5WatchedMovies => 'Top 5 Watched Movies';

  @override
  String get revenueByMovie => 'Revenue by Movie';

  @override
  String get top5Customers => 'Top 5 Customers';

  @override
  String get revenue => 'Revenue';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get refresh => 'Refresh';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get reservations => 'Reservations';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get dontHaveAdminAccount => 'Don\'t have an admin account?';

  @override
  String get register => 'Register';

  @override
  String get adminRegistration => 'Admin Registration';

  @override
  String get createNewAdminAccount => 'Create a new administrator account';

  @override
  String get phoneNumberOptional => 'Phone Number (Optional)';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get pleaseEnterFirstName => 'Please enter first name';

  @override
  String get pleaseEnterLastName => 'Please enter last name';

  @override
  String get pleaseEnterValidEmail => 'Please enter valid email';

  @override
  String get usernameMinLength => 'Username must be at least 3 characters';

  @override
  String get pleaseConfirmPassword => 'Please confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get accountCreatedSuccessfully =>
      'Admin account created successfully! Redirecting to login...';

  @override
  String get failedToCreateAccount => 'Failed to create admin account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get adminAccessRequired =>
      'You do not have permission to use this application. Only administrators can access the desktop application.';

  @override
  String get addRole => 'Add Role';

  @override
  String get editRole => 'Edit Role';

  @override
  String get roleName => 'Role Name';

  @override
  String get enterRoleName => 'Enter role name';

  @override
  String get roleNameRequired => 'Role name is required';

  @override
  String get roleNameTooLong => 'Role name must be less than 50 characters';

  @override
  String get roleCreatedSuccessfully => 'Role created successfully';

  @override
  String get roleUpdatedSuccessfully => 'Role updated successfully';

  @override
  String get roleDeletedSuccessfully => 'Role deleted successfully';

  @override
  String get failedToDeleteRole => 'Failed to delete role';

  @override
  String get confirmDeleteRole =>
      'Are you sure you want to delete this role? This action is permanent and cannot be undone.';

  @override
  String get deleteRole => 'Delete Role';

  @override
  String get loadingRoles => 'Loading roles...';

  @override
  String get noRolesLoaded => 'No roles loaded';

  @override
  String get noRolesFound => 'No roles found';

  @override
  String get searchRoles => 'Search roles...';

  @override
  String totalRoles(int count) {
    return 'Total: $count roles';
  }

  @override
  String get unnamedRole => 'Unnamed Role';

  @override
  String get editUser => 'Edit User';

  @override
  String get addUser => 'Add User';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get user => 'User';

  @override
  String get userUpdatedSuccessfully => 'User updated successfully';

  @override
  String get userCreatedSuccessfully => 'User created successfully';

  @override
  String failedToSaveUser(String error) {
    return 'Failed to save user: $error';
  }

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String failedToUpdateProfile(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get capacityMismatch => 'Capacity Mismatch';

  @override
  String seatCountMismatch(int seats, int capacity) {
    return 'Seat count mismatch: $seats / $capacity';
  }

  @override
  String get autoGenerateSeats => 'Auto-generate Seats';

  @override
  String autoGenerateSeatsMessage(int capacity) {
    return 'This will create $capacity seats for the hall. Existing seats will be replaced. Continue?';
  }

  @override
  String get generate => 'Generate';

  @override
  String seatsGeneratedSuccessfully(int count) {
    return 'Generated $count seats successfully';
  }

  @override
  String failedToGenerateSeats(String error) {
    return 'Failed to generate seats: $error';
  }

  @override
  String get seatsManagement => 'Seats Management';

  @override
  String get addSeat => 'Add Seat';

  @override
  String get noSeatsFound => 'No seats found for this hall';

  @override
  String get editSeat => 'Edit Seat';

  @override
  String get seatNumber => 'Seat Number';

  @override
  String get rowNumber => 'Row Number';

  @override
  String get pleaseEnterSeatNumber => 'Please enter seat number';

  @override
  String get pleaseEnterRowNumber => 'Please enter row number';

  @override
  String get confirmDeleteSeat => 'Delete Seat';

  @override
  String get areYouSureDeleteSeat =>
      'Are you sure you want to delete this seat?';

  @override
  String get seatUpdatedSuccessfully => 'Seat updated successfully';

  @override
  String get failedToUpdateSeat => 'Failed to update seat';

  @override
  String get seatDeletedSuccessfully => 'Seat deleted successfully';

  @override
  String get failedToDeleteSeat => 'Failed to delete seat';

  @override
  String get addNewSeat => 'Add New Seat';

  @override
  String get seatSavedSuccessfully => 'Seat saved successfully';

  @override
  String get failedToSaveSeat => 'Failed to save seat';

  @override
  String seatCountMatchesCapacity(int seats, int capacity) {
    return 'Seat count matches capacity: $seats / $capacity';
  }

  @override
  String cannotAddMoreSeats(int capacity, int seats) {
    return 'Cannot add more seats. Hall capacity is $capacity and current seat count is $seats.';
  }

  @override
  String cannotMoveSeatToHall(int capacity, int seats) {
    return 'Cannot move seat to this hall. Hall capacity is $capacity and current seat count is $seats.';
  }

  @override
  String get autoGenerateSeatsTooltip =>
      'Auto-generate seats for this capacity';

  @override
  String get seatName => 'Seat Name';

  @override
  String get seatNameFormat => 'Format: Letter (A-F) + Number (1-8)';

  @override
  String get pleaseEnterSeatName => 'Please enter seat name';

  @override
  String get invalidSeatFormat =>
      'Invalid format. Use A1-F8 format (e.g., A1, B5, F8)';

  @override
  String seatAlreadyExists(String name) {
    return 'Seat $name already exists';
  }

  @override
  String get seatAddedSuccessfully => 'Seat added successfully';

  @override
  String get failedToAddSeat => 'Failed to add seat';

  @override
  String get add => 'Add';

  @override
  String get regenerateAll => 'Regenerate All';

  @override
  String get allSeatsAlreadyExist => 'All seats already exist';

  @override
  String get available => 'Available';

  @override
  String get reserved => 'Reserved';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get selectDateRangeTooltip => 'Select a date range to filter data';

  @override
  String get occupancy => 'Occupancy';

  @override
  String get type => 'Type';

  @override
  String get event => 'Event';

  @override
  String get eventDate => 'Event Date';

  @override
  String get pleaseSelectType => 'Please select type';

  @override
  String get pleaseSelectEventDate => 'Please select event date';

  @override
  String get publishDateCannotBeInFuture =>
      'Please select a publish date that is not in the future';

  @override
  String get eventDateRequired => 'Event date is required for events';

  @override
  String get newsCannotHaveEventDate =>
      'News articles cannot have an event date';

  @override
  String get pleaseEnterMovieTitle => 'Please enter movie title';

  @override
  String get movieTitleTooLong => 'Title must be less than 200 characters';

  @override
  String get pleaseEnterMovieDescription => 'Please enter movie description';

  @override
  String get movieDescriptionTooLong =>
      'Description must be less than 1000 characters';

  @override
  String get pleaseEnterMovieDirector => 'Please enter movie director';

  @override
  String get movieDirectorTooLong =>
      'Director name must be less than 100 characters';

  @override
  String get pleaseEnterMovieDuration => 'Please enter movie duration';

  @override
  String get movieDurationTooShort => 'Duration must be at least 1 minute';

  @override
  String get movieDurationTooLong =>
      'Duration cannot exceed 600 minutes (10 hours)';

  @override
  String get durationMinutesHelp => 'Enter duration in minutes (1-600)';

  @override
  String get pleaseEnterReleaseDate => 'Please enter release date';

  @override
  String get invalidReleaseYear =>
      'Invalid release year. Must be between 1888 and next year';

  @override
  String get trailerUrlHelp => 'Enter valid YouTube or other video URL';

  @override
  String get pleaseEnterValidUrl => 'Please enter a valid URL';

  @override
  String get pleaseSelectAtLeastOneGenre => 'Please select at least one genre';

  @override
  String get pleaseSelectAtLeastOneActor => 'Please select at least one actor';

  @override
  String get movieCreatedSuccessfully => 'Movie created successfully';

  @override
  String get movieUpdatedSuccessfully => 'Movie updated successfully';

  @override
  String get usernameInvalid =>
      'Username can only contain letters, numbers and underscores';

  @override
  String get phoneNumberInvalid => 'Please enter a valid phone number';

  @override
  String get phoneNumberFormat => 'Format: +123 45 678 910';

  @override
  String get confirmDeletionTitle => 'Confirm Deletion';

  @override
  String confirmDeleteSeatMessage(Object seatName) {
    return 'Are you sure you want to delete the seat \"$seatName\"? This will remove the seat from all existing screenings.';
  }

  @override
  String get deleteButtonLabel => 'Delete';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get seatLayout => 'Seat Layout';

  @override
  String searchPlaceholder(String label) {
    return 'Search $label...';
  }

  @override
  String get searchGenresPlaceholder => 'Search genres...';

  @override
  String get searchActorsPlaceholder => 'Search actors...';

  @override
  String get searchButtonLabel => 'Search';

  @override
  String get noScreeningsToday => 'No screenings today';
}
