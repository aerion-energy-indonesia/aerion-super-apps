import 'package:dartz/dartz.dart';
import 'package:aerion_dashboard/features/cluster/domain/repositories/cluster_repository.dart';
import 'package:aerion_dashboard/features/cluster/data/datasources/cluster_remote_datasource.dart';
import 'package:aerion_dashboard/features/cluster/domain/entities/cluster_entitiy.dart';

class ClusterRepositoryImpl implements ClusterRepository {
  final ClusterRemoteDatasource remoteDatasource;

  ClusterRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<String, ClusterEntitiy>> fetchClusterData() async {
    try {
      final clusterData = await remoteDatasource.fetchClusterData();
      return Right(clusterData);
    } catch (e) {
      return Left('Failed to fetch cluster data: $e');
    }
  }
}
