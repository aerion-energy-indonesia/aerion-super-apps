import '../../domain/entities/dashboard_item.dart';

class DashboardItemModel extends DashboardItem {
  DashboardItemModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.logoAsset,
  });

  factory DashboardItemModel.fromJson(Map<String, dynamic> json) {
    return DashboardItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      logoAsset: json['logoAsset'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'logoAsset': logoAsset,
    };
  }
}
