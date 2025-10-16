import 'package:porkapp/features/biometrics/domain/biometric_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedData {
  final DateTime date;
  final double amount;

  FeedData({required this.date, required this.amount});

  factory FeedData.fromJson(Map<String, dynamic> json) {
    return FeedData(
      date: DateTime.parse(json['date'] as String),
      amount: json['amount'] as double,
    );
  }
}

class AnimalEventsDataSource {
  final SupabaseClient client;

  AnimalEventsDataSource(this.client);

  Future<double> getAdgByBatch(String batchId) async {
    final response = await client.rpc(
      'get_batch_adg',
      params: {'p_batch_id': batchId},
    );

    final data = response as Map<String, dynamic>;
    return data['adg'] as double;
  }

  Future<double> getFcrByBatch(String batchId) async {
    final response = await client.rpc(
      'get_batch_fcr',
      params: {'p_batch_id': batchId},
    );

    final data = response as Map<String, dynamic>;
    return data['fcr'] as double;
  }

  Future<List<MortalityByCause>> getMortalityByBatch(String batchId) async {
    final response = await client.rpc(
      'get_batch_mortality_stats',
      params: {'p_batch_id': batchId},
    );

    return (response as List).map((e) {
      final map = e as Map<String, dynamic>;
      return MortalityByCause(
        cause: map['death_cause'] as String,
        count: map['count'] as int,
      );
    }).toList();
  }

  Future<double> getMortalityRate(String batchId) async {
    final response = await client.rpc(
      'get_batch_mortality_stats',
      params: {'p_batch_id': batchId},
    );

    final list = response as List;
    final totalDeaths = list.fold<int>(
      0,
      (sum, item) => sum + (item['count'] as int),
    );

    // TODO: Obtener headcount real del lote
    const initialHeadcount = 100;
    return (totalDeaths / initialHeadcount) * 100;
  }

  Future<List<FeedData>> getFeedDataByBatch(String batchId) async {
    final response = await client
        .from('animal_events')
        .select()
        .eq('batch_id', batchId)
        .eq('type', 'feeding')
        .order('created_at');

    return (response as List).map((e) {
      final data = e as Map<String, dynamic>;
      return FeedData.fromJson({
        'date': data['created_at'] as String,
        'amount': (data['data']['amount'] as num).toDouble(),
      });
    }).toList();
  }

  Future<List<WeightPoint>> getWeightTimeline(String batchId) async {
    final response = await client
        .from('animal_events')
        .select()
        .eq('batch_id', batchId)
        .eq('type', 'weighing')
        .order('created_at');

    return (response as List).map((e) {
      final data = e as Map<String, dynamic>;
      return WeightPoint(
        date: DateTime.parse(data['created_at']),
        avgWeight: (data['data']['weight'] as num).toDouble(),
      );
    }).toList();
  }
}
