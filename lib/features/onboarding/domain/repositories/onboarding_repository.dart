import '../entities/onboarding_item.dart';

abstract class OnboardingRepository {
  Future<List<OnboardingItem>> fetchItems();
}
