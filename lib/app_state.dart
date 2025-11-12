import 'package:flutter/foundation.dart';
import 'features/dashboard/domain/entities/dashboard_item.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';

class AppState extends ChangeNotifier {
  final DashboardRepository repository;

  AppState(this.repository);

  List<DashboardItem> _items = [];
  List<DashboardItem> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadItems() async {
    _loading = true;
    notifyListeners();
    try {
      _items = await repository.fetchItems();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
