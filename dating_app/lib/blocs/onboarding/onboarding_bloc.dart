import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/repositories/repositories.dart';
import '/models/models.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;

  OnboardingBloc({
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
  })  : _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        super(OnboardingLoading()) {
    on<StartOnboarding>(_onStartOnboarding);
    on<ContinueOnboarding>(_onContinueOnboarding);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImages>(_onUpdateUserImages);
  }

  void _onStartOnboarding(
    StartOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    // await _databaseRepository.createUser(event.user);
    emit(
      OnboardingLoaded(
        user: User.empty,
        tabController: event.tabController,
      ),
    );
  }

  void _onContinueOnboarding(
    ContinueOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    final state = this.state as OnboardingLoaded;

    if (event.isSignup) {
      await _databaseRepository.createUser(event.user);
    }

    state.tabController.animateTo(state.tabController.index + 1);

    emit(
      OnboardingLoaded(
        user: event.user,
        tabController: state.tabController,
      ),
    );
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      _databaseRepository.updateUser(event.user);
      emit(
        OnboardingLoaded(
          user: event.user,
          tabController: (state as OnboardingLoaded).tabController,
        ),
      );
    }
  }

  void _onUpdateUserImages(
    UpdateUserImages event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingLoaded) {
      User user = (state as OnboardingLoaded).user;

      await _storageRepository.uploadImage(user, event.image);

      _databaseRepository.getUser(user.id!).listen((user) {
        add(UpdateUser(user: user));
      });
    }
  }
}
