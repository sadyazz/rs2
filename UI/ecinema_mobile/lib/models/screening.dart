class Screening {
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  double? basePrice;
  String? language;
  bool? hasSubtitles;
  bool? isDeleted;
  int? movieId;
  String? movieTitle;
  String? movieImage;
  int? hallId;
  String? hallName;
  int? screeningFormatId;
  String? screeningFormatName;
  double? screeningFormatPriceMultiplier;
  int? reservationsCount;
  int? availableSeats;

  Screening({
    this.id,
    this.startTime,
    this.endTime,
    this.basePrice,
    this.language,
    this.hasSubtitles,
    this.isDeleted,
    this.movieId,
    this.movieTitle,
    this.movieImage,
    this.hallId,
    this.hallName,
    this.screeningFormatId,
    this.screeningFormatName,
    this.screeningFormatPriceMultiplier,
    this.reservationsCount,
    this.availableSeats,
  });

  Screening.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['startTime'] != null ? DateTime.parse(json['startTime']) : null;
    endTime = json['endTime'] != null ? DateTime.parse(json['endTime']) : null;
    basePrice = json['basePrice']?.toDouble();
    language = json['language'];
    hasSubtitles = json['hasSubtitles'];
    isDeleted = json['isDeleted'];
    movieId = json['movieId'];
    movieTitle = json['movieTitle'];
    movieImage = json['movieImage'];
    hallId = json['hallId'];
    hallName = json['hallName'];
    screeningFormatId = json['screeningFormatId'];
    screeningFormatName = json['screeningFormatName'];
    screeningFormatPriceMultiplier = json['screeningFormatPriceMultiplier']?.toDouble();
    reservationsCount = json['reservationsCount'];
    availableSeats = json['availableSeats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startTime'] = startTime?.toIso8601String();
    data['endTime'] = endTime?.toIso8601String();
    data['basePrice'] = basePrice;
    data['language'] = language;
    data['hasSubtitles'] = hasSubtitles;
    data['isDeleted'] = isDeleted;
    data['movieId'] = movieId;
    data['movieTitle'] = movieTitle;
    data['movieImage'] = movieImage;
    data['hallId'] = hallId;
    data['hallName'] = hallName;
    data['screeningFormatId'] = screeningFormatId;
    data['screeningFormatName'] = screeningFormatName;
    data['screeningFormatPriceMultiplier'] = screeningFormatPriceMultiplier;
    data['reservationsCount'] = reservationsCount;
    data['availableSeats'] = availableSeats;
    return data;
  }
} 