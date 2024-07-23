import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SongModel {
  final String song_url;
  final String song_name;
  final String id;
  final String artist;
  final String thumbnail_url;
  final String hex_code;
  SongModel({
    required this.song_url,
    required this.song_name,
    required this.id,
    required this.artist,
    required this.thumbnail_url,
    required this.hex_code,
  });

  SongModel copyWith({
    String? song_url,
    String? song_name,
    String? id,
    String? artist,
    String? thumbnail_url,
    String? hex_code,
  }) {
    return SongModel(
      song_url: song_url ?? this.song_url,
      song_name: song_name ?? this.song_name,
      id: id ?? this.id,
      artist: artist ?? this.artist,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      hex_code: hex_code ?? this.hex_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'song_url': song_url,
      'song_name': song_name,
      'id': id,
      'artist': artist,
      'thumbnail_url': thumbnail_url,
      'hex_code': hex_code,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      song_url: map['song_url'] ?? '',
      song_name: map['song_name'] ?? '',
      id: map['id'] ?? '',
      artist: map['artist'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
      hex_code: map['hex_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(song_url: $song_url, song_name: $song_name, id: $id, artist: $artist, thumbnail_url: $thumbnail_url, hex_code: $hex_code)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.song_url == song_url &&
        other.song_name == song_name &&
        other.id == id &&
        other.artist == artist &&
        other.thumbnail_url == thumbnail_url &&
        other.hex_code == hex_code;
  }

  @override
  int get hashCode {
    return song_url.hashCode ^
        song_name.hashCode ^
        id.hashCode ^
        artist.hashCode ^
        thumbnail_url.hashCode ^
        hex_code.hashCode;
  }
}
