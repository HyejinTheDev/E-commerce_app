import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userName, userAvatar, rating, comment, createdAt];
}
