import 'package:dartz/dartz.dart';
import 'package:aerion_dashboard/features/cluster/domain/entities/cluster_entitiy.dart';
import 'package:aerion_dashboard/features/cluster/domain/repositories/cluster_repository.dart';

class ClusterUsecase {
  final ClusterRepository repository;
  ClusterUsecase(this.repository);

  Future<Either<ClusterFailure, ClusterEntitiy>> call() async {
    return await repository.fetchClusterData();
  }
}
