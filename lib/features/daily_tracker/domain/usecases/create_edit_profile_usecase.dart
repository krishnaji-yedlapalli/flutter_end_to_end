import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/profiles_repository.dart';
import 'package:sample_latest/features/daily_tracker/shared/models/profiles_executed_task.dart';
import 'package:sample_latest/features/daily_tracker/shared/params/profile_params.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../../../core/mixins/helper_methods.dart';

class CreateOrEditProfileUseCase {
  final ProfilesRepository _profilesRepository;

  final ProfilesExecutedTask _profilesExecutedTask;

  CreateOrEditProfileUseCase(this._profilesRepository, this._profilesExecutedTask);

  Future<Either<List<ProfileEntity>, ErrorDetails>> call(ProfileParams params) async {
    try {
      var profiles = await (params.id != null ? _editProfile(params) : _createProfile(params));
      return Left(profiles);
    } catch (e, s) {
      return Right(ExceptionHandler().handleException(e, s));
    }
  }

  Future<List<ProfileEntity>> _createProfile(ProfileParams params) async{
    var profile = ProfileEntity(HelperMethods.uuid, params.name);
    profile = await _profilesRepository.createOrEditProfile(profile);
    _profilesExecutedTask.addProfile = profile;
    return _profilesExecutedTask.profiles;
  }

  Future<List<ProfileEntity>> _editProfile(ProfileParams params) async {
    var profile = ProfileEntity(params.id ?? HelperMethods.uuid, params.name);
    profile = await _profilesRepository.createOrEditProfile(profile);
    _profilesExecutedTask.updateProfile = profile;
    return _profilesExecutedTask.profiles;
  }
}
