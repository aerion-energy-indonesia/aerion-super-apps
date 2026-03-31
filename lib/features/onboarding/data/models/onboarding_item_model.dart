import '../../domain/entities/onboarding_item.dart';

class OnboardingItemModel extends OnboardingItem {
  OnboardingItemModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.logoAsset,
  });

  factory OnboardingItemModel.fromJson(Map<String, dynamic> json) {
    return OnboardingItemModel(
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
