// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_local_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetLocalBatchMeasurementCollection on Isar {
  IsarCollection<LocalBatchMeasurement> get localBatchMeasurements =>
      this.collection();
}

const LocalBatchMeasurementSchema = CollectionSchema(
  name: r'BatchMeasurement',
  id: 6456758431589494339,
  properties: {
    r'animalCount': PropertySchema(
      id: 0,
      name: r'animalCount',
      type: IsarType.long,
    ),
    r'averageWeight': PropertySchema(
      id: 1,
      name: r'averageWeight',
      type: IsarType.double,
    ),
    r'batchId': PropertySchema(
      id: 2,
      name: r'batchId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 4,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'measurementDate': PropertySchema(
      id: 5,
      name: r'measurementDate',
      type: IsarType.dateTime,
    ),
    r'notes': PropertySchema(
      id: 6,
      name: r'notes',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 7,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 9,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _LocalBatchMeasurementsyncStatusEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _localBatchMeasurementEstimateSize,
  serialize: _localBatchMeasurementSerialize,
  deserialize: _localBatchMeasurementDeserialize,
  deserializeProp: _localBatchMeasurementDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'batchId': IndexSchema(
      id: -5468368523860846432,
      name: r'batchId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'batchId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'animalMeasurements': LinkSchema(
      id: -6310682354921845542,
      name: r'animalMeasurements',
      target: r'AnimalMeasurement',
      single: false,
      linkName: r'batchMeasurement',
    )
  },
  embeddedSchemas: {},
  getId: _localBatchMeasurementGetId,
  getLinks: _localBatchMeasurementGetLinks,
  attach: _localBatchMeasurementAttach,
  version: '3.0.5',
);

int _localBatchMeasurementEstimateSize(
  LocalBatchMeasurement object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.batchId.length * 3;
  bytesCount += 3 + object.createdBy.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.remoteId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.syncStatus.name.length * 3;
  return bytesCount;
}

void _localBatchMeasurementSerialize(
  LocalBatchMeasurement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.animalCount);
  writer.writeDouble(offsets[1], object.averageWeight);
  writer.writeString(offsets[2], object.batchId);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.createdBy);
  writer.writeDateTime(offsets[5], object.measurementDate);
  writer.writeString(offsets[6], object.notes);
  writer.writeString(offsets[7], object.remoteId);
  writer.writeString(offsets[8], object.status);
  writer.writeString(offsets[9], object.syncStatus.name);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

LocalBatchMeasurement _localBatchMeasurementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalBatchMeasurement();
  object.animalCount = reader.readLong(offsets[0]);
  object.averageWeight = reader.readDouble(offsets[1]);
  object.batchId = reader.readString(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.createdBy = reader.readString(offsets[4]);
  object.id = id;
  object.measurementDate = reader.readDateTime(offsets[5]);
  object.notes = reader.readStringOrNull(offsets[6]);
  object.remoteId = reader.readStringOrNull(offsets[7]);
  object.status = reader.readString(offsets[8]);
  object.syncStatus = _LocalBatchMeasurementsyncStatusValueEnumMap[
          reader.readStringOrNull(offsets[9])] ??
      SyncStatus.synced;
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _localBatchMeasurementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (_LocalBatchMeasurementsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.synced) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LocalBatchMeasurementsyncStatusEnumValueMap = {
  r'synced': r'synced',
  r'pending': r'pending',
  r'error': r'error',
};
const _LocalBatchMeasurementsyncStatusValueEnumMap = {
  r'synced': SyncStatus.synced,
  r'pending': SyncStatus.pending,
  r'error': SyncStatus.error,
};

Id _localBatchMeasurementGetId(LocalBatchMeasurement object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localBatchMeasurementGetLinks(
    LocalBatchMeasurement object) {
  return [object.animalMeasurements];
}

void _localBatchMeasurementAttach(
    IsarCollection<dynamic> col, Id id, LocalBatchMeasurement object) {
  object.id = id;
  object.animalMeasurements.attach(col,
      col.isar.collection<LocalAnimalMeasurement>(), r'animalMeasurements', id);
}

extension LocalBatchMeasurementByIndex
    on IsarCollection<LocalBatchMeasurement> {
  Future<LocalBatchMeasurement?> getByRemoteId(String? remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  LocalBatchMeasurement? getByRemoteIdSync(String? remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String? remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String? remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<LocalBatchMeasurement?>> getAllByRemoteId(
      List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<LocalBatchMeasurement?> getAllByRemoteIdSync(
      List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(LocalBatchMeasurement object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(LocalBatchMeasurement object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<LocalBatchMeasurement> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(List<LocalBatchMeasurement> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension LocalBatchMeasurementQueryWhereSort
    on QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QWhere> {
  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalBatchMeasurementQueryWhere on QueryBuilder<LocalBatchMeasurement,
    LocalBatchMeasurement, QWhereClause> {
  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      remoteIdEqualTo(String? remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      remoteIdNotEqualTo(String? remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      batchIdEqualTo(String batchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'batchId',
        value: [batchId],
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterWhereClause>
      batchIdNotEqualTo(String batchId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [],
              upper: [batchId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [batchId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [batchId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [],
              upper: [batchId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalBatchMeasurementQueryFilter on QueryBuilder<
    LocalBatchMeasurement, LocalBatchMeasurement, QFilterCondition> {
  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'animalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'animalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'animalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> averageWeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> averageWeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> averageWeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> averageWeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'batchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      batchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      batchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'batchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batchId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> batchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'batchId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> measurementDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measurementDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> measurementDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'measurementDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> measurementDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'measurementDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> measurementDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'measurementDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalBatchMeasurementQueryObject on QueryBuilder<
    LocalBatchMeasurement, LocalBatchMeasurement, QFilterCondition> {}

extension LocalBatchMeasurementQueryLinks on QueryBuilder<LocalBatchMeasurement,
    LocalBatchMeasurement, QFilterCondition> {
  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
          QAfterFilterCondition>
      animalMeasurements(FilterQuery<LocalAnimalMeasurement> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'animalMeasurements');
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalMeasurementsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'animalMeasurements', length, true, length, true);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalMeasurementsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'animalMeasurements', 0, true, 0, true);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalMeasurementsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'animalMeasurements', 0, false, 999999, true);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalMeasurementsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'animalMeasurements', 0, true, length, include);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalMeasurementsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'animalMeasurements', length, include, 999999, true);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement,
      QAfterFilterCondition> animalMeasurementsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'animalMeasurements', lower, includeLower, upper, includeUpper);
    });
  }
}

extension LocalBatchMeasurementQuerySortBy
    on QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QSortBy> {
  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByAnimalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalCount', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByAnimalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalCount', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByAverageWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByAverageWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByBatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByBatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByMeasurementDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementDate', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByMeasurementDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementDate', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalBatchMeasurementQuerySortThenBy
    on QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QSortThenBy> {
  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByAnimalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalCount', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByAnimalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalCount', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByAverageWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByAverageWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByBatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByBatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByMeasurementDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementDate', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByMeasurementDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementDate', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalBatchMeasurementQueryWhereDistinct
    on QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct> {
  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByAnimalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animalCount');
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByAverageWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageWeight');
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByBatchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByCreatedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByMeasurementDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measurementDate');
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByRemoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBatchMeasurement, LocalBatchMeasurement, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LocalBatchMeasurementQueryProperty on QueryBuilder<
    LocalBatchMeasurement, LocalBatchMeasurement, QQueryProperty> {
  QueryBuilder<LocalBatchMeasurement, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalBatchMeasurement, int, QQueryOperations>
      animalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animalCount');
    });
  }

  QueryBuilder<LocalBatchMeasurement, double, QQueryOperations>
      averageWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageWeight');
    });
  }

  QueryBuilder<LocalBatchMeasurement, String, QQueryOperations>
      batchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batchId');
    });
  }

  QueryBuilder<LocalBatchMeasurement, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalBatchMeasurement, String, QQueryOperations>
      createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<LocalBatchMeasurement, DateTime, QQueryOperations>
      measurementDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurementDate');
    });
  }

  QueryBuilder<LocalBatchMeasurement, String?, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<LocalBatchMeasurement, String?, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<LocalBatchMeasurement, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LocalBatchMeasurement, SyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<LocalBatchMeasurement, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetLocalAnimalMeasurementCollection on Isar {
  IsarCollection<LocalAnimalMeasurement> get localAnimalMeasurements =>
      this.collection();
}

const LocalAnimalMeasurementSchema = CollectionSchema(
  name: r'AnimalMeasurement',
  id: -8896647013054287275,
  properties: {
    r'adg': PropertySchema(
      id: 0,
      name: r'adg',
      type: IsarType.double,
    ),
    r'animalId': PropertySchema(
      id: 1,
      name: r'animalId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'daysSinceLast': PropertySchema(
      id: 3,
      name: r'daysSinceLast',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 4,
      name: r'notes',
      type: IsarType.string,
    ),
    r'previousWeight': PropertySchema(
      id: 5,
      name: r'previousWeight',
      type: IsarType.double,
    ),
    r'remoteId': PropertySchema(
      id: 6,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 7,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _LocalAnimalMeasurementsyncStatusEnumValueMap,
    ),
    r'weight': PropertySchema(
      id: 8,
      name: r'weight',
      type: IsarType.double,
    ),
    r'weightGain': PropertySchema(
      id: 9,
      name: r'weightGain',
      type: IsarType.double,
    )
  },
  estimateSize: _localAnimalMeasurementEstimateSize,
  serialize: _localAnimalMeasurementSerialize,
  deserialize: _localAnimalMeasurementDeserialize,
  deserializeProp: _localAnimalMeasurementDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'animalId': IndexSchema(
      id: -8446297297210463032,
      name: r'animalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'animalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'batchMeasurement': LinkSchema(
      id: -8568065423915551013,
      name: r'batchMeasurement',
      target: r'BatchMeasurement',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _localAnimalMeasurementGetId,
  getLinks: _localAnimalMeasurementGetLinks,
  attach: _localAnimalMeasurementAttach,
  version: '3.0.5',
);

int _localAnimalMeasurementEstimateSize(
  LocalAnimalMeasurement object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.animalId.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.remoteId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.syncStatus.name.length * 3;
  return bytesCount;
}

void _localAnimalMeasurementSerialize(
  LocalAnimalMeasurement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.adg);
  writer.writeString(offsets[1], object.animalId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.daysSinceLast);
  writer.writeString(offsets[4], object.notes);
  writer.writeDouble(offsets[5], object.previousWeight);
  writer.writeString(offsets[6], object.remoteId);
  writer.writeString(offsets[7], object.syncStatus.name);
  writer.writeDouble(offsets[8], object.weight);
  writer.writeDouble(offsets[9], object.weightGain);
}

LocalAnimalMeasurement _localAnimalMeasurementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalAnimalMeasurement();
  object.adg = reader.readDoubleOrNull(offsets[0]);
  object.animalId = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.daysSinceLast = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[4]);
  object.previousWeight = reader.readDoubleOrNull(offsets[5]);
  object.remoteId = reader.readStringOrNull(offsets[6]);
  object.syncStatus = _LocalAnimalMeasurementsyncStatusValueEnumMap[
          reader.readStringOrNull(offsets[7])] ??
      SyncStatus.synced;
  object.weight = reader.readDouble(offsets[8]);
  object.weightGain = reader.readDoubleOrNull(offsets[9]);
  return object;
}

P _localAnimalMeasurementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (_LocalAnimalMeasurementsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.synced) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LocalAnimalMeasurementsyncStatusEnumValueMap = {
  r'synced': r'synced',
  r'pending': r'pending',
  r'error': r'error',
};
const _LocalAnimalMeasurementsyncStatusValueEnumMap = {
  r'synced': SyncStatus.synced,
  r'pending': SyncStatus.pending,
  r'error': SyncStatus.error,
};

Id _localAnimalMeasurementGetId(LocalAnimalMeasurement object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localAnimalMeasurementGetLinks(
    LocalAnimalMeasurement object) {
  return [object.batchMeasurement];
}

void _localAnimalMeasurementAttach(
    IsarCollection<dynamic> col, Id id, LocalAnimalMeasurement object) {
  object.id = id;
  object.batchMeasurement.attach(col,
      col.isar.collection<LocalBatchMeasurement>(), r'batchMeasurement', id);
}

extension LocalAnimalMeasurementByIndex
    on IsarCollection<LocalAnimalMeasurement> {
  Future<LocalAnimalMeasurement?> getByRemoteId(String? remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  LocalAnimalMeasurement? getByRemoteIdSync(String? remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String? remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String? remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<LocalAnimalMeasurement?>> getAllByRemoteId(
      List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<LocalAnimalMeasurement?> getAllByRemoteIdSync(
      List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<String?> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(LocalAnimalMeasurement object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(LocalAnimalMeasurement object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<LocalAnimalMeasurement> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(List<LocalAnimalMeasurement> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension LocalAnimalMeasurementQueryWhereSort
    on QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QWhere> {
  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalAnimalMeasurementQueryWhere on QueryBuilder<
    LocalAnimalMeasurement, LocalAnimalMeasurement, QWhereClause> {
  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> remoteIdEqualTo(String? remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> remoteIdNotEqualTo(String? remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> animalIdEqualTo(String animalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'animalId',
        value: [animalId],
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterWhereClause> animalIdNotEqualTo(String animalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animalId',
              lower: [],
              upper: [animalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animalId',
              lower: [animalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animalId',
              lower: [animalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animalId',
              lower: [],
              upper: [animalId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalAnimalMeasurementQueryFilter on QueryBuilder<
    LocalAnimalMeasurement, LocalAnimalMeasurement, QFilterCondition> {
  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> adgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'adg',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> adgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'adg',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> adgEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> adgGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> adgLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> adgBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'animalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'animalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'animalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'animalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'animalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      animalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'animalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      animalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'animalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animalId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> animalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'animalId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> daysSinceLastIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'daysSinceLast',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> daysSinceLastIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'daysSinceLast',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> daysSinceLastEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysSinceLast',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> daysSinceLastGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'daysSinceLast',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> daysSinceLastLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'daysSinceLast',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> daysSinceLastBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'daysSinceLast',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> previousWeightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previousWeight',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> previousWeightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previousWeight',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> previousWeightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> previousWeightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> previousWeightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> previousWeightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightGainIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weightGain',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightGainIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weightGain',
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightGainEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightGain',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightGainGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weightGain',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightGainLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weightGain',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> weightGainBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weightGain',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension LocalAnimalMeasurementQueryObject on QueryBuilder<
    LocalAnimalMeasurement, LocalAnimalMeasurement, QFilterCondition> {}

extension LocalAnimalMeasurementQueryLinks on QueryBuilder<
    LocalAnimalMeasurement, LocalAnimalMeasurement, QFilterCondition> {
  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
          QAfterFilterCondition>
      batchMeasurement(FilterQuery<LocalBatchMeasurement> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'batchMeasurement');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement,
      QAfterFilterCondition> batchMeasurementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'batchMeasurement', 0, true, 0, true);
    });
  }
}

extension LocalAnimalMeasurementQuerySortBy
    on QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QSortBy> {
  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByAdg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adg', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByAdgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adg', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByAnimalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalId', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByAnimalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalId', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByDaysSinceLast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysSinceLast', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByDaysSinceLastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysSinceLast', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByPreviousWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousWeight', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByPreviousWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousWeight', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByWeightGain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightGain', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      sortByWeightGainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightGain', Sort.desc);
    });
  }
}

extension LocalAnimalMeasurementQuerySortThenBy on QueryBuilder<
    LocalAnimalMeasurement, LocalAnimalMeasurement, QSortThenBy> {
  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByAdg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adg', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByAdgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adg', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByAnimalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalId', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByAnimalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animalId', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByDaysSinceLast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysSinceLast', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByDaysSinceLastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysSinceLast', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByPreviousWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousWeight', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByPreviousWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousWeight', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByWeightGain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightGain', Sort.asc);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QAfterSortBy>
      thenByWeightGainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightGain', Sort.desc);
    });
  }
}

extension LocalAnimalMeasurementQueryWhereDistinct
    on QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct> {
  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByAdg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adg');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByAnimalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByDaysSinceLast() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'daysSinceLast');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByPreviousWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previousWeight');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByRemoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, LocalAnimalMeasurement, QDistinct>
      distinctByWeightGain() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weightGain');
    });
  }
}

extension LocalAnimalMeasurementQueryProperty on QueryBuilder<
    LocalAnimalMeasurement, LocalAnimalMeasurement, QQueryProperty> {
  QueryBuilder<LocalAnimalMeasurement, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, double?, QQueryOperations>
      adgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adg');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, String, QQueryOperations>
      animalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animalId');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, int?, QQueryOperations>
      daysSinceLastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'daysSinceLast');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, String?, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, double?, QQueryOperations>
      previousWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previousWeight');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, String?, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, SyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, double, QQueryOperations>
      weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }

  QueryBuilder<LocalAnimalMeasurement, double?, QQueryOperations>
      weightGainProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightGain');
    });
  }
}
