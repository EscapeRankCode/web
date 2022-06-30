
import 'package:equatable/equatable.dart';
import 'package:flutter_escaperank_web/models/filter_escaperoom.dart';

abstract class MissionListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMissionsByFilters extends MissionListEvent {
  final FiltersEscapeRoom filters;
  GetMissionsByFilters({required this.filters});
}


class LoadMoreMissionsByFilters extends MissionListEvent {
  final FiltersEscapeRoom filters;
  LoadMoreMissionsByFilters({required this.filters});
}

class ShowResults extends MissionListEvent {
  ShowResults();
}

class GetMissionsByCompany extends MissionListEvent {
  final int id;
  final int page;
  GetMissionsByCompany({required this.id, required this.page});

  @override
  List<Object> get props => [id, page];
}

class LoadMoreMissionsByCompany extends MissionListEvent {
  final int id;
  final int page;

  LoadMoreMissionsByCompany({required this.id, required this.page});

  @override
  List<Object> get props => [id, page];
}

class CheckFavMissions extends MissionListEvent {
  final String token;

  CheckFavMissions({required this.token});

  @override
  List<Object> get props => [token];
}

class GetMissionsById extends MissionListEvent {

  final String id;

  GetMissionsById({required this.id});

  @override
  List<Object> get props => [id];
}



class GetMissionsNew extends MissionListEvent {
  //final double latitude;
  //final double longitude;
  //final int radius;
  GetMissionsNew();
//GetMissionsNew({@required this.latitude, @required this.longitude, @required this.radius});

//@override
//List<Object> get props => [longitude, latitude, radius];
}