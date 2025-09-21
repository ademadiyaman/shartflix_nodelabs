class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"] ?? json["_id"] ?? "",
      title: json["Title"] ?? json["title"] ?? "Bilinmiyor",
      description: json["Plot"] ?? json["description"] ?? "",
      posterUrl: (json["Poster"] as String?)?.replaceFirst("http://", "https://") ?? "",
    );
  }

}
