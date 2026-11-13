class Music {
  final String id;
  final String trackTitle;
  final String artistName;
  final String genre;
  final String duration;
  final String musicUrl;

  Music({
    required this.id,
    required this.trackTitle,
    required this.artistName,
    required this.genre,
    required this.duration,
    required this.musicUrl,
  });

  factory Music.fromJson(Map<String, dynamic> json) => Music(
        id: json["_id"] ?? "",
        trackTitle: json["trackTitle"] ?? "",
        artistName: json["artistName"] ?? "",
        genre: json["genre"] ?? "",
        duration: json["duration"] ?? "",
        musicUrl: json["musicUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "trackTitle": trackTitle,
        "artistName": artistName,
        "genre": genre,
        "duration": duration,
        "musicUrl": musicUrl,
      };
}
