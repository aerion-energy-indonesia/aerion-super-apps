class ClusterEntitiy {
  final String name;
  final String description;
  final String imageUrl;
  final String clientId;

  ClusterEntitiy({
    required this.clientId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory ClusterEntitiy.fromMap(Map<String, dynamic> map) {
    return ClusterEntitiy(
      clientId: map['client_id'] as String,
      name: map['cluster_name'] as String,
      description: map['description'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  static List<ClusterEntitiy> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => ClusterEntitiy.fromMap(map)).toList();
  }
}
