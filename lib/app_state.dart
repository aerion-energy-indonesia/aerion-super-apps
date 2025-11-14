import 'package:flutter/foundation.dart';
import 'features/onboarding/domain/entities/onboarding_item.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';

class AppState extends ChangeNotifier {
  final OnboardingRepository repository;

  AppState(this.repository);

  List<OnboardingItem> _items = [];
  List<OnboardingItem> get items => _items;

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
