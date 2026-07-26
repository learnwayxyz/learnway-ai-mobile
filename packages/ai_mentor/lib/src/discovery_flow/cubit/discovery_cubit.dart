import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../career_goal/models/career_recommendation_model.dart';
import '../../career_goal/repository/career_goal_repository.dart';

part 'discovery_state.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit(this._repository) : super(const DiscoveryInitial());

  final CareerGoalRepository _repository;

  void start() {
    emit(const DiscoveryInProgress(
      currentStep: DiscoveryStep.goals,
      selectedGoals: [],
      selectedTopics: [],
    ));
  }

  void toggleGoal(String goal) {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    final goals = List<String>.from(current.selectedGoals);
    if (goals.contains(goal)) {
      goals.remove(goal);
    } else {
      goals.add(goal);
    }
    emit(current.copyWith(selectedGoals: goals));
  }

  void advanceFromGoals() {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    if (current.selectedGoals.isEmpty) return;
    emit(current.copyWith(currentStep: DiscoveryStep.experience));
  }

  void selectExperience(ExperienceLevel level) {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    emit(current.copyWith(
      selectedExperience: level,
      currentStep: DiscoveryStep.topics,
    ));
  }

  void toggleTopic(String topic) {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    final topics = List<String>.from(current.selectedTopics);
    if (topics.contains(topic)) {
      topics.remove(topic);
    } else if (topics.length < 5) {
      topics.add(topic);
    }
    emit(current.copyWith(selectedTopics: topics));
  }

  void advanceFromTopics() {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    if (current.selectedTopics.length < 3) return;

    emit(current.copyWith(
      currentStep: DiscoveryStep.aiRecommendation,
      isLoadingRecommendations: true,
      clearErrorMessage: true,
    ));

    _fetchRecommendations(current);
  }

  String Function() _getUserId = () => '';

  void setGetUserId(String Function() fn) => _getUserId = fn;

  Future<void> _fetchRecommendations(DiscoveryInProgress snapshot) async {
    final userId = _getUserId();
    log('DiscoveryCubit: fetching recommendations for userId: $userId');
    final result = await _repository.getDiscoveryRecommendations(
      userId: userId,
      goals: snapshot.selectedGoals,
      experience: snapshot.selectedExperience?.name ?? 'beginner',
      topics: snapshot.selectedTopics,
    );

    if (state is! DiscoveryInProgress) return;

    result.fold(
      (failure) {
        log('DiscoveryCubit: recommendations error: ${failure.message}');
        emit(
          (state as DiscoveryInProgress).copyWith(
            isLoadingRecommendations: false,
            errorMessage: failure.message,
          ),
        );
      },
      (recs) => emit(
        (state as DiscoveryInProgress).copyWith(
          isLoadingRecommendations: false,
          recommendations: recs,
          selectedRecommendationIndex: 0,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  void selectRecommendation(int index) {
    if (state is! DiscoveryInProgress) return;
    emit((state as DiscoveryInProgress).copyWith(
      selectedRecommendationIndex: index,
    ));
  }

  Future<void> confirmSelection(String userId) async {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    if (current.selectedRecommendationIndex == null) return;

    final selected =
        current.recommendations[current.selectedRecommendationIndex!];

    emit(current.copyWith(isSaving: true, clearSaveError: true));

    final result = await _repository.saveCareerGoal(userId, selected.careerTitle);

    if (state is! DiscoveryInProgress) return;

    result.fold(
      (failure) {
        log('DiscoveryCubit: saveCareerGoal error: ${failure.message}');
        emit(
          (state as DiscoveryInProgress).copyWith(
            isSaving: false,
            saveError: failure.message,
          ),
        );
      },
      (_) => emit(const DiscoveryComplete()),
    );
  }

  void goBack() {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    final index = DiscoveryStep.values.indexOf(current.currentStep);
    if (index > 0) {
      emit(current.copyWith(currentStep: DiscoveryStep.values[index - 1]));
    }
  }

  void retryRecommendations() {
    if (state is! DiscoveryInProgress) return;
    final current = state as DiscoveryInProgress;
    emit(current.copyWith(
      isLoadingRecommendations: true,
      clearErrorMessage: true,
    ));
    _fetchRecommendations(current);
  }

  void reset() => emit(const DiscoveryInitial());
}
