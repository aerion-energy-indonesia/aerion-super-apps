import 'package:dartz/dartz.dart';
import 'package:aerion_dashboard/features/sites/domain/repositories/sites_repository.dart';
import 'package:aerion_dashboard/features/sites/data/datasources/sites_remote_datasource.dart';
import 'package:aerion_dashboard/features/sites/domain/entities/sites_entitiy.dart';

class SitesRepositoryImpl implements SitesRepository {
  final SitesRemoteDatasource remoteDatasource;

  SitesRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<String, SitesEntitiy>> fetchSitesData() async {
    try {
      final sitesData = await remoteDatasource.fetchSitesData();
      return Right(sitesData);
    } catch (e) {
      return Left('Failed to fetch cluster data: $e');
    }
  }
}
