import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
abstract class Movie with _$Movie {
  const factory Movie(
      {required String movieId,
      required String title,
      required int year,
      required double rating,
      @Default('https://random.imagecdn.app/500/500') String posterUrl}) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}
