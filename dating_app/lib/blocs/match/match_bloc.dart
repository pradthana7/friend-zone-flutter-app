import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

import '/models/models.dart';

part 'match_state.dart';
part 'match_event.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _databaseSubscription;

  MatchBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(MatchLoading()) {
    on<LoadMatches>(_onLoadMatches);
    on<UpdateMatches>(_onUpdateMatches);
  }
  void _onLoadMatches(
    LoadMatches event,
    Emitter<MatchState> emit,
  ) {
    _databaseSubscription =
        _databaseRepository.getMatches(event.user).listen((matchedUsers) {
      print('Matched Users:  $matchedUsers');
      add(UpdateMatches(matchedUsers: matchedUsers));
    });
  }

  void _onUpdateMatches(
    UpdateMatches event,
    Emitter<MatchState> emit,
  ) {
    if (event.matchedUsers.length == 0) {
      emit(MatchUnavailable());
    } else {
      emit(MatchLoaded(matches: event.matchedUsers));
    }
  }

  @override
  Future<void> close() async {
    _databaseSubscription?.cancel();
    super.close();
  }
}
