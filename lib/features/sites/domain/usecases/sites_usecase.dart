import 'package:dartz/dartz.dart';
import 'package:aerion_dashboard/features/sites/domain/entities/sites_entitiy.dart';
import 'package:aerion_dashboard/features/sites/domain/repositories/sites_repository.dart';

class SitesUsecase {
  final SitesRepository repository;
  SitesUsecase(this.repository);

  Future<Either<SitesFailure, SitesEntitiy>> call() async {
    return await repository.fetchSitesData();
  }
}
