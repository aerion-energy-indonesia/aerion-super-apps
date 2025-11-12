import 'dart:async';
import '../../domain/entities/dashboard_item.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/dashboard_item_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<List<DashboardItem>> fetchItems() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network
    final data = [
      {
        'id': '0',
        'title': 'Aerion',
        'subtitle': 'PT Aerion Energy',
        'logoAsset': 'assets/images/icons/aerion.png',
      },
      {
        'id': '1',
        'title': 'Isuzu',
        'subtitle': 'PT Isuzu Astra Motor',
        'logoAsset': 'assets/images/icons/isuzu.png',
      },
      {
        'id': '2',
        'title': 'Pertamina',
        'subtitle': 'PT Pertamina',
        'logoAsset': 'assets/images/icons/pertamina.png',
      },
      {
        'id': '3',
        'title': 'Telkom',
        'subtitle': 'PT Telkom Indonesia',
        'logoAsset': 'assets/images/icons/telkom.png',
      },
    ];
    return data.map((e) => DashboardItemModel.fromJson(e)).toList();
  }
}
