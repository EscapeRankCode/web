import 'package:equatable/equatable.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/models/escaperooms_list.dart';

abstract class MissionListState extends Equatable {
  @override
  List<Object> get props => [];
}

class MissionListInitState extends MissionListState {}

class MissionListLoading extends MissionListState {}


class MissionByFiltersLoaded extends MissionListState {
  final EscapeRoomsList list;
  MissionByFiltersLoaded({required this.list});
}

class MissionsByCompanyLoaded extends MissionListState {
  final EscapeRoomsList list;
  MissionsByCompanyLoaded({required this.list});
}

class FavMissionsLoaded extends MissionListState {
  final EscapeRoomsList list;
  FavMissionsLoaded({required this.list});
}

class MissionByIdLoaded extends MissionListState {
  final EscapeRoom escape;
  MissionByIdLoaded({required this.escape});
}


class MissionsNewLoaded extends MissionListState {
  final EscapeRoomsList list;
  MissionsNewLoaded({required this.list});
}

class ShowResultsByFilter extends MissionListState {

}

class MissionsByFilterLoaded extends MissionListState {
  final EscapeRoomsList list;
  MissionsByFilterLoaded({required this.list});
}

class MissionListError extends MissionListState {
  final error;
  MissionListError({this.error});
}

class MissionsByFilterNoResults extends MissionListState {}

class MissionsByCompanyNoResults extends MissionListState {}

class FavMissionsNoResults extends MissionListState {}

class MissionByIdNoResults extends MissionListState {}