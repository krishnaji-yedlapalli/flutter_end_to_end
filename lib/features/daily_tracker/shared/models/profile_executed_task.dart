import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';

class ProfileExecutedTask {
  late ProfileEntity _profileEntity;

  var todayEvents = <EventEntity>[];

  var userEvents = <EventEntity>[];

  set setProfile(ProfileEntity profileEntity) {
    _profileEntity = profileEntity;
  }

  String get profileId => _profileEntity.id;
}
