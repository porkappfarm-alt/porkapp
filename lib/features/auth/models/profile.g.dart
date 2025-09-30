// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      role:
          $enumDecodeNullable(_$ProfileRoleEnumMap, json['role']) ??
          ProfileRole.user,
      status:
          $enumDecodeNullable(_$ProfileStatusEnumMap, json['status']) ??
          ProfileStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': _$ProfileRoleEnumMap[instance.role]!,
      'status': _$ProfileStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ProfileRoleEnumMap = {
  ProfileRole.user: 'user',
  ProfileRole.admin: 'admin',
};

const _$ProfileStatusEnumMap = {
  ProfileStatus.pending: 'pending',
  ProfileStatus.approved: 'approved',
  ProfileStatus.blocked: 'blocked',
};
