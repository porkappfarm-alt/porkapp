import 'package:dartz/dartz.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/shared/exceptions/app_exception.dart';
import 'package:porkapp/features/animals/data/animal_data_source.dart';

abstract class AnimalRepository {
  Future<Either<AppException, List<Animal>>> getAnimalsByBatch(String batchId);
  Future<Either<AppException, Animal>> getAnimal(String id);
  Future<Either<AppException, Animal>> createAnimal(Animal animal);
  Future<Either<AppException, Animal>> updateAnimal(Animal animal);
  Future<Either<AppException, void>> deleteAnimal(String id);
}

class AnimalRepositoryImpl implements AnimalRepository {
  final AnimalDataSource _dataSource;

  AnimalRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppException, List<Animal>>> getAnimalsByBatch(String batchId) async {
    try {
      final animals = await _dataSource.getAnimalsByBatch(batchId);
      return Right(animals);
    } catch (e) {
      return Left(AppException(
        message: 'Error al obtener los animales del lote: ${e.toString()}',
        type: AppExceptionType.database,
      ));
    }
  }

  @override
  Future<Either<AppException, Animal>> getAnimal(String id) async {
    try {
      final animal = await _dataSource.getAnimal(id);
      return Right(animal);
    } catch (e) {
      return Left(AppException(
        message: 'Error al obtener el animal: ${e.toString()}',
        type: AppExceptionType.database,
      ));
    }
  }

  @override
  Future<Either<AppException, Animal>> createAnimal(Animal animal) async {
    try {
      final createdAnimal = await _dataSource.createAnimal(animal);
      return Right(createdAnimal);
    } catch (e) {
      return Left(AppException(
        message: 'Error al crear el animal: ${e.toString()}',
        type: AppExceptionType.database,
      ));
    }
  }

  @override
  Future<Either<AppException, Animal>> updateAnimal(Animal animal) async {
    try {
      final updatedAnimal = await _dataSource.updateAnimal(animal);
      return Right(updatedAnimal);
    } catch (e) {
      return Left(AppException(
        message: 'Error al actualizar el animal: ${e.toString()}',
        type: AppExceptionType.database,
      ));
    }
  }

  @override
  Future<Either<AppException, void>> deleteAnimal(String id) async {
    try {
      await _dataSource.deleteAnimal(id);
      return const Right(null);
    } catch (e) {
      return Left(AppException(
        message: 'Error al eliminar el animal: ${e.toString()}',
        type: AppExceptionType.database,
      ));
    }
  }
}