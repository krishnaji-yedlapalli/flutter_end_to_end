import 'package:equatable/equatable.dart';
import 'package:sample_latest/features/schools/shared/models/school_view_model.dart';

class SchoolsUiModel extends Equatable {
  final String header;
  final String searchLabel;
  final String filterByLabel;
  final List<SchoolViewModel> schools;

  const SchoolsUiModel(
      {required this.header,
      required this.searchLabel,
      required this.filterByLabel,
      required this.schools});

  @override
  List<Object?> get props => [header, searchLabel, filterByLabel, schools];

  SchoolsUiModel copyWith(
      {String? header,
      String? searchLabel,
      String? filterByLabel,
      List<SchoolViewModel>? schools}) {
    return SchoolsUiModel(
        header: header ?? this.header,
        searchLabel: searchLabel ?? this.searchLabel,
        filterByLabel: filterByLabel ?? this.filterByLabel,
        schools: schools ?? this.schools);
  }
}

enum SchoolActionType { edit, delete, select }
