import '../entities/dashboard_item.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardItems {
  final DashboardRepository repository;

  GetDashboardItems(this.repository);

  Future<List<DashboardItem>> call() {
    return repository.fetchItems();
  }
}
