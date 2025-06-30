

import '../../data/respository/on_off_repository.dart';

class OnOffUsecase {

final OnOffRepository _repository;

OnOffUsecase(this._repository);

  Future<bool> status() async {
return _repository.getStatus();
  }

Future<bool> on() async {
  return _repository.on();
}

Future<bool> off() async {
  return _repository.off();
}
}