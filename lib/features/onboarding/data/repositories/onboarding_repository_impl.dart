import 'dart:async';
import '../../domain/entities/onboarding_item.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../models/onboarding_item_model.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  Future<List<OnboardingItem>> fetchItems() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network
    final data = [
      {
        'id': '0',
        'title': 'Komatsu Undercarriage Indonesia',
        'subtitle': 'Komatsu Undercarriage Indonesia',
        'logoAsset': 'assets/images/logo/kui.png',
      },
      {
        'id': '1',
        'title': 'Komatsu International',
        'subtitle': 'Komatsu International',
        'logoAsset': 'assets/images/logo/komatsu.png',
      },
      {
        'id': '2',
        'title': 'Komatsu United Tractor',
        'subtitle': 'Komatsu United Tractor',
        'logoAsset': 'assets/images/logo/komatsu.png',
      },
    ];
    return data.map((e) => OnboardingItemModel.fromJson(e)).toList();
  }
}
