import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/featured_missions/featured_missions_row_event.dart';
import 'package:flutter_escaperank_web/models/escaperooms_list.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'featured_missions_row_state.dart';

class FeaturedMissionsRowBloc extends Bloc<FeaturedMissionsRowEvent, FeaturedMissionsRowState>{
  EscapeRoomsList? escapeRoomsList;
  EscapeRoomServices escapeRoomServices;
  SharedPreferences? prefs;

  FeaturedMissionsRowBloc({required this.escapeRoomServices}) : super(FeaturedMissionsRowStateLoading());

  @override
  Stream<FeaturedMissionsRowState> mapEventToState(FeaturedMissionsRowEvent event) async* {
    // Load preferences
    prefs = await SharedPreferences.getInstance();
    // If event is Load --> New Missions Row
    if (event is FeaturedMissionsRowEventLoad){
      yield* _getFeaturedMissions(event);
    }

  }

  // REAFUTERD row in home page
  Stream<FeaturedMissionsRowState> _getFeaturedMissions (FeaturedMissionsRowEventLoad event) async* {
    yield FeaturedMissionsRowStateLoading();
    try {
      // TODO: Get location
      // TODO: Change called function from getNewMissions to getFeaturedMissions (payment...)
      escapeRoomsList = await escapeRoomServices.getNewMissions(prefs?.getString("token") ?? "error");
      if (escapeRoomsList != null) {
        yield FeaturedMissionsRowStateLoaded(escapeRoomsList!);
      } else {
        yield FeaturedMissionsRowStateError("error.topics");
      }
    } catch (err) {
      yield FeaturedMissionsRowStateError(err.toString());
    }
  }
}