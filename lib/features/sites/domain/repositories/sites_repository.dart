import 'package:dartz/dartz.dart';
import 'package:aerion_dashboard/features/sites/domain/entities/sites_entitiy.dart';

typedef SitesFailure = String;

abstract class SitesRepository {
  Future<Either<SitesFailure, SitesEntitiy>> fetchSitesData();
}
