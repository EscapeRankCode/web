import 'dart:io';
import 'package:flutter_escaperank_web/models/topic_list.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


abstract class FiltersState extends Equatable{
  @override
  List<Object> get props => [];
}

class FiltersInitial extends FiltersState {}

class FiltersLoading extends FiltersState {}

class TopicsSuccess extends FiltersState {
  final TopicList topicList;
  TopicsSuccess({required this.topicList});

  @override
  List<Object> get props => [topicList];
}

class TopicsFailure extends FiltersState {
  final String error;

  TopicsFailure({required this.error});

  @override
  List<Object> get props => [error];
}