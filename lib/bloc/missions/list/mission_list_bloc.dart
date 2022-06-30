import 'dart:developer' as developer;
import 'dart:convert' as convert;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/list/mission_list_event.dart';
import 'package:flutter_escaperank_web/bloc/missions/list/mission_list_state.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/models/escaperooms_list.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissionListBloc extends Bloc<MissionListEvent, MissionListState> {
  EscapeRoomServices? _service;
  EscapeRoomsList? escapeRoomsList;
  EscapeRoom? escapeRoom;
  SharedPreferences? prefs;

  MissionListBloc(EscapeRoomServices service)
      : assert(service != null),
        _service = service,
        super(MissionListInitState());

  @override
  Stream<MissionListState> mapEventToState(MissionListEvent event) async* {
    prefs = await SharedPreferences.getInstance();
    if (event is GetMissionsNew) {
      yield* _mapMissionsNewToState(event);
    } else if (event is GetMissionsByFilters) {
      yield* _mapMissionsByFiltersToState(event);
    } else if (event is LoadMoreMissionsByFilters) {
      yield* _mapLoadMoreMissionsByFiltersToState(event);
    } else if (event is GetMissionsByCompany) {
      yield* _mapMissionsByCompanyToState(event);
    } else if (event is LoadMoreMissionsByCompany) {
      yield* _mapMoreMissionsByCompanyToState(event);
    } else if (event is GetMissionsById) {
      yield* _mapMissionsByIdToState(event);
    } else if (event is ShowResults) {
      yield* _mapResultsToState(event);
    } else if (event is CheckFavMissions) {
      yield* _mapFavsMissionsToState(event);
    }
  }

  Stream<MissionListState> _mapResultsToState(ShowResults event) async* {
    await Future.delayed(Duration(milliseconds: 1000));
    yield ShowResultsByFilter();
  }

  Stream<MissionListState> _mapFavsMissionsToState(CheckFavMissions event) async* {
    yield MissionListLoading();
    escapeRoomsList = await _service?.getFavs(event.token);
    if (escapeRoomsList != null && escapeRoomsList!.escaperooms.isNotEmpty) {
      yield FavMissionsLoaded(list: escapeRoomsList!);
    } else {
      yield FavMissionsNoResults();
    }
  }

  Stream<MissionListState> _mapMissionsByFiltersToState(
      GetMissionsByFilters event) async* {
    yield MissionListLoading();
    try {

      developer.log("Preparing to search", name: "mission_list_bloc");
      escapeRoomsList = await _service?.searchEscapeRooms(event.filters, (prefs!.getString("token")!));
      developer.log("Search results: " + escapeRoomsList.toString(), name: "mission_list_bloc");
      if (escapeRoomsList != null && escapeRoomsList!.escaperooms.isNotEmpty) {
        // AnalyticsUtils.logEventSearchEscape(escapeRoomsList!.escaperooms); --> TODO: LOG THE EVENT
        developer.log("Results found", name: "mission_list_bloc");
        yield MissionsByFilterLoaded(list: escapeRoomsList!);
      } else {
        developer.log("No results found", name: "mission_list_bloc");
        yield MissionsByFilterNoResults();
      }
    } catch (err) {
      yield MissionListError(error: "error");
    }
  }

  Stream<MissionListState> _mapLoadMoreMissionsByFiltersToState(
      LoadMoreMissionsByFilters event) async* {
    yield ShowResultsByFilter();
    try {
      escapeRoomsList = await _service?.searchEscapeRooms(event.filters, prefs!.getString("token")!);
      if (escapeRoomsList != null) {
        // nalyticsUtils.logEventSearchEscape(escapeRoomsList.escaperooms); --> TODO: LOG THE EVENT
        yield MissionsByFilterLoaded(list: escapeRoomsList!);
      }
      //} else {
      // yield MissionsByFilterNoResults();
      // }
    } catch (err) {
      yield MissionListError(error: "error");
    }
  }

  Stream<MissionListState> _mapMissionsByCompanyToState(GetMissionsByCompany event) async* {
    yield MissionListLoading();
    try {
      escapeRoomsList = await _service?.getMissionsByCompany(event.id, prefs!.getString("token")!, event.page);
      if (escapeRoomsList != null && escapeRoomsList!.escaperooms.isNotEmpty) {
        yield MissionsByCompanyLoaded(list: escapeRoomsList!);
      } else {
        yield MissionsByCompanyNoResults();
      }
    } catch (err) {
      yield MissionListError(error: "error");
    }
  }

  Stream<MissionListState> _mapMoreMissionsByCompanyToState(LoadMoreMissionsByCompany event) async* {
    yield ShowResultsByFilter();
    try {
      escapeRoomsList = await _service?.getMissionsByCompany(event.id, prefs!.getString("token")!, event.page);
      if (escapeRoomsList != null && escapeRoomsList!.escaperooms.isNotEmpty) {
        yield MissionsByCompanyLoaded(list: escapeRoomsList!);
      } else {
        yield MissionsByCompanyNoResults();
      }
    } catch (err) {
      yield MissionListError(error: "error");
    }
  }

  Stream<MissionListState> _mapMissionsByIdToState(
      GetMissionsById event) async* {
    yield MissionListLoading();
    try {
      escapeRoom = await _service?.getMissionsById(event.id, prefs!.getString("token")!);
      if (escapeRoom != null) {
        yield MissionByIdLoaded(escape: escapeRoom!);
      } else {
        yield MissionByIdNoResults();
      }
    } catch (err) {
      yield MissionListError(error: "error");
    }
  }

  Stream<MissionListState> _mapMissionsNewToState(GetMissionsNew event) async* {
    yield MissionListLoading();
    try {
      escapeRoomsList = await _service?.getNewMissions(prefs!.getString("token")!);
      if (escapeRoomsList != null) {
        yield MissionsNewLoaded(list: escapeRoomsList!);
      } else {
        yield MissionListError(error: 'error.topics');
      }
    } catch (err) {
      yield MissionListError(error: "error");
    }
  }
}