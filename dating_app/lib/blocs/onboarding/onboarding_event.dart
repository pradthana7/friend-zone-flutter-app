part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class StartOnboarding extends OnboardingEvent {
  final User user;
  final TabController tabController;

  const StartOnboarding({
    required this.tabController,
    this.user = User.empty,
  });

  @override
  List<Object?> get props => [tabController, user];
}

class ContinueOnboarding extends OnboardingEvent {
  final User user;
  final bool isSignup;

  const ContinueOnboarding({
    required this.user,
    this.isSignup = false,
  });

  @override
  List<Object?> get props => [user, isSignup];

}

class UpdateUser extends OnboardingEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserImages extends OnboardingEvent {
  final User? user;
  final XFile image;

  const UpdateUserImages({
    this.user,
    required this.image,
  });

  @override
  List<Object?> get props => [user, image];
}


