import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

enum ProfileStatus {
  pending,
  approved,
  blocked,
}

enum ProfileRole {
  user,
  admin,
}

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String email,
    @Default(ProfileRole.user) ProfileRole role,
    @Default(ProfileStatus.pending) ProfileStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  const Profile._();

  bool get canAccessApp => status == ProfileStatus.approved;
}