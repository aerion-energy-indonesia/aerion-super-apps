class SitesEntitiy {
  final String name;
  final String description;
  final String imageUrl;
  final String clientId;

  SitesEntitiy({
    required this.clientId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory SitesEntitiy.fromMap(Map<String, dynamic> map) {
    return SitesEntitiy(
      clientId: map['client_id'] as String,
      name: map['cluster_name'] as String,
      description: map['description'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  static List<SitesEntitiy> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => SitesEntitiy.fromMap(map)).toList();
  }
}
