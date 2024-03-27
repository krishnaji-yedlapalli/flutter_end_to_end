
import 'package:flutter/material.dart';
import 'package:sample_latest/services/utils/service_enums_typedef.dart';
import 'package:sample_latest/utils/device_configurations.dart';

import '../../utils/enums_type_def.dart';

class ExceptionView extends StatelessWidget {
  final ErrorDetails stateType;
  
  const ExceptionView(this.stateType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: switch(stateType.$1){
        
        DataErrorStateType.noInternet  => _buildNoInternetView(),
         
        DataErrorStateType.serverNotFound => _buildServerNotFound(),
        
        DataErrorStateType.somethingWentWrong || DataErrorStateType.none || DataErrorStateType.fetchData => _buildUnknownException(),
        
        DataErrorStateType.unauthorized => _buildUnauthorized(),

        DataErrorStateType.timeoutException => _buildTimeoutException(),
        // TODO: Handle this case.
        DataErrorStateType.offlineError => _buildOfflineException(),
    }
    );
  }

  Widget _buildNoInternetView() {
   return _buildTitleWithImage(
     title: 'No Internet Connection',
     image: 'asset/exception_error/no_internet.png'
   );
  }
  
  Widget _buildUnknownException() {
        return _buildTitleWithImage(
          image: 'asset/exception_error/something_went_wrong.png',
          title: 'Some thing went Wrong'
        );
  }
  
  Widget _buildServerNotFound() {
        return _buildTitleWithImage(
            image: 'asset/exception_error/something_went_wrong.png',
            title: 'Server Not Found'
        );
  }
  
  Widget _buildUnauthorized() {
    return _buildTitleWithImage(
        image: 'asset/exception_error/no_access.png',
        title: 'Some thing went Wrong'
    );
  }

  Widget _buildTimeoutException() {
    return _buildTitleWithImage(
        image: 'asset/exception_error/timeout.png',
        title: 'Some thing went Wrong'
    );
  }

  Widget _buildOfflineException() {
    return _buildTitleWithImage(
        image: 'asset/exception_error/offline_error.png',
        title: stateType.message ?? ''
    );
  }

  Widget _buildTitleWithImage({required String title, required String image}) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        double? size = DeviceConfiguration.isMobileResolution ? null :  constraints.maxHeight/2;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, fit: BoxFit.scaleDown, height: size, width: size),
              const SizedBox(height: 5),
              Text(title, style: Theme.of(context).textTheme.titleLarge?.apply(color: Colors.black))
            ]
          ),
        );
      }
    );
  }
  
}
