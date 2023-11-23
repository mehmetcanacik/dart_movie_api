// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
      movieId: json['movieId'] as String,
      title: json['title'] as String,
      year: json['year'] as int,
      rating: (json['rating'] as num).toDouble(),
      posterUrl:
          json['posterUrl'] as String? ?? 'https://random.imagecdn.app/500/500',
    );

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
    <String, dynamic>{
      'movieId': instance.movieId,
      'title': instance.title,
      'year': instance.year,
      'rating': instance.rating,
      'posterUrl': instance.posterUrl,
    };
