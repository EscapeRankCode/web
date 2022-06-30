import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FiltersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTopics extends FiltersEvent {
  LoadTopics();
}