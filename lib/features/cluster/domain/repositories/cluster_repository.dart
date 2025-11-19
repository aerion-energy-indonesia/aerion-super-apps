import 'package:dartz/dartz.dart';
import 'package:aerion_dashboard/features/cluster/domain/entities/cluster_entitiy.dart';

typedef ClusterFailure = String;

abstract class ClusterRepository {
  Future<Either<ClusterFailure, ClusterEntitiy>> fetchClusterData();
}
