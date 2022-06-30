import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'filters_event.dart';
import 'filters_state.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {

  EscapeRoomServices _service;

  FiltersBloc(EscapeRoomServices service)
      : _service = service,
        super(FiltersInitial());

  @override
  Stream<FiltersState> mapEventToState(FiltersEvent event) async* {
    if (event is LoadTopics) {
      yield* _mapLoadTopicsToState(event);
    }
  }

  Stream<FiltersState> _mapLoadTopicsToState(LoadTopics event) async* {
    yield FiltersLoading();
    try {
      var topicList = await _service.getTopics();
      if (topicList != null) {
        yield TopicsSuccess(topicList: topicList);
      } else {
        yield TopicsFailure(error: 'error.topics');
      }
    } catch (err) {
      yield TopicsFailure(error: 'error.topics 2'); // modified because of the null-safety update
    }
  }
}