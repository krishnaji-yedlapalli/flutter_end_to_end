// Mocks generated by Mockito 5.4.4 from annotations
// in sample_latest/test/unit_testing/bloc/school_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:mockito/mockito.dart' as _i1;
import 'package:sample_latest/features/schools/data/model/school_details_model.dart' as _i3;
import 'package:sample_latest/features/schools/data/model/school_model.dart' as _i4;
import 'package:sample_latest/features/schools/data/model/student_model.dart' as _i5;
import 'package:sample_latest/core/data/base_service.dart' as _i2;
import 'package:sample_latest/features/schools/data/repository/school_repository.dart'
    as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBaseService_0 extends _i1.SmartFake implements _i2.BaseService {
  _FakeBaseService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSchoolDetailsModel_1 extends _i1.SmartFake
    implements _i3.SchoolDetailsModel {
  _FakeSchoolDetailsModel_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSchoolModel_2 extends _i1.SmartFake implements _i4.SchoolModel {
  _FakeSchoolModel_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStudentModel_3 extends _i1.SmartFake implements _i5.StudentModel {
  _FakeStudentModel_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SchoolRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSchoolRepository extends _i1.Mock implements _i6.SchoolRepository {
  MockSchoolRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.BaseService get baseService => (super.noSuchMethod(
        Invocation.getter(#baseService),
        returnValue: _FakeBaseService_0(
          this,
          Invocation.getter(#baseService),
        ),
      ) as _i2.BaseService);

  @override
  _i7.Future<List<_i4.SchoolModel>> fetchSchools() => (super.noSuchMethod(
        Invocation.method(
          #fetchSchools,
          [],
        ),
        returnValue:
            _i7.Future<List<_i4.SchoolModel>>.value(<_i4.SchoolModel>[]),
      ) as _i7.Future<List<_i4.SchoolModel>>);

  @override
  _i7.Future<_i5.StudentModel?> fetchStudent(
    String? studentId,
    String? schoolId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchStudent,
          [
            studentId,
            schoolId,
          ],
        ),
        returnValue: _i7.Future<_i5.StudentModel?>.value(),
      ) as _i7.Future<_i5.StudentModel?>);

  @override
  _i7.Future<_i3.SchoolDetailsModel?> fetchSchoolDetails(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchSchoolDetails,
          [id],
        ),
        returnValue: _i7.Future<_i3.SchoolDetailsModel?>.value(),
      ) as _i7.Future<_i3.SchoolDetailsModel?>);

  @override
  _i7.Future<List<_i5.StudentModel>> fetchStudents(String? schoolId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchStudents,
          [schoolId],
        ),
        returnValue:
            _i7.Future<List<_i5.StudentModel>>.value(<_i5.StudentModel>[]),
      ) as _i7.Future<List<_i5.StudentModel>>);

  @override
  _i7.Future<_i3.SchoolDetailsModel> addOrEditSchoolDetails(
          _i3.SchoolDetailsModel? schoolDetails) =>
      (super.noSuchMethod(
        Invocation.method(
          #addOrEditSchoolDetails,
          [schoolDetails],
        ),
        returnValue:
            _i7.Future<_i3.SchoolDetailsModel>.value(_FakeSchoolDetailsModel_1(
          this,
          Invocation.method(
            #addOrEditSchoolDetails,
            [schoolDetails],
          ),
        )),
      ) as _i7.Future<_i3.SchoolDetailsModel>);

  @override
  _i7.Future<_i4.SchoolModel> createOrEditSchool(_i4.SchoolModel? school) =>
      (super.noSuchMethod(
        Invocation.method(
          #createOrEditSchool,
          [school],
        ),
        returnValue: _i7.Future<_i4.SchoolModel>.value(_FakeSchoolModel_2(
          this,
          Invocation.method(
            #createOrEditSchool,
            [school],
          ),
        )),
      ) as _i7.Future<_i4.SchoolModel>);

  @override
  _i7.Future<_i5.StudentModel> createOrEditStudent(
    String? schoolId,
    _i5.StudentModel? student,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createOrEditStudent,
          [
            schoolId,
            student,
          ],
        ),
        returnValue: _i7.Future<_i5.StudentModel>.value(_FakeStudentModel_3(
          this,
          Invocation.method(
            #createOrEditStudent,
            [
              schoolId,
              student,
            ],
          ),
        )),
      ) as _i7.Future<_i5.StudentModel>);

  @override
  _i7.Future<bool> deleteSchool(String? schoolId) => (super.noSuchMethod(
        Invocation.method(
          #deleteSchool,
          [schoolId],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);

  @override
  _i7.Future<bool> deleteStudent(
    String? studentId,
    String? schoolId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteStudent,
          [
            studentId,
            schoolId,
          ],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
}
