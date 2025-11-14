import '../entities/onboarding_item.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingItems {
  final OnboardingRepository repository;

  GetOnboardingItems(this.repository);

  Future<List<OnboardingItem>> call() {
    return repository.fetchItems();
  }
}
