part of 'discovery_cubit.dart';

enum DiscoveryStep { goals, experience, topics, aiRecommendation }

enum ExperienceLevel { beginner, intermediate, advanced }

abstract class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object?> get props => [];
}

class DiscoveryInitial extends DiscoveryState {
  const DiscoveryInitial();
}

class DiscoveryInProgress extends DiscoveryState {
  const DiscoveryInProgress({
    required this.currentStep,
    required this.selectedGoals,
    this.selectedExperience,
    required this.selectedTopics,
    this.isLoadingRecommendations = false,
    this.recommendations = const [],
    this.selectedRecommendationIndex,
    this.errorMessage,
    this.isSaving = false,
    this.saveError,
  });

  final DiscoveryStep currentStep;
  final List<String> selectedGoals;
  final ExperienceLevel? selectedExperience;
  final List<String> selectedTopics;
  final bool isLoadingRecommendations;
  final List<CareerRecommendation> recommendations;
  final int? selectedRecommendationIndex;
  final String? errorMessage;
  final bool isSaving;
  final String? saveError;

  DiscoveryInProgress copyWith({
    DiscoveryStep? currentStep,
    List<String>? selectedGoals,
    ExperienceLevel? selectedExperience,
    List<String>? selectedTopics,
    bool? isLoadingRecommendations,
    List<CareerRecommendation>? recommendations,
    int? selectedRecommendationIndex,
    bool clearSelectedRecommendation = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSaving,
    String? saveError,
    bool clearSaveError = false,
  }) {
    return DiscoveryInProgress(
      currentStep: currentStep ?? this.currentStep,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      selectedExperience: selectedExperience ?? this.selectedExperience,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      isLoadingRecommendations:
          isLoadingRecommendations ?? this.isLoadingRecommendations,
      recommendations: recommendations ?? this.recommendations,
      selectedRecommendationIndex: clearSelectedRecommendation
          ? null
          : (selectedRecommendationIndex ?? this.selectedRecommendationIndex),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isSaving: isSaving ?? this.isSaving,
      saveError: clearSaveError ? null : (saveError ?? this.saveError),
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    selectedGoals,
    selectedExperience,
    selectedTopics,
    isLoadingRecommendations,
    recommendations,
    selectedRecommendationIndex,
    errorMessage,
    isSaving,
    saveError,
  ];
}

class DiscoveryComplete extends DiscoveryState {
  const DiscoveryComplete();
}
