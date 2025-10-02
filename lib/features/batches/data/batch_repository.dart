import 'package:dartz/dartz.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/shared/exceptions/app_exception.dart';
import 'package:porkapp/features/batches/data/batch_data_source.dart';

abstract class BatchRepository {
  Future<Either<AppException, List<Batch>>> getBatches();
  Future<Either<AppException, Batch>> getBatch(String id);
  Future<Either<AppException, Batch>> createBatch(Batch batch);
  Future<Either<AppException, Batch>> updateBatch(Batch batch);
  Future<Either<AppException, void>> deleteBatch(String id);
}

class BatchRepositoryImpl implements BatchRepository {
  final BatchDataSource _dataSource;

  BatchRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppException, List<Batch>>> getBatches() async {
    try {
      final batches = await _dataSource.getBatches();
      return Right(batches);
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al obtener los lotes: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Batch>> getBatch(String id) async {
    try {
      final batch = await _dataSource.getBatch(id);
      return Right(batch);
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al obtener el lote: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Batch>> createBatch(Batch batch) async {
    try {
      final createdBatch = await _dataSource.createBatch(batch);
      return Right(createdBatch);
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al crear el lote: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Batch>> updateBatch(Batch batch) async {
    try {
      final updatedBatch = await _dataSource.updateBatch(batch);
      return Right(updatedBatch);
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al actualizar el lote: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteBatch(String id) async {
    try {
      await _dataSource.deleteBatch(id);
      return const Right(null);
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al eliminar el lote: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }
}
