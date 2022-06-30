part of 'new_missions_row_bloc.dart';

class NewMissionsRowState {}

// GENERAL missions states
class NewMissionsRowStateLoading extends NewMissionsRowState{}
class NewMissionsRowStateError extends NewMissionsRowState{
  final String error;

  NewMissionsRowStateError(this.error);
}

// NEW missions states
class NewMissionsRowStateLoaded extends NewMissionsRowState{
  // Escapes that will be in the 'New' row
  final EscapeRoomsList list;
  NewMissionsRowStateLoaded(this.list);
}