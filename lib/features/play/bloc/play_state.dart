part of 'play_bloc.dart';

sealed class PlayState extends Equatable {
  const PlayState();
  
  @override
  List<Object> get props => [];
}

final class PlayInitial extends PlayState {}
