import 'package:bloc/bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/new_missions/new_missions_row_event.dart';
import 'package:flutter_escaperank_web/models/escaperooms_list.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'new_missions_row_state.dart';

class NewMissionsRowBloc extends Bloc<NewMissionsRowEvent, NewMissionsRowState>{
  EscapeRoomsList? escapeRoomsList;
  EscapeRoomServices escapeRoomServices;
  SharedPreferences? prefs;

  NewMissionsRowBloc({required this.escapeRoomServices}) : super(NewMissionsRowStateLoading());

  @override
  Stream<NewMissionsRowState> mapEventToState(NewMissionsRowEvent event) async* {
    // Load preferences
    prefs = await SharedPreferences.getInstance();
    // If event is Load --> New Missions Row
    if (event is NewMissionsRowEventLoad){
      yield* _getNewMissions(event);
    }
  }

  // NEW row in home page
  Stream<NewMissionsRowState> _getNewMissions (NewMissionsRowEventLoad event) async* {
    yield NewMissionsRowStateLoading();
    try {
      escapeRoomsList = await escapeRoomServices.getNewMissions(prefs?.getString("token") ?? "error");
      if (escapeRoomsList != null) {
        yield NewMissionsRowStateLoaded(escapeRoomsList!);
      } else {
        yield NewMissionsRowStateError("error.topics");
      }
    } catch (err) {
      yield NewMissionsRowStateError(err.toString());
    }
  }


}