import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/promotions/model/promotion_model.dart';

abstract class PromotionsState extends Equatable {
  const PromotionsState();

  @override
  List<Object?> get props => [];
}

class PromotionsInitial extends PromotionsState {
  const PromotionsInitial();
}

class PromotionsLoading extends PromotionsState {
  const PromotionsLoading();
}

class PromotionsLoaded extends PromotionsState {
  const PromotionsLoaded({this.popup, required this.banners});

  final PromotionModel? popup;
  final List<PromotionModel> banners;

  @override
  List<Object?> get props => [popup, banners];
}

class PromotionsError extends PromotionsState {
  const PromotionsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
