

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterHelper {

  static String? redirectWithToast(BuildContext context,{required GoRouterState state, required String redirectPath, required List<String> paramKeys, required toastMessage}) {
    if(paramKeys.any((key) => !state.uri.queryParameters.containsKey(key))){
      return redirectPath;
    }
    return null;
  }
}
