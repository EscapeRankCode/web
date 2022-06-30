part of 'featured_missions_row_bloc.dart';

class FeaturedMissionsRowState {}

// GENERAL missions states
class FeaturedMissionsRowStateLoading extends FeaturedMissionsRowState{}
class FeaturedMissionsRowStateError extends FeaturedMissionsRowState{
  final String error;

  FeaturedMissionsRowStateError(this.error);
}

// NEW missions states
class FeaturedMissionsRowStateLoaded extends FeaturedMissionsRowState{
  // Escapes that will be in the 'New' row
  final EscapeRoomsList list;
  FeaturedMissionsRowStateLoaded(this.list);
}