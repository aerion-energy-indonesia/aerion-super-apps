import 'package:aerion_dashboard/features/cluster/domain/entities/cluster_entitiy.dart';
import 'package:aerion_dashboard/features/cluster/domain/usecases/cluster_usecase.dart';
import 'package:flutter/material.dart';

class ClusterState {
  final bool isLoading;
  final ClusterEntitiy? clusterData;
  final String? error;

  ClusterState({this.isLoading = false, this.clusterData, this.error});

  ClusterState copyWith({
    bool? isLoading,
    ClusterEntitiy? clusterData,
    String? error,
    bool clearError = false,
  }) {
    return ClusterState(
      isLoading: isLoading ?? this.isLoading,
      clusterData: clusterData ?? this.clusterData,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ClusterNotifier extends ChangeNotifier {
  final ClusterUsecase clusterUsecase;

  ClusterNotifier(this.clusterUsecase);

  // State Internal
  ClusterState _state = ClusterState();
  ClusterState get state => _state; // Getter untuk mengakses state

  // Metode untuk mengambil data cluster
  Future<void> fetchClusterData() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    final result = await clusterUsecase();

    result.fold(
      (failure) {
        _state = _state.copyWith(isLoading: false, error: failure);
      },
      (data) {
        _state = _state.copyWith(isLoading: false, clusterData: data);
      },
    );

    notifyListeners();
  }
}
