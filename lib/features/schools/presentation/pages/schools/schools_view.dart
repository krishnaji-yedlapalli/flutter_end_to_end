import 'package:flutter/material.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:sample_latest/features/feature_discovery/school_feature_discovery.dart';
import 'package:sample_latest/features/schools/presentation/pages/schools/widgets/schools_offline_actions.dart';
import 'package:sample_latest/features/schools/presentation/ui_models/schools_ui_model.dart';
import 'package:sample_latest/features/schools/shared/models/school_view_model.dart';
import 'package:sample_latest/shared/extensions/extensions.dart';
import 'package:sample_latest/shared/mixins/helper_widgets_mixin.dart';

import '../../../../../shared/widgets/responsive_widgets/widgets.dart';

class SchoolsView extends StatelessWidget with HelperWidget {
  const SchoolsView({required this.schools, required this.onTap, super.key});

  final List<SchoolViewModel> schools;
  final Function(SchoolViewModel school, SchoolActionType type) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SchoolsOfflineActions(),
        Expanded(child: _buildRegisteredSchools(schools)),
      ],
    ).screenPadding();
  }

  Widget _buildRegisteredSchools(List<SchoolViewModel> schools) {
    if (schools.isEmpty) {
      return emptyMessage('No Schools Found, Create a new School');
    }

    return AdaptiveContainer(
      child: _buildSchoolListView(schools),
    );
  }

  Widget _buildSchoolListView(List<SchoolViewModel> schools) {
    return ListView.separated(
        itemCount: schools.length,
        itemBuilder: (context, index) {
          var school = schools.elementAt(index);
          return ListTile(
            leading: const Icon(Icons.school),
            title: Text(school.schoolName),
            subtitle: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                  TextSpan(
                      text: 'Country :',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: Colors.blue)),
                  TextSpan(text: school.country),
                ])),
            trailing: Wrap(
              children: [
                SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                    type: SchoolDiscoverFeatureType.edit,
                    child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onTap(school, SchoolActionType.edit))),
                SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                    type: SchoolDiscoverFeatureType.delete,
                    child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            onTap(school, SchoolActionType.delete)))
              ],
            ),
            onTap: () => onTap(school, SchoolActionType.select),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }
}
