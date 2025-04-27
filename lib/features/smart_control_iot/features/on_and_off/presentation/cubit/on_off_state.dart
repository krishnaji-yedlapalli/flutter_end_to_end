
import 'package:equatable/equatable.dart';

abstract class OnOffState extends Equatable {

  const OnOffState();
}

class OnOffStateLoading extends OnOffState {

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class CurrentOnOffState extends OnOffState {

  final bool status;

  const CurrentOnOffState(this.status);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}