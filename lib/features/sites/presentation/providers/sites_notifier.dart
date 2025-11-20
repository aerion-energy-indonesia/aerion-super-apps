import 'package:aerion_dashboard/features/sites/domain/entities/sites_entitiy.dart';
import 'package:aerion_dashboard/features/sites/domain/usecases/sites_usecase.dart';
import 'package:flutter/material.dart';

class SitesState {
  final bool isLoading;
  final SitesEntitiy? sitesData;
  final String? error;

  SitesState({this.isLoading = false, this.sitesData, this.error});

  SitesState copyWith({
    bool? isLoading,
    SitesEntitiy? sitesData,
    String? error,
    bool clearError = false,
  }) {
    return SitesState(
      isLoading: isLoading ?? this.isLoading,
      sitesData: sitesData ?? this.sitesData,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class SitesNotifier extends ChangeNotifier {
  final SitesUsecase sitesUsecase;

  SitesNotifier(this.sitesUsecase);

  // State Internal
  SitesState _state = SitesState();
  SitesState get state => _state; // Getter untuk mengakses state

  // Metode untuk mengambil data cluster
  Future<void> fetchSitesData() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    final result = await sitesUsecase();

    result.fold(
      (failure) {
        _state = _state.copyWith(isLoading: false, error: failure.toString());
      },
      (data) {
        _state = _state.copyWith(isLoading: false, sitesData: data);
      },
    );

    notifyListeners();
  }
}
