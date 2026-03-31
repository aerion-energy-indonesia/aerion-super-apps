import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aerion_dashboard/features/cluster/domain/entities/cluster_entitiy.dart';

abstract class ClusterRemoteDatasource {
  Future<ClusterEntitiy> fetchClusterData();
}

class ClusterRemoteDatasourceImpl implements ClusterRemoteDatasource {
  final FirebaseFirestore firestore;

  ClusterRemoteDatasourceImpl(this.firestore);

  @override
  Future<ClusterEntitiy> fetchClusterData() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('clusters').get();

      if (snapshot.docs.isEmpty) {
        throw Exception('No cluster data found in Firestore.');
      }

      // Mengambil dokumen clusters
      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return ClusterEntitiy.fromMap(data);
    } catch (e) {
      throw Exception('Failed to fetch cluster names: $e');
    }
  }
}
