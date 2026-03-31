import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aerion_dashboard/features/sites/domain/entities/sites_entitiy.dart';

abstract class SitesRemoteDatasource {
  Future<SitesEntitiy> fetchSitesData();
}

class ClusterRemoteDatasourceImpl implements SitesRemoteDatasource {
  final FirebaseFirestore firestore;

  ClusterRemoteDatasourceImpl(this.firestore);

  @override
  Future<SitesEntitiy> fetchSitesData() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('sites').get();

      if (snapshot.docs.isEmpty) {
        throw Exception('No cluster data found in Firestore.');
      }

      // Mengambil dokumen clusters
      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return SitesEntitiy.fromMap(data);
    } catch (e) {
      throw Exception('Failed to fetch cluster names: $e');
    }
  }
}
